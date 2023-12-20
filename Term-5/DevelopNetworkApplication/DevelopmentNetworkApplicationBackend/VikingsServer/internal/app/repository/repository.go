package repository

import (
	_ "github.com/lib/pq"
	"github.com/sirupsen/logrus"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Repository struct {
	logger *logrus.Logger
	db     *gorm.DB
}

func NewRepository(dsn string, log *logrus.Logger) (*Repository, error) {
	gormDB, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	return &Repository{
		db:     gormDB,
		logger: log,
	}, nil
}
