package handler

import (
	"VikingsServer/internal/app/ds"
	"VikingsServer/internal/app/role"
	"VikingsServer/internal/utils"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"time"
)

// HikesList godoc
// @Summary Список походов
// @Tags Походы
// @Security ApiKeyAuth
// @Description Получение списка походов с фильтрами по статусу, дате начала и дате окончания.
// @Produce json
// @Param status_id query string false "Статус похода. Возможные значения: 1, 2, 3, 4."
// @Param start_date query string false "Дата начала периода фильтрации в формате '2006-01-02'. Если не указана, используется '0001-01-01'."
// @Param end_date query string false "Дата окончания периода фильтрации в формате '2006-01-02'. Если не указана, используется текущая дата."
// @Success 200 {array} ds.HikesListRes "Список походов"
// @Success 200 {array} ds.HikesListRes2 "Список походов"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 204 {object} errorResp "Нет данных"
// @Router /api/v3/hikes [get]
func (h *Handler) HikesList(ctx *gin.Context) {
	userID, existsUser := ctx.Get("user_id")
	userRole, existsRole := ctx.Get("user_role")
	if !existsUser || !existsRole {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}
	switch userRole {
	case role.Buyer:
		h.hikeByUserId(ctx, fmt.Sprintf("%d", userID))
		return
	default:
		break
	}
	statusID := ctx.Query("status_id")
	startDateStr := ctx.Query("start_date")
	endDateStr := ctx.Query("end_date")

	if startDateStr == "" {
		startDateStr = "0001-01-01"
	}
	if endDateStr == "" {
		endDateStr = time.Now().Format("2006-01-02")
	}
	startDate, errStart := utils.ParseDateString(startDateStr)
	endDate, errEnd := utils.ParseDateString(endDateStr)
	h.Logger.Info(startDate, endDate)
	if errEnd != nil || errStart != nil {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New("incorrect `start_date` or `end_date`"))
		return
	}
	if isOk := utils.Contains([]string{"", "1", "2", "3", "4"}, statusID); !isOk {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New("param `status_id` not contains into [1, 2, 3, 4]"))
		return
	}
	hikes, err := h.Repository.HikesList(statusID, startDate, endDate)
	if err != nil {
		h.errorHandler(ctx, http.StatusNoContent, err)
		return
	}

	h.successHandler(ctx, "hikes", hikes)
}

// HikesListByID godoc
// @Summary Получение информации о походе по его ID.
// @Tags Походы
// @Description Получение информации о походе по его ID.
// @Produce json
// @Param id path string true "ID похода"
// @Success 200 {object} ds.HikesListRes2 "Информация о походе по ID"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 404 {object} errorResp "Поход не найден"
// @Router /api/v3/hikes/{id} [get]
func (h *Handler) HikesListByID(ctx *gin.Context) {
	if hikeIdString := ctx.Param("id"); hikeIdString != "" {
		hikeById(ctx, h, hikeIdString)
		return
	}

	h.errorHandler(ctx, http.StatusBadRequest, errors.New("param `id` not found"))
}

func (h *Handler) hikeByUserId(ctx *gin.Context, userID string) {
	hikes, errDB := h.Repository.HikeByUserID(userID)
	if errDB != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, errDB)
		return
	}

	h.successHandler(ctx, "hikes", hikes)
}

func hikeById(ctx *gin.Context, h *Handler, hikeStringID string) {
	hikeID, err := strconv.Atoi(hikeStringID)
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	hike, errDB := h.Repository.HikeByID(uint(hikeID))
	if errDB != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, errDB)
		return
	}
	h.successHandler(ctx, "hike", hike)
}

// DeleteHike godoc
// @Summary Удаление похода
// @Security ApiKeyAuth
// @Tags Походы
// @Description Удаление похода по идентификатору.
// @Accept json
// @Produce json
// @Param request body ds.DeleteHikeReq true "Идентификатор похода для удаления"
// @Success 200 {object} ds.DeleteHikeRes "Успешное удаление похода"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/hikes [delete]
func (h *Handler) DeleteHike(ctx *gin.Context) {
	userID, existsUser := ctx.Get("user_id")
	userRole, existsRole := ctx.Get("user_role")
	if !existsUser || !existsRole {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}
	var request struct {
		ID uint `json:"id"`
	}
	if err := ctx.BindJSON(&request); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	if request.ID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}

	hike, err := h.Repository.HikeByID(request.ID)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, fmt.Errorf("hike with `id` = %d not found", hike.ID))
		return
	}

	/// Если это пользователь и он меняет не свою заявку, ошибка
	if hike.UserID != userID && userRole == role.Buyer {
		h.errorHandler(ctx, http.StatusForbidden, errors.New("you are not the creator. you can't delete a hike"))
		return
	}

	if err := h.Repository.DeleteHike(request.ID); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "hike_id", request.ID)
}

// UpdateStatusForUser godoc
// @Summary Обновление статуса похода для пользователя. Т.е сформировать поход
// @Security ApiKeyAuth
// @Tags Походы
// @Description Обновление статуса похода для пользователя. Можно только сформировать(2)
// @Accept json
// @Produce json
// @Param body body ds.UpdateStatusForUserReq true "Детали обновления статуса [2]"
// @Success 200 {object} string "Успешное обновление статуса"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/hikes/update/status-for-user [put]
func (h *Handler) UpdateStatusForUser(ctx *gin.Context) {
	userID, existsUser := ctx.Get("user_id")
	if !existsUser {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}

	var body struct {
		StatusID uint `json:"status_id"`
	}

	if err := ctx.BindJSON(&body); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	if isOk := utils.Contains([]string{"2"}, strconv.Itoa(int(body.StatusID))); !isOk {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New("param `status_id` not contains into [2]"))
		return
	}

	HikeID, err := h.Repository.HikeBasketId(userID.(uint))
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New("basket is not created"))
		return
	}

	if err := h.Repository.UpdateStatusForUser(HikeID, body.StatusID); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	ctx.Status(http.StatusOK)
}

// UpdateStatusForModerator godoc
// @Summary Обновление статуса похода для модератора
// @Security ApiKeyAuth
// @Tags Походы
// @Description Обновление статуса похода для модератора. Можно только принять(3) отказать(4)
// @Accept json
// @Produce json
// @Param body body ds.UpdateStatusForModeratorReq true "Детали обновления статуса [3, 4]"
// @Success 200 {object} string "Успешное обновление статуса"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/hikes/update/status-for-moderator [put]
func (h *Handler) UpdateStatusForModerator(ctx *gin.Context) {
	var body struct {
		HikeID   uint `json:"hike_id"`
		StatusID uint `json:"status_id"`
	}
	userIDStr, existsUser := ctx.Get("user_id")
	if !existsUser {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}
	userID := userIDStr.(uint)

	if err := ctx.BindJSON(&body); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	if isOk := utils.Contains([]string{"3", "4"}, strconv.Itoa(int(body.StatusID))); !isOk {
		h.errorHandler(ctx, http.StatusBadRequest, errors.New("param `status_id` not contains into [3, 4]"))
		return
	}

	if err := h.Repository.UpdateHikeForModerator(body.HikeID, body.StatusID, userID); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	ctx.Status(http.StatusOK)
}

// UpdateHike godoc
// @Summary Обновление данных о походе
// @Security ApiKeyAuth
// @Tags Походы
// @Description Обновление данных о походе. Модератор и админ могут менять данные, пользователь может менять только свою
// @Accept json
// @Produce json
// @Param updatedHike body ds.UpdateHikeReq true "Данные для обновления похода"
// @Success 200 {object} ds.UpdatedHikeRes "Успешное обновление данных о походе"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/hikes [put]
func (h *Handler) UpdateHike(ctx *gin.Context) {
	userID, existsUser := ctx.Get("user_id")
	userRole, existsRole := ctx.Get("user_role")
	if !existsUser || !existsRole {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}
	var updatedHike ds.Hike
	if err := ctx.BindJSON(&updatedHike); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	if updatedHike.ID == 0 {
		h.errorHandler(ctx, http.StatusBadRequest, idNotFound)
		return
	}

	hike, err := h.Repository.HikeByID(updatedHike.ID)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, fmt.Errorf("hike with `id` = %d not found", hike.ID))
		return
	}

	/// Если это пользователь и он меняет не свою заявку, ошибка
	if hike.UserID != userID && userRole == role.Buyer {
		h.errorHandler(ctx, http.StatusForbidden, errors.New("you cannot change the hike if it's not yours"))
		return
	}

	if err := h.Repository.UpdateHike(&updatedHike); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "updated_hike", gin.H{
		"id":                       updatedHike.ID,
		"hike_name":                updatedHike.HikeName,
		"date_created":             updatedHike.DateCreated,
		"date_end":                 updatedHike.DateEnd,
		"date_start_of_processing": updatedHike.DateStartOfProcessing,
		"date_approve":             updatedHike.DateApprove,
		"date_start_hike":          updatedHike.DateStartHike,
		"user_id":                  updatedHike.UserID,
		"status_id":                updatedHike.StatusID,
		"description":              updatedHike.Description,
	})
}

func (h *Handler) HikeCurrent(ctx *gin.Context) {
	userID, existsUser := ctx.Get("user_id")
	if !existsUser {
		h.errorHandler(ctx, http.StatusUnauthorized, errors.New("not fount `user_id` or `user_role`"))
		return
	}

	hikes, errDB := h.Repository.HikeBasketId(userID.(uint))
	if errDB != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, errDB)
		return
	}

	h.successHandler(ctx, "hikes", hikes)
}
