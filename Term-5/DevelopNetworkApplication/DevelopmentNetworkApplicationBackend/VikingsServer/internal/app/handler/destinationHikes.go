package handler

import (
	"VikingsServer/internal/app/ds"
	"github.com/gin-gonic/gin"
	"net/http"
)

func (h *Handler) DestinationHikesList(ctx *gin.Context) {
	destinationHikes, err := h.Repository.DestinationHikesList()
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "destination_hikes", destinationHikes)
}

// UpdateDestinationHikeNumber godoc
// @Summary Обновление порядка локаций похода
// @Description Обновление порядкого номера города в истории похода
// @Tags Пункты походов
// @Accept json
// @Produce json
// @Param request body ds.UpdateDestinationHikeNumberReq true "Данные для добавления города в поход"
// @Success 200 {object} ds.UpdateDestinationHikeNumberRes "Updated Destination Hike ID"
// @Failure 400 {object} errorResp "Плохой запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибку"
// @Router /api/v3/destination-hikes [put]
func (h *Handler) UpdateDestinationHikeNumber(ctx *gin.Context) {
	var body struct {
		DestinationHikeID int `json:"id"`
		SerialNumber      int `json:"serial_number"`
	}
	if err := ctx.BindJSON(&body); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	if body.SerialNumber == 0 || body.DestinationHikeID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, serialNumberAndDestinationHikeIDCannotBeEmpty)
		return
	}
	dh, err := h.Repository.UpdateDestinationHikeNumber(body.DestinationHikeID, body.SerialNumber)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "id", dh.ID)
}

// DeleteDestinationToHike godoc
// @Summary Удаление локации из похода
// @Description Удаление локации из истории похода по идентификатору
// @Tags Пункты походов
// @Accept json
// @Produce json
// @Param request body ds.DeleteDestinationToHikeReq true "Идентификатор локации в походе"
// @Success 200 {object} ds.DeleteDestinationToHikeRes "Удаленный идентификатор локации"
// @Failure 400 {object} errorResp "Плохой запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/destination-hikes [delete]
func (h *Handler) DeleteDestinationToHike(ctx *gin.Context) {
	var body struct {
		ID int `json:"id"`
	}
	if err := ctx.BindJSON(&body); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	if body.ID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}
	if err := h.Repository.DeleteDestinationToHike(body.ID); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "deleted_destination_hike", body.ID)
}

func (h *Handler) AddDestinationToHike(ctx *gin.Context) {
	var body struct {
		Hike         ds.Hike `json:"hike"`
		City         ds.City `json:"city"`
		SerialNumber int     `json:"serial_number"`
	}
	if err := ctx.BindJSON(&body); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	if body.SerialNumber == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, serialNumberCannotBeEmpty)
		return
	}

	/// Определяем, какой метод использовать. С id или без
	if body.Hike.ID == 0 {
		if errorCode, err := h.createHike(&body.Hike); err != nil {
			h.errorHandler(ctx, errorCode, err)
			return
		}
	}

	/// Определяем, какой метод использовать. С id или без
	if body.City.ID == 0 {
		if errorCode, err := h.createCity(&body.City); err != nil {
			h.errorHandler(ctx, errorCode, err)
			return
		}
	}

	if body.Hike.ID == 0 || body.City.ID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, destinationOrCityIsEmpty)
		return
	}

	destinationHike := ds.DestinationHikes{
		City:         body.City,
		Hike:         body.Hike,
		SerialNumber: body.SerialNumber,
	}

	if err := h.Repository.AddDestinationToHike(&destinationHike); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successAddHandler(ctx, "updated_destination_hike", destinationHike)
}

func (h *Handler) createHike(hike *ds.Hike) (int, error) {
	if hike.ID != 0 {
		return http.StatusBadRequest, idMustBeEmpty
	}
	if err := h.Repository.AddHike(hike); err != nil {
		return http.StatusInternalServerError, err
	}
	return 0, nil
}
