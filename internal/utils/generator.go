package utils

import (
	"crypto/rand"
	"encoding/hex"
)

func Generate32CharToken() (string, error) {
	return GenerateToken(32)
}

func GenerateToken(byteLength int) (string, error) {
	bytes := make([]byte, byteLength)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}
