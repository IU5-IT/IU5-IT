package ds

import (
	"VikingsServer/internal/app/role"
	"time"
)

type User struct {
	ID         uint      `json:"id" gorm:"primary_key"`
	UserName   string    `json:"user_name" gorm:"type:varchar(50)"`
	Profession string    `json:"profession" gorm:"type:varchar(255)"`
	Birthday   time.Time `json:"birthday"`
	ImageURL   string    `json:"image_url" gorm:"type:varchar(500);default:'http://localhost:7070/static/img/mock-photo.png'"`
	Login      string    `json:"login" gorm:"unique"`
	Password   string    `json:"password"`
	Role       role.Role `json:"role" sql:"type:string"`
}
