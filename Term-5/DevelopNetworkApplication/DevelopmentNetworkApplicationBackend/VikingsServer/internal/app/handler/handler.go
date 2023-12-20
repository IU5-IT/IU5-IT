package handler

import (
	_ "VikingsServer/docs"
	"VikingsServer/internal/app/config"
	"VikingsServer/internal/app/redis"
	"VikingsServer/internal/app/repository"
	"VikingsServer/internal/app/role"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/minio/minio-go"
	"github.com/sirupsen/logrus"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	"net/http"
)

const (
	baseURL         = "api/v3"
	cities          = baseURL + "/cities"
	addCityIntoHike = baseURL + "/cities/add-city-into-hike"
	addCityImage    = baseURL + "/cities/upload-image"
	deleteCityReact = baseURL + "/cities/delete/:id"

	hikes                        = baseURL + "/hikes"
	hikeCurrent                  = baseURL + "/hikes/current"
	hikesByID                    = baseURL + "/hikes/:id"
	hikeUpdateStatusForModerator = baseURL + "/hikes/update/status-for-moderator"
	hikeUpdateStatusForUser      = baseURL + "/hikes/update/status-for-user"

	users            = baseURL + "/users"
	login            = users + "/login"
	signup           = users + "/sign_up"
	logout           = users + "/logout"
	destinationHikes = baseURL + "/destination-hikes"
)

type Handler struct {
	Logger     *logrus.Logger
	Repository *repository.Repository
	Minio      *minio.Client
	Config     *config.Config
	Redis      *redis.Client
}

func NewHandler(
	l *logrus.Logger,
	r *repository.Repository,
	m *minio.Client,
	conf *config.Config,
	red *redis.Client,
) *Handler {
	return &Handler{
		Logger:     l,
		Repository: r,
		Minio:      m,
		Config:     conf,
		Redis:      red,
	}
}

func (h *Handler) RegisterHandler(router *gin.Engine) {
	h.UserCRUD(router)
	h.CityCRUD(router)
	h.HikeCRUD(router)
	h.DestinationHikesCRUD(router)
	registerStatic(router)
}

func (h *Handler) CityCRUD(router *gin.Engine) {
	router.GET(cities, h.WithoutJWTError(role.Buyer, role.Moderator, role.Admin), h.CitiesList)
	router.POST(cities, h.WithAuthCheck(role.Moderator, role.Admin), h.AddCity)
	router.PUT(addCityImage, h.AddImage)
	router.PUT(cities, h.WithAuthCheck(role.Moderator, role.Admin), h.UpdateCity)
	router.DELETE(cities, h.WithAuthCheck(role.Moderator, role.Admin), h.DeleteCity)
	router.POST(addCityIntoHike, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.AddCityIntoHike)
	router.Use(cors.Default()).DELETE(deleteCityReact, h.DeleteCityWithParam)
}

func (h *Handler) HikeCRUD(router *gin.Engine) {
	router.GET(hikes, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.HikesList)
	router.GET(hikesByID, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.HikesListByID)
	router.GET(hikeCurrent, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.HikeCurrent)
	router.DELETE(hikes, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.DeleteHike)
	router.PUT(hikeUpdateStatusForModerator, h.WithAuthCheck(role.Moderator, role.Admin), h.UpdateStatusForModerator)
	router.PUT(hikeUpdateStatusForUser, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.UpdateStatusForUser)
	router.PUT(hikes, h.WithAuthCheck(role.Buyer, role.Moderator, role.Admin), h.UpdateHike)
}

func (h *Handler) UserCRUD(router *gin.Engine) {
	router.POST(login, h.Login)
	router.POST(signup, h.Register)
	router.GET(logout, h.Logout)
}

func (h *Handler) DestinationHikesCRUD(router *gin.Engine) {
	//router.GET(destinationHikes, h.DestinationHikesList)
	//router.POST(destinationHikes, h.AddDestinationToHike)
	router.PUT(destinationHikes, h.WithoutJWTError(role.Buyer, role.Moderator, role.Admin), h.UpdateDestinationHikeNumber)
	router.DELETE(destinationHikes, h.DeleteDestinationToHike)
}

func registerStatic(router *gin.Engine) {
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	router.Static("/static", "./static")
	router.Static("/img", "./static")
}

func registerFrontHeaders(ctx *gin.Context) {
	//ctx.Header("Access-Control-Allow-Origin", "http://localhost:5173")
	//ctx.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
	//ctx.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

// MARK: - Error handler

type errorResp struct {
	Status      string `json:"status" example:"error"`
	Description string `json:"description" example:"Описание ошибки"`
}

func (h *Handler) errorHandler(ctx *gin.Context, errorStatusCode int, err error) {
	h.Logger.Error(err.Error())

	ctx.JSON(errorStatusCode, errorResp{
		Status:      "error",
		Description: err.Error(),
	})
}

// MARK: - Success handler

func (h *Handler) successHandler(ctx *gin.Context, key string, data interface{}) {
	registerFrontHeaders(ctx)
	ctx.JSON(http.StatusOK, gin.H{
		"status": "success",
		key:      data,
	})
}

func (h *Handler) successAddHandler(ctx *gin.Context, key string, data interface{}) {
	ctx.JSON(http.StatusCreated, gin.H{
		"status": "success",
		key:      data,
	})
}
