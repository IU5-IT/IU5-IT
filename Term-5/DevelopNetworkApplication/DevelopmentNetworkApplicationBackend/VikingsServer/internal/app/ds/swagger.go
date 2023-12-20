package ds

type HikesListRes struct {
	Status string `json:"status"`
	Hikes  []Hike `json:"hikes"`
}

type HikesListRes2 struct {
	Status string `json:"status"`
	Hikes  []Hike `json:"hikes"`
}

type DeleteDestinationToHikeReq struct {
	ID int `json:"id"`
}

type DeleteDestinationToHikeRes struct {
	Status                 string `json:"status"`
	DeletedDestinationHike int    `json:"deleted_destination_hike"`
}

type UpdateDestinationHikeNumberReq struct {
	DestinationHikeID int `json:"id"`
	SerialNumber      int `json:"serial_number"`
}

type UpdateDestinationHikeNumberRes struct {
	Status string `json:"status"`
	ID     uint   `json:"id"`
}

type DeleteCityRes struct {
	DeletedId int `json:"deleted_id"`
}

type AddImageRes struct {
	Status   string `json:"status"`
	ImageUrl string `json:"image_url"`
}

type UpdatedHikeRes struct {
	ID                    uint   `json:"id"`
	HikeName              string `json:"hike_name"`
	DateCreated           string `json:"date_created"`
	DateEnd               string `json:"date_end"`
	DateStartOfProcessing string `json:"date_start_of_processing"`
	DateApprove           string `json:"date_approve"`
	DateStartHike         string `json:"date_start_hike"`
	UserID                uint   `json:"user_id"`
	StatusID              uint   `json:"status_id"`
	Description           string `json:"description"`
}

type DeleteHikeRes struct {
	Status string `json:"status"`
	HikeId uint   `json:"hike_id"`
}

type DeleteHikeReq struct {
	ID uint `json:"id"`
}

type UpdateHikeReq struct {
	ID          uint   `json:"id"`
	HikeName    string `json:"hike_name"`
	Description string `json:"description"`
}

type UpdateStatusForModeratorReq struct {
	HikeID   uint `json:"hike_id"`
	StatusID uint `json:"status_id"`
}

type UpdateStatusForUserReq struct {
	StatusID uint `json:"status_id" example:"2"`
}

type DeleteCityReq struct {
	ID string `json:"id"`
}

type UpdateCityReq struct {
	Id          int    `json:"id" binding:"required"`
	CityName    string `json:"city_name"`
	Description string `json:"description"`
	StatusId    int    `json:"status_id"`
}

type AddCityIntoHikeReq struct {
	CityID       int `json:"city_id" binding:"required" example:"1"`
	SerialNumber int `json:"serial_number" binding:"required" example:"1"`
}

type AddCityIntoHikeResp struct {
	Status string `json:"status"`
	Id     int    `json:"id"`
}

type UpdateCityResp struct {
	ID          string `json:"id"`
	CityName    string `json:"city_name"`
	StatusID    string `json:"status_id"`
	Description string `json:"description"`
	ImageURL    string `json:"image_url"`
}

type AddCityResp struct {
	Status string `json:"status"`
	CityId string `json:"city_id"`
}

type CitiesListResp struct {
	Status   string `json:"status"`
	Cities   []City `json:"cities"`
	BasketId string `json:"basket_id"`
}

type AddCityIntoHikeRequest struct {
}
