package main

import (
	"github.com/YuanziX/files-backend/internal/config"
	"github.com/YuanziX/files-backend/internal/database"
	"github.com/YuanziX/files-backend/internal/database/postgres"
	"github.com/YuanziX/files-backend/internal/server"
)

func main() {
	// load conf
	cfg := config.New()

	// init db
	dbPool := database.NewConnection(cfg.DBUrl)
	defer dbPool.Close()

	// create db querier
	dbQuerier := postgres.New(dbPool)
	// create server
	srv := server.New(database.Queries{Queries: dbQuerier}, dbPool, cfg)

	// start server
	srv.Start(cfg.Port)
}
