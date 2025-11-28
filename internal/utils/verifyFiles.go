package utils

import (
	"fmt"
	"strconv"
	"strings"
)

func ExtractPrimaryMIME(mime string) string {
	mime = strings.TrimSpace(mime)
	parts := strings.SplitN(mime, ";", 2)
	return strings.TrimSpace(parts[0])
}

func VerifySize(objectContentRange string, expectedSize int32) (bool, error) {
	parts := strings.Split(objectContentRange, "/")
	if len(parts) < 2 {
		return false, fmt.Errorf("invalid Content-Range")
	}
	fullSize, err := strconv.ParseInt(parts[1], 10, 64)
	if err != nil {
		return false, fmt.Errorf("failed to parse Content-Range: %v", err)
	}
	return fullSize == int64(expectedSize), nil
}

var mimeAliases = map[string][]string{
	"application/msword": {
		"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
	},
	"application/vnd.android.package-archive": {
		"application/zip",
	},
	"image/png": {
		"image/jpeg",
	},
}

// generic mime for binary files
var genericBinaryTypes = []string{
	"application/octet-stream",
	"application/x-executable",
	"application/x-sharedlib",
	"application/x-msdos-program",
	"application/x-msdownload",
	"application/x-dosexec",
}

func IsMimeMatch(detected, expected string) bool {
	if detected == expected {
		return true
	}

	// handles executables and other generic binary types
	for _, genericType := range genericBinaryTypes {
		if detected == genericType || expected == genericType {
			return true
		}
	}

	if aliases, ok := mimeAliases[expected]; ok {
		for _, alias := range aliases {
			if detected == alias {
				return true
			}
		}
	}
	return false
}
