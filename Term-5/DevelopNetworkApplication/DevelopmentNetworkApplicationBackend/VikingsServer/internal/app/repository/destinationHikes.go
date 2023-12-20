package repository

import "VikingsServer/internal/app/ds"

func (r *Repository) DestinationHikesList() (*[]ds.DestinationHikes, error) {
	var destinationHikes []ds.DestinationHikes
	result := r.db.Preload("Hike.Status").
		Preload("City.Status").
		Find(&destinationHikes)
	return &destinationHikes, result.Error
}

func (r *Repository) AddDestinationToHike(dh *ds.DestinationHikes) error {
	result := r.db.Create(dh)
	return result.Error
}

func (r *Repository) DeleteDestinationToHike(id int) error {
	var dh ds.DestinationHikes
	if result := r.db.First(&dh, id); result.Error != nil {
		return result.Error
	}
	return r.db.Delete(&dh).Error
}

func (r *Repository) UpdateDestinationHikeNumber(dhID int, number int) (*ds.DestinationHikes, error) {
	var updatedDestinationHike ds.DestinationHikes
	if result := r.db.First(&updatedDestinationHike, dhID); result.Error != nil {
		return nil, result.Error
	}
	updatedDestinationHike.SerialNumber = number
	result := r.db.Save(updatedDestinationHike)
	return &updatedDestinationHike, result.Error
}
