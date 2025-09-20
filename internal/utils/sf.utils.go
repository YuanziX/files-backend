package utils

import (
	"time"

	"github.com/YuanziX/files-backend/internal/graph/model"
)

func BuildFileSortParams(sort *model.FileSortInput) (field, order *string) {
	if sort == nil {
		defaultField := "FILENAME"
		defaultOrder := "ASC"
		return &defaultField, &defaultOrder
	}

	sortField := string(sort.Field)
	sortOrder := string(sort.Order)
	return &sortField, &sortOrder
}

func BuildFolderSortParams(sort *model.FolderSortInput) (field, order *string) {
	if sort == nil {
		defaultField := "NAME"
		defaultOrder := "ASC"
		return &defaultField, &defaultOrder
	}

	sortField := string(sort.Field)
	sortOrder := string(sort.Order)
	return &sortField, &sortOrder
}

func BuildFileFilterParams(filter *model.FileFilterInput) (filename, mimeType *string, minSize, maxSize *int64, uploadedAfter, uploadedBefore *time.Time) {
	if filter == nil {
		return nil, nil, nil, nil, nil, nil
	}

	var minSizeInt64, maxSizeInt64 *int64
	if filter.MinSize != nil {
		val := int64(*filter.MinSize)
		minSizeInt64 = &val
	}
	if filter.MaxSize != nil {
		val := int64(*filter.MaxSize)
		maxSizeInt64 = &val
	}

	return filter.Filename, filter.MimeType, minSizeInt64, maxSizeInt64, filter.UploadedAfter, filter.UploadedBefore
}

func BuildFolderFilterParams(filter *model.FolderFilterInput) (name *string, createdAfter, createdBefore *time.Time) {
	if filter == nil {
		return nil, nil, nil
	}

	return filter.Name, filter.CreatedAfter, filter.CreatedBefore
}
