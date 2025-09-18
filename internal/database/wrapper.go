package database

import (
	"github.com/YuanziX/files-backend/internal/database/postgres"
	"github.com/jackc/pgx/v5"
)

type Querier interface {
	postgres.Querier
	WithTx(tx *pgx.Tx) Querier
}

type Queries struct {
	*postgres.Queries
}

func (q *Queries) WithTx(tx *pgx.Tx) Querier {
	return &Queries{
		Queries: q.Queries.WithTx(*tx),
	}
}

func NewQuerier(q *postgres.Queries) Querier {
	return &Queries{
		Queries: q,
	}
}
