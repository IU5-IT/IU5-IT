package ds

type HikeStatus struct {
	ID         uint   `json:"id" gorm:"primary_key"`
	StatusName string `json:"status_name" gorm:"->"`
}
