package main

import (
	"VikingsServer/internal/app/ds"
	"VikingsServer/internal/app/dsn"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	_ = godotenv.Load()
	env, err2 := dsn.FromEnv()
	if err2 != nil {
		panic("Error from reading env")
	}
	db, err := gorm.Open(postgres.Open(env), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}
	if err := db.AutoMigrate(
		&ds.City{},
		&ds.DestinationHikes{},
		&ds.Hike{},
		&ds.User{},
		&ds.CityStatus{},
		&ds.HikeStatus{},
	); err != nil {
		panic("cant migrate db:" + err.Error())
	}
}
