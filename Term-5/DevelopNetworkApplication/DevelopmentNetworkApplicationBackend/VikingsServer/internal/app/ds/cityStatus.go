package ds

type CityStatus struct {
	ID         uint   `json:"id" gorm:"primary_key"`
	StatusName string `json:"status_name" gorm:"type:varchar(30);not null;->"`
}
