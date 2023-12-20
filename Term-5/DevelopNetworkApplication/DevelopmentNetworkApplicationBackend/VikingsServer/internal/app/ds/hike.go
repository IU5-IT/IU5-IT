package ds

import (
	"time"
)

type Hike struct {
	ID                    uint               `json:"id" gorm:"primary_key"`
	HikeName              string             `json:"hike_name" gorm:"type:varchar(50);not null"`
	DateCreated           time.Time          `json:"date_created" gorm:"type:date;not null;default:current_date"`
	DateEnd               time.Time          `json:"date_end" gorm:"type:date"`
	DateStartOfProcessing time.Time          `json:"date_start_of_processing" gorm:"type:date"`
	DateApprove           time.Time          `json:"date_approve" gorm:"type:date"`
	DateStartHike         time.Time          `json:"date_start_hike" gorm:"type:date"`
	StatusID              uint               `json:"status_id"`
	Status                HikeStatus         `json:"status" gorm:"foreignkey:StatusID"`
	Description           string             `json:"description" gorm:"type:text"`
	Leader                string             `json:"leader" gorm:"type:text"`
	UserID                uint               `json:"user_id"`
	User                  User               `json:"user" gorm:"foreignkey:UserID"`
	ModeratorID           *uint              `json:"moderator_id"`
	Moderator             User               `json:"moderator" gorm:"foreignkey:ModeratorID"`
	DestinationHikes      []DestinationHikes `json:"destination_hikes" gorm:"foreignkey:HikeID"`
}
