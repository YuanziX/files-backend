package utils

import (
	"context"

	"github.com/YuanziX/files-backend/internal/middleware"
)

const (
	USER_ROLE  = "user"
	ADMIN_ROLE = "admin"
)

func GetUserID(ctx context.Context) (string, bool) {
	id, ok := ctx.Value(middleware.UserIDKey).(string)
	return id, ok
}

func GetRole(ctx context.Context) (string, bool) {
	role, ok := ctx.Value(middleware.RoleKey).(string)
	return role, ok
}
