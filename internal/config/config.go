package config

import (
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
)

type Config struct {
	Port                    string
	DBUrl                   string
	JwtSecret               []byte
	NumberOfRequests        int
	RateLimitWindowDuration time.Duration

	S3Endpoint        string
	S3Region          string
	S3AccessKeyID     string
	S3SecretAccessKey string
	S3BucketName      string
}

func New(NumberOfRequests int, rateLimitWindowDuration time.Duration) *Config {
	if err := godotenv.Load(".env"); err != nil {
		log.Printf("Error loading .env file: %v", err)
	}

	return &Config{
		Port:                    getEnv("PORT", "8080", false),
		DBUrl:                   getEnv("DB_SOURCE", "", true),
		JwtSecret:               []byte(getEnv("JWT_SECRET", "", true)),
		NumberOfRequests:        NumberOfRequests,
		RateLimitWindowDuration: rateLimitWindowDuration,
		S3Endpoint:              getEnv("S3_ENDPOINT", "http://localhost:9000", false),
		S3Region:                getEnv("S3_REGION", "us-east-1", false),
		S3AccessKeyID:           getEnv("S3_ACCESS_KEY_ID", "minioadmin", false),
		S3SecretAccessKey:       getEnv("S3_SECRET_ACCESS_KEY", "minioadmin", false),
		S3BucketName:            getEnv("S3_BUCKET_NAME", "balkan", false),
	}
}

func getEnv(key, defaultValue string, fatal bool) string {
	value, exists := os.LookupEnv(key)
	if exists {
		return value
	}
	if fatal {
		log.Fatalf("Environment variable %s is not set", key)
	}
	return defaultValue
}
