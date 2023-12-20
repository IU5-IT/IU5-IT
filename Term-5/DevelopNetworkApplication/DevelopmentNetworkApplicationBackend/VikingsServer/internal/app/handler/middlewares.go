package handler

import (
	"VikingsServer/internal/app/ds"
	"VikingsServer/internal/app/role"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/golang-jwt/jwt"
	"net/http"
	"strings"
)

const jwtPrefix = "Bearer "

func (h *Handler) WithAuthCheck(assignedRoles ...role.Role) func(ctx *gin.Context) {
	return func(gCtx *gin.Context) {
		jwtStr := gCtx.GetHeader("Authorization")
		if !strings.HasPrefix(jwtStr, jwtPrefix) {
			h.errorHandler(gCtx, http.StatusForbidden, errors.New("jwt token not found"))
			gCtx.AbortWithStatus(http.StatusForbidden)
			return
		}

		jwtStr = jwtStr[len(jwtPrefix):]
		err := h.Redis.CheckJWTInBlacklist(gCtx.Request.Context(), jwtStr)
		if err == nil {
			h.errorHandler(gCtx, http.StatusForbidden, err)
			gCtx.AbortWithStatus(http.StatusForbidden)
			return
		}
		if !errors.Is(err, redis.Nil) {
			h.errorHandler(gCtx, http.StatusInternalServerError, err)
			gCtx.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		token, errParse := jwt.ParseWithClaims(jwtStr, &ds.JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
			return []byte(h.Config.JWT.Token), nil
		})
		if errParse != nil {
			h.errorHandler(gCtx, http.StatusForbidden, err)
			gCtx.AbortWithStatus(http.StatusForbidden)
			return
		}

		myClaims := token.Claims.(*ds.JWTClaims)
		for _, oneOfAssignedRole := range assignedRoles {
			if myClaims.Role == oneOfAssignedRole {
				gCtx.Set("user_id", myClaims.UserID)
				gCtx.Set("user_role", myClaims.Role)
				gCtx.Next()
				return
			}
		}
		gCtx.AbortWithStatus(http.StatusForbidden)
		h.errorHandler(
			gCtx,
			http.StatusForbidden,
			fmt.Errorf("role %d is not assigned in %d", myClaims.Role, assignedRoles),
		)
		h.Logger.Errorf("role %d is not assigned in %d", myClaims.Role, assignedRoles)
		return
	}
}

func (h *Handler) WithoutJWTError(assignedRoles ...role.Role) func(ctx *gin.Context) {
	return func(gCtx *gin.Context) {
		jwtStr := gCtx.GetHeader("Authorization")
		if !strings.HasPrefix(jwtStr, jwtPrefix) {
			return
		}

		jwtStr = jwtStr[len(jwtPrefix):]
		err := h.Redis.CheckJWTInBlacklist(gCtx.Request.Context(), jwtStr)
		if err == nil {
			h.errorHandler(gCtx, http.StatusForbidden, err)
			gCtx.AbortWithStatus(http.StatusForbidden)
			return
		}
		if !errors.Is(err, redis.Nil) {
			h.errorHandler(gCtx, http.StatusInternalServerError, err)
			gCtx.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		token, errParse := jwt.ParseWithClaims(jwtStr, &ds.JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
			return []byte(h.Config.JWT.Token), nil
		})
		if errParse != nil {
			h.errorHandler(gCtx, http.StatusForbidden, err)
			gCtx.AbortWithStatus(http.StatusForbidden)
			return
		}

		myClaims := token.Claims.(*ds.JWTClaims)
		for _, oneOfAssignedRole := range assignedRoles {
			if myClaims.Role == oneOfAssignedRole {
				gCtx.Set("user_id", myClaims.UserID)
				gCtx.Set("user_role", myClaims.Role)
				gCtx.Next()
				return
			}
		}
		gCtx.AbortWithStatus(http.StatusForbidden)
		h.errorHandler(
			gCtx,
			http.StatusForbidden,
			fmt.Errorf("role %d is not assigned in %d", myClaims.Role, assignedRoles),
		)
		h.Logger.Errorf("role %d is not assigned in %d", myClaims.Role, assignedRoles)
		return
	}
}
