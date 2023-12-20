package ds

type DestinationHikes struct {
	ID           uint `json:"id" gorm:"primary_key"`
	CityID       uint `json:"city_id"`
	HikeID       uint `json:"hike_id"`
	SerialNumber int  `json:"serial_number"`
	City         City `json:"city" gorm:"foreignkey:CityID"`
	Hike         Hike `json:"hike" gorm:"foreignkey:HikeID"`
}
