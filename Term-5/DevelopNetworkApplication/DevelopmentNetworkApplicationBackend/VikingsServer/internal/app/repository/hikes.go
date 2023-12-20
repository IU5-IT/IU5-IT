package repository

import (
	"VikingsServer/internal/app/ds"
	"VikingsServer/internal/utils"
	"errors"
	"gorm.io/gorm"
	"time"
)

func (r *Repository) HikesList(statusID string, startDate time.Time, endDate time.Time) (*[]ds.Hike, error) {
	var hikes []ds.Hike
	if statusID == "" {
		result := r.db.Preload("Status").
			Preload("DestinationHikes.City.Status").
			Preload("DestinationHikes.Hike.Status").
			Preload("User").
			Preload("Status").
			Preload("Moderator").
			Where("status_id != 5 AND status_id != 1 AND date_start_of_processing BETWEEN ? AND ?", startDate, endDate).
			Find(&hikes)
		return &hikes, result.Error
	}

	result := r.db.Preload("Status").
		Preload("DestinationHikes.City.Status").
		Preload("DestinationHikes.Hike.Status").
		Preload("User").
		Preload("Status").
		Where("status_id = ? AND date_start_of_processing BETWEEN ? AND ?", statusID, startDate, endDate).
		Find(&hikes)
	return &hikes, result.Error
}

func (r *Repository) AddCityIntoHike(cityID uint, userID uint, serialNumber int) (uint, error) {
	hikeID, err := r.HikeBasketId(userID)
	if err != nil {
		return 0, err
	}

	/// Корзины нет. Создадим заявку
	if hikeID == 0 {
		newHike := ds.Hike{
			UserID:      userID,
			DateCreated: time.Now(),
			StatusID:    1,
			ModeratorID: nil,
		}
		if errCreate := r.db.Create(&newHike).Error; errCreate != nil {
			return 0, errCreate
		}

		dh := ds.DestinationHikes{
			CityID:       cityID,
			HikeID:       newHike.ID,
			SerialNumber: serialNumber,
		}

		return dh.ID, r.AddDestinationToHike(&dh)
	}

	/// Корзина есть, добавляем туда
	dh := ds.DestinationHikes{
		CityID:       cityID,
		HikeID:       hikeID,
		SerialNumber: serialNumber,
	}

	return dh.ID, r.AddDestinationToHike(&dh)
}

func (r *Repository) HikeBasketId(userId uint) (uint, error) {
	var hike ds.Hike
	result := r.db.Preload("Status").
		Where("status_id = ? AND user_id = ?", 1, userId).
		First(&hike)
	if result.RowsAffected == 0 {
		return 0, nil
	}
	return hike.ID, result.Error
}

func (r *Repository) HikeByID(id uint) (*ds.Hike, error) {
	hike := ds.Hike{}
	result := r.db.Preload("User").
		Preload("DestinationHikes.Hike.Status").
		Preload("DestinationHikes.Hike.User").
		Preload("DestinationHikes.City.Status").
		Preload("Status").
		First(&hike, id)
	return &hike, result.Error
}

func (r *Repository) HikeByUserID(userID string) (*[]ds.Hike, error) {
	var hikes []ds.Hike
	result := r.db.Preload("User").
		Preload("DestinationHikes.Hike.Status").
		Preload("DestinationHikes.Hike.User").
		Preload("Moderator").
		Preload("DestinationHikes.City.Status").
		Preload("Status").
		Where("user_id = ? AND status_id != 5", userID).
		Find(&hikes)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		} else {
			return nil, result.Error
		}
	}
	return &hikes, result.Error
}

func (r *Repository) AddHike(hike *ds.Hike) error {
	return r.db.Create(&hike).Error
}

func (r *Repository) DeleteHike(id uint) error {
	hike := ds.Hike{}
	if result := r.db.First(&hike, id); result.Error != nil {
		return result.Error
	}
	hike.StatusID = 5
	result := r.db.Save(&hike)
	return result.Error
}

func (r *Repository) UpdateStatusForUser(hikeID uint, newStatusID uint) error {
	updatedHike := ds.Hike{}
	if result := r.db.First(&updatedHike, hikeID); result.Error != nil {
		return result.Error
	}
	updatedHike.StatusID = newStatusID
	updatedHike.DateStartOfProcessing = time.Now()
	return r.db.Save(&updatedHike).Error
}

func (r *Repository) UpdateHikeForModerator(hikeID uint, newStatusID uint, userID uint) error {
	updatedHike := ds.Hike{}
	if result := r.db.First(&updatedHike, hikeID); result.Error != nil {
		return result.Error
	}
	updatedHike.StatusID = newStatusID
	updatedHike.DateApprove = time.Now()
	updatedHike.ModeratorID = &userID
	return r.db.Save(&updatedHike).Error
}

func (r *Repository) UpdateHike(updatedHike *ds.Hike) error {
	oldHike := ds.Hike{}
	if result := r.db.First(&oldHike, updatedHike.ID); result.Error != nil {
		return result.Error
	}
	if updatedHike.HikeName != "" {
		oldHike.HikeName = updatedHike.HikeName
	}
	if updatedHike.DateCreated.String() != utils.EmptyDate {
		//oldHike.DateCreated = updatedHike.DateCreated
		return errors.New(`DateCreated cannot be updated`)
	}
	if updatedHike.DateStartOfProcessing.String() != utils.EmptyDate {
		return errors.New(`DateStartOfProcessing cannot be updated`)
	}
	if updatedHike.DateApprove.String() != utils.EmptyDate {
		//oldHike.DateApprove = updatedHike.DateApprove
		return errors.New(`DateApprove cannot be updated`)
	}
	if updatedHike.DateEnd.String() != utils.EmptyDate {
		oldHike.DateEnd = updatedHike.DateEnd
	}
	if updatedHike.DateStartHike.String() != utils.EmptyDate {
		oldHike.DateStartHike = updatedHike.DateStartHike
	}
	if updatedHike.Leader != "" {
		oldHike.Leader = updatedHike.Leader
	}
	if updatedHike.UserID != 0 {
		oldHike.UserID = updatedHike.UserID
	}
	if updatedHike.Description != "" {
		oldHike.Description = updatedHike.Description
	}

	*updatedHike = oldHike
	result := r.db.Save(updatedHike)
	return result.Error
}
