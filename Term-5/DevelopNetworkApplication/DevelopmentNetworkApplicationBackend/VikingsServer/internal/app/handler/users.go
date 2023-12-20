package handler

import (
	"VikingsServer/internal/app/ds"
	"VikingsServer/internal/app/role"
	"crypto/sha1"
	"encoding/hex"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/goccy/go-json"
	"github.com/golang-jwt/jwt"
	"net/http"
	"strings"
	"time"
)

// Register godoc
// @Summary Регистрация пользователя
// @Description Регистрация нового пользователя.
// @Tags Пользователи
// @Accept json
// @Produce json
// @Param request body ds.RegisterReq true "Детали регистрации"
// @Router /api/v3/users/sign_up [post]
func (h *Handler) Register(ctx *gin.Context) {
	req := &ds.RegisterReq{}

	err := json.NewDecoder(ctx.Request.Body).Decode(req)
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	if req.Password == "" {
		h.errorHandler(ctx, http.StatusBadRequest, fmt.Errorf("pass is empty"))
		return
	}

	if req.Login == "" {
		h.errorHandler(ctx, http.StatusBadRequest, fmt.Errorf("name is empty"))
		return
	}

	if err = h.Repository.Register(&ds.User{
		UserName: req.Name,
		Role:     role.Buyer,
		Login:    req.Login,
		Password: generateHashString(req.Password),
	}); err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	ctx.JSON(http.StatusOK, &ds.RegisterResp{
		Ok: true,
	})
}

// Login godoc
// @Summary Аутентификация пользователя
// @Description Вход нового пользователя.
// @Tags Пользователи
// @Accept json
// @Produce json
// @Param request body ds.RegisterReq true "Детали входа"
// @Success 200 {object} ds.LoginSwaggerResp "Успешная аутентификация"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 401 {object} errorResp "Неверные учетные данные"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/users/login [post]
func (h *Handler) Login(ctx *gin.Context) {
	cfg := h.Config
	req := &ds.LoginReq{}

	if err := json.NewDecoder(ctx.Request.Body).Decode(req); err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}
	user, err := h.Repository.GetUserByLogin(req.Login)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	if req.Login == user.Login && user.Password == generateHashString(req.Password) {
		token := jwt.NewWithClaims(cfg.JWT.SigningMethod, &ds.JWTClaims{
			StandardClaims: jwt.StandardClaims{
				ExpiresAt: time.Now().Add(cfg.JWT.ExpiresIn).Unix(),
				IssuedAt:  time.Now().Unix(),
				Issuer:    "bitop-admin",
			},
			UserID: user.ID,
			Role:   user.Role,
		})

		if token == nil {
			h.errorHandler(ctx, http.StatusInternalServerError, tokenIsNil)
			return
		}

		strToken, err := token.SignedString([]byte(cfg.JWT.Token))
		if err != nil {
			h.errorHandler(ctx, http.StatusInternalServerError, cannotCreateToken)
			return
		}

		ctx.JSON(http.StatusOK, gin.H{
			"expires_in":   cfg.JWT.ExpiresIn,
			"access_token": strToken,
			"token_type":   "Bearer",
			"role":         user.Role,
			"userName":     user.UserName,
			"userImage":    user.ImageURL,
		})
		return
	}

	h.errorHandler(ctx, http.StatusBadRequest, errors.New("incorrect login or password"))
}

func (h *Handler) UsersList(ctx *gin.Context) {
	users, err := h.Repository.UsersList()
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	h.successHandler(ctx, "users", users)
}

// Logout godoc
// @Summary Выход пользователя
// @Description Завершение сеанса текущего пользователя.
// @Tags Пользователи
// @Accept json
// @Produce json
// @Security ApiKeyAuth
// @Success 200 {string} string "Успешный выход"
// @Failure 400 {object} errorResp "Неверный запрос"
// @Failure 401 {object} errorResp "Неверные учетные данные"
// @Failure 500 {object} errorResp "Внутренняя ошибка сервера"
// @Router /api/v3/users/logout [get]
func (h *Handler) Logout(ctx *gin.Context) {
	jwtStr := ctx.GetHeader("Authorization")
	if !strings.HasPrefix(jwtStr, jwtPrefix) {
		ctx.AbortWithStatus(http.StatusBadRequest)
		return
	}
	jwtStr = jwtStr[len(jwtPrefix):]

	_, err := jwt.ParseWithClaims(jwtStr, &ds.JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(h.Config.JWT.Token), nil
	})
	if err != nil {
		h.errorHandler(ctx, http.StatusBadRequest, err)
		return
	}

	err = h.Redis.WriteJWTToBlacklist(ctx.Request.Context(), jwtStr, h.Config.JWT.ExpiresIn)
	if err != nil {
		h.errorHandler(ctx, http.StatusInternalServerError, err)
		return
	}

	ctx.Status(http.StatusOK)
}

// MARK: - Inner functions

func generateHashString(s string) string {
	h := sha1.New()
	h.Write([]byte(s))
	return hex.EncodeToString(h.Sum(nil))
}
