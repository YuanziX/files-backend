package utils

import (
	"time"

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

func GetPgInt8(i *int64) pgtype.Int8 {
	if i == nil {
		return pgtype.Int8{Int64: 0, Valid: false}
	}
	return pgtype.Int8{Int64: *i, Valid: true}
}

func GetPgTime(t *time.Time) pgtype.Timestamptz {
	if t == nil {
		return pgtype.Timestamptz{Time: time.Time{}, Valid: false}
	}
	return pgtype.Timestamptz{Time: *t, Valid: true}
}
