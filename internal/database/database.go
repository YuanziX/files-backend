package database

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5/pgxpool"
)

func NewConnection(dbUrl string) *pgxpool.Pool {
	if dbUrl == "" {
		log.Fatal("DB_SOURCE environment variable is not set")
	}

	pool, err := pgxpool.New(context.Background(), dbUrl)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}

	if err := pool.Ping(context.Background()); err != nil {
		log.Fatalf("Database ping failed: %v\n", err)
	}

	log.Println("Database connection established successfully.")
	return pool
}
