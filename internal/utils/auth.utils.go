package utils

import (
	"context"
	"fmt"

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

func RequiresRole(ctx context.Context, role string) error {
	userRole, ok := GetRole(ctx)
	if !ok {
		return fmt.Errorf("unauthorized: no role found")
	}
	if role == USER_ROLE && userRole == USER_ROLE {
		return nil
	} else if role == ADMIN_ROLE && userRole == ADMIN_ROLE {
		return nil
	}

	return fmt.Errorf("forbidden: insufficient permissions")
}
