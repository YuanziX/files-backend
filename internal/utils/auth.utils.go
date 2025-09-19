package utils

import (
	"context"

	"github.com/YuanziX/files-backend/internal/middleware"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

const (
	USER_ROLE  = "user"
	ADMIN_ROLE = "admin"
)

func GetUserID(ctx context.Context) pgtype.UUID {
	id, ok := ctx.Value(middleware.UserIDKey).(string)
	if !ok {
		return pgtype.UUID{Bytes: [16]byte{}, Valid: false}
	}

	uuid, err := uuid.Parse(id)
	if err != nil {
		return pgtype.UUID{Bytes: [16]byte{}, Valid: false}
	}

	return pgtype.UUID{Bytes: uuid, Valid: true}
}

func GetRole(ctx context.Context) (string, bool) {
	role, ok := ctx.Value(middleware.RoleKey).(string)
	return role, ok
}
