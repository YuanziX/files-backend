package utils

import (
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

func GetPgUUID(s *string) pgtype.UUID {
	if s == nil {
		return pgtype.UUID{Bytes: [16]byte{}, Valid: false}
	}
	uuid, err := uuid.Parse(*s)
	if err != nil {
		return pgtype.UUID{Bytes: [16]byte{}, Valid: false}
	}
	return pgtype.UUID{Bytes: uuid, Valid: true}
}

func GetPgString(s *string) pgtype.Text {
	if s == nil {
		return pgtype.Text{String: "", Valid: false}
	}
	return pgtype.Text{String: *s, Valid: true}
}
