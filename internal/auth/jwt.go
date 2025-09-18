package auth

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GenerateToken(userID string, role string, jwtSecret []byte) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
		"role":    role,
		"exp":     time.Now().Add(time.Hour * 24 * 30).Unix(), // Token valid for 30 days
	})

	tokenString, err := token.SignedString(jwtSecret)
	if err != nil {
		return "", err
	}
	return tokenString, nil
}
