package handler

import (
	"VikingsServer/internal/app/ds"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"mime/multipart"
	"net/http"
	"strconv"
	"strings"
)

// CitiesList godoc
// @Summary Список городов
// @Security ApiKeyAuth
// @Description Получение города(-ов) и фильтрация при поиске
// @Tags Города
// @Produce json
// @Param city query string false "Получаем определённый город"
// @Param search query string false "Фильтрация поиска"
// @Success 200 {object} ds.CitiesListResp
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities [get]
func (h *Handler) CitiesList(ctx *gin.Context) {
	if idStr := ctx.Query("city"); idStr != "" {
		cityById(ctx, h, idStr)
		return
	}
	cities, err := h.Repository.CitiesList()
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	userID, existsUser := ctx.Get("user_id")
	var basketIdRes uint = 0
	if existsUser {
		basketId, errBask := h.Repository.HikeBasketId(userID.(uint))
		if errBask != nil {
			h.errorHandler(ctx, http.StatusInternalServerError, errBask)
			return
		}
		basketIdRes = basketId
	}

	searchText := ctx.Query("search")
	if searchText != "" {
		var filteredCities []ds.City
		for _, city := range *cities {
			if strings.Contains(strings.ToLower(city.CityName), strings.ToLower(searchText)) {
				filteredCities = append(filteredCities, city)
			}
		}
		registerFrontHeaders(ctx)
		ctx.JSON(http.StatusOK, gin.H{
			"status":    "success",
			"cities":    filteredCities,
			"basket_id": basketIdRes,
		})
		return
	}

	registerFrontHeaders(ctx)
	ctx.JSON(http.StatusOK, gin.H{
		"status":    "success",
		"cities":    cities,
		"basket_id": basketIdRes,
	})
}

func cityById(ctx *gin.Context, h *Handler, idStr string) {
	id, err := strconv.Atoi(idStr)
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	city, errBD := h.Repository.CitiesById(uint(id))
	if errBD != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, errBD)
		return
	}

	h.successHandler(ctx, "city", city)
}

func (h *Handler) DeleteCityWithParam(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err2 := strconv.Atoi(idStr)
	if err2 != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err2)
		return
	}
	if id == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}
	if err := h.Repository.DeleteCity(uint(id)); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "deleted_id", id)
}

// AddCityIntoHike godoc
// @Summary Добавление города в поход
// @Security ApiKeyAuth
// @Tags Города
// @Description Добавление города в корзину. Если корзина не найдена, она будет сформирована
// @Accept json
// @Produce json
// @Param request body ds.AddCityIntoHikeReq true "Данные для добавления города в поход"
// @Success 200 {object} ds.AddCityIntoHikeResp "ID из destinationHikes"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities/add-city-into-hike [post]
func (h *Handler) AddCityIntoHike(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("user_id not found"))
		return
	}

	userIDUint, ok := userID.(uint)
	if !ok {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("`user_id` must be uint number"))
		return
	}
	var request struct {
		CityID       uint `json:"city_id"`
		SerialNumber int  `json:"serial_number"`
	}
	if err := ctx.BindJSON(&request); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	dhID, err := h.Repository.AddCityIntoHike(request.CityID, userIDUint, request.SerialNumber)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "id", dhID)
}

// DeleteCity godoc
// @Summary Удаление города
// @Description Удаление города по его идентификатору.
// @Security ApiKeyAuth
// @Tags Города
// @Accept json
// @Produce json
// @Param request body ds.DeleteCityReq true "ID города для удаления"
// @Success 200 {object} ds.DeleteCityRes "Город успешно удален"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities [delete]
func (h *Handler) DeleteCity(ctx *gin.Context) {
	var request struct {
		ID string `json:"id"`
	}
	if err := ctx.BindJSON(&request); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	id, err2 := strconv.Atoi(request.ID)
	if err2 != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err2)
		return
	}
	if id == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}
	if err := h.Repository.DeleteCity(uint(id)); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "deleted_id", id)
}

// AddImage godoc
// @Summary Загрузка изображения для города
// @Security ApiKeyAuth
// @Tags Города
// @Description Загрузка изображения для указанного города.
// @Accept multipart/form-data
// @Produce json
// @Param file formData file true "Изображение в формате файла"
// @Param city_id formData string true "Идентификатор города"
// @Success 201 {object} ds.AddImageRes "Успешная загрузка изображения"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities/upload-image [put]
func (h *Handler) AddImage(ctx *gin.Context) {
	file, header, err := ctx.Request.FormFile("file")
	cityID := ctx.Request.FormValue("city_id")

	if cityID == "" {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}
	if header == nil || header.Size == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, headerNotFound)
		return
	}
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	defer func(file multipart.File) {
		errLol := file.Close()
		if errLol != nil {
			h.errorHandler(ctx, http.StatusInternalServerError, errLol)
			return
		}
	}(file)

	// Upload the image to minio server.
	newImageURL, errorCode, errImage := h.createImageCity(&file, header, cityID)
	if errImage != nil {
		h.errorHandler(ctx, errorCode, errImage)
		return
	}

	h.successAddHandler(ctx, "image_url", newImageURL)
}

// Функция записи фото в минио
func (h *Handler) createImageCity(
	file *multipart.File,
	header *multipart.FileHeader,
	cityID string,
) (string, int, error) {
	newImageURL, errMinio := h.createImageInMinio(file, header)
	if errMinio != nil {
		return "", http.StatusInternalServerError, errMinio
	}
	if err := h.Repository.UpdateCityImage(cityID, newImageURL); err != nil {
		return "", http.StatusInternalServerError, err
	}
	return newImageURL, 0, nil
}

// AddCity godoc
// @Summary Создание города
// @Security ApiKeyAuth
// @Tags Города
// @Description Создание города
// @Accept  multipart/form-data
// @Produce  json
// @Param city_name formData string true "Название города"
// @Param status_id formData integer true "ID статуса города"
// @Param description formData string true "Описание города"
// @Param image_url formData file true "Изображение города"
// @Success 201 {object} ds.AddCityResp
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities [post]
func (h *Handler) AddCity(ctx *gin.Context) {
	file, header, err := ctx.Request.FormFile("image_url")
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	cityName := ctx.Request.FormValue("city_name")
	statusID := ctx.Request.FormValue("status_id")
	description := ctx.Request.FormValue("description")
	intStatus, errStatusInt := strconv.Atoi(statusID)
	if errStatusInt != nil {
		h.errorHandler(ctx, http.StatusBadRequest, errStatusInt)
		return
	}

	newCity := ds.City{
		CityName:    cityName,
		StatusID:    uint(intStatus),
		Description: description,
	}
	if errorCode, errCreate := h.createCity(&newCity); err != nil {
		h.errorHandler(ctx, errorCode, errCreate)
		return
	}
	newImageURL, errCode, errDB := h.createImageCity(&file, header, fmt.Sprintf("%d", newCity.ID))
	if errDB != nil {
		h.errorHandler(ctx, errCode, errDB)
		return
	}
	newCity.ImageURL = newImageURL

	h.successAddHandler(ctx, "city_id", newCity.ID)
}

func (h *Handler) createCity(city *ds.City) (int, error) {
	if city.ID != 0 {
		return http.StatusBadRequest, idMustBeEmpty
	}
	if city.CityName == "" {
		return http.StatusBadRequest, cityCannotBeEmpty
	}
	if err := h.Repository.AddCity(city); err != nil {
		return http.StatusBadRequest, err
	}
	return 0, nil
}

// UpdateCity godoc
// @Summary Обновление информации о городе
// @Security ApiKeyAuth
// @Tags Города
// @Description Обновление информации о городе
// @Accept json
// @Produce json
// @Param updated_city body ds.UpdateCityReq true "Обновленная информация о городе"
// @Success 200 {object} ds.UpdateCityResp
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/cities [put]
func (h *Handler) UpdateCity(ctx *gin.Context) {
	var updatedCity ds.City
	if err := ctx.BindJSON(&updatedCity); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	if updatedCity.ImageURL != "" {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New(`image_url must be empty`))
		return
	}

	if updatedCity.StatusID != 1 && updatedCity.StatusID != 2 {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New(`status_id must be 1 or 2`))
		return
	}

	if updatedCity.ID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}
	if err := h.Repository.UpdateCity(&updatedCity); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	h.successHandler(ctx, "updated_city", gin.H{
		"id":          updatedCity.ID,
		"city_name":   updatedCity.CityName,
		"status_id":   updatedCity.StatusID,
		"description": updatedCity.Description,
		"image_url":   updatedCity.ImageURL,
	})
}
