package ds

type City struct {
	ID          uint       `json:"id" gorm:"primary_key"`
	CityName    string     `json:"city_name" gorm:"type:varchar(30);not null"`
	StatusID    uint       `json:"status_id"`
	Status      CityStatus `json:"status" gorm:"foreignkey:StatusID"`
	Description string     `json:"description" gorm:"type:text"`
	ImageURL    string     `json:"image_url" gorm:"type:varchar(500);default:'https://w.forfun.com/fetch/7b/7b30cdee828356e2e9a5a161f4fa75a5.jpeg'"`
}

type CityViewData struct {
	Cities   *[]City
	LookAlso *[]City
}

type OneCityViewData struct {
	City     *City
	LookAlso *[]City
}
