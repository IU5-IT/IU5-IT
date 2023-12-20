package repository

import (
	"VikingsServer/internal/app/ds"
	"fmt"
)

func (r *Repository) CitiesList() (*[]ds.City, error) {
	var cities []ds.City
	result := r.db.Preload("Status").
		Where(`status_id = ?`, 1).
		Find(&cities)
	return &cities, result.Error
}

func (r *Repository) CitiesById(id uint) (*ds.City, error) {
	city := ds.City{}
	result := r.db.Preload("Status").First(&city, id)
	return &city, result.Error
}

func (r *Repository) UpdateCityImage(id string, newImageURL string) error {
	city := ds.City{}
	if result := r.db.First(&city, id); result.Error != nil {
		return result.Error
	}
	city.ImageURL = newImageURL
	result := r.db.Save(city)
	return result.Error
}

func (r *Repository) DeleteCity(id uint) error {
	var city ds.City
	if result := r.db.First(&city, id); result.Error != nil {
		return result.Error
	}
	if city.ID == 0 {
		return fmt.Errorf("city not found")
	}
	city.StatusID = 2
	return r.db.Save(&city).Error
}

func (r *Repository) AddCity(city *ds.City) error {
	result := r.db.Create(&city)
	return result.Error
}

func (r *Repository) UpdateCity(updatedCity *ds.City) error {
	var oldCity ds.City
	if result := r.db.First(&oldCity, updatedCity.ID); result.Error != nil {
		return result.Error
	}
	if updatedCity.CityName != "" {
		oldCity.CityName = updatedCity.CityName
	}
	if updatedCity.StatusID != 0 {
		oldCity.StatusID = updatedCity.StatusID
	}
	if updatedCity.ImageURL != "" {
		oldCity.ImageURL = updatedCity.ImageURL
	}
	if updatedCity.Description != "" {
		oldCity.Description = updatedCity.Description
	}

	*updatedCity = oldCity
	result := r.db.Save(updatedCity)
	return result.Error
}
