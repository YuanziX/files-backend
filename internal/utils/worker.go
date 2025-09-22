package utils

import (
	"context"
	"log"
	"time"

	"github.com/YuanziX/files-backend/internal/database"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Worker struct {
	db     *database.Queries
	s3     *s3.Client
	bucket string
}

func NewWorker(db *database.Queries, s3Client *s3.Client, bucket string) *Worker {
	return &Worker{
		db:     db,
		s3:     s3Client,
		bucket: bucket,
	}
}

func (w *Worker) CleanupFiles(ctx context.Context) error {
	files, err := w.db.GetPhysicalFilesForCleanup(ctx)
	if err != nil {
		return err
	}

	for _, file := range files {
		_, err := w.s3.DeleteObject(ctx, &s3.DeleteObjectInput{
			Bucket: &w.bucket,
			Key:    &file.ContentHash,
		})
		if err != nil {
			log.Printf("Failed to delete S3 object %s: %v", file.ContentHash, err)
			continue
		}

		err = w.db.DeleteFileReference(ctx, file.ID)
		if err != nil {
			log.Printf("Failed to delete DB record for file %d: %v", file.ID.Bytes, err)
			continue
		}
	}

	return nil
}

func StartCleanupWorker(ctx context.Context, worker *Worker) {
	go func() {
		ticker := time.NewTicker(time.Hour)
		defer ticker.Stop()
		for {
			select {
			case <-ticker.C:
				if err := worker.CleanupFiles(ctx); err != nil {
					log.Printf("CleanupFiles error: %v", err)
				}
			case <-ctx.Done():
				log.Println("Cleanup worker stopped")
				return
			}
		}
	}()
}
