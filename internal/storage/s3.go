package storage

import (
	"github.com/YuanziX/files-backend/internal/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

func NewS3Clients(cfg *config.Config) (*s3.Client, *s3.PresignClient) {
	client := s3.New(s3.Options{
		Region: cfg.S3Region,
		Credentials: credentials.NewStaticCredentialsProvider(
			cfg.S3AccessKeyID,
			cfg.S3SecretAccessKey,
			"",
		),
		BaseEndpoint: &cfg.S3Endpoint,
		UsePathStyle: true,
	})

	presignClient := s3.NewPresignClient(client)

	return client, presignClient
}
