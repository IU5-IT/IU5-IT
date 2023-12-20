package dsn

import (
	"fmt"
	"github.com/joho/godotenv"
	"os"
)

func FromEnv() (string, error) {
	if err := godotenv.Load(); err != nil {
		return "", err
	}

	host, existHost := os.LookupEnv("DB_HOST")
	port, existPort := os.LookupEnv("DB_PORT")
	user, existUser := os.LookupEnv("DB_USER")
	pass, existPass := os.LookupEnv("DB_PASS")
	dbname, existName := os.LookupEnv("DB_NAME")
	if !existHost || !existPort || !existUser || !existPass || !existName {
		return "", fmt.Errorf("existHost or existPort or existUser or existPass or existName is Empty")
	}

	return fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", host, port, user, pass, dbname), nil
}
