package utils

import (
	"fmt"
	"github.com/rs/xid"
	"strings"
	"time"
)

// GenerateUniqueName Генератор имени для фото
func GenerateUniqueName(imageName *string) error {
	parts := strings.Split(*imageName, ".")
	if len(parts) > 1 {
		fileExt := parts[len(parts)-1]
		uniqueID := xid.New()
		*imageName = fmt.Sprintf("%s.%s", uniqueID.String(), fileExt)
		return nil
	}
	return fmt.Errorf("uncorrect file name. not fount image extension")
}

// ParseDateString Парсер строки в дату
func ParseDateString(dateString string) (time.Time, error) {
	format := "2006-01-02"
	parsedTime, err := time.Parse(format, dateString)
	if err != nil {
		return time.Time{}, err
	}

	return parsedTime, nil
}

// Contains Функция для проверки наличия элемента в срезе
func Contains(slice []string, value string) bool {
	for _, item := range slice {
		if item == value {
			return true
		}
	}
	return false
}
