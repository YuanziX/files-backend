package server

import (
	"log"
	"net/http"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
	"github.com/go-chi/httprate"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/YuanziX/files-backend/internal/config"
	"github.com/YuanziX/files-backend/internal/database"
	"github.com/YuanziX/files-backend/internal/graph/directive"
	"github.com/YuanziX/files-backend/internal/graph/generated"
	"github.com/YuanziX/files-backend/internal/graph/resolver"
	custom_middleware "github.com/YuanziX/files-backend/internal/middleware"
	"github.com/YuanziX/files-backend/internal/storage"
)

type Server struct {
	Router *chi.Mux
}

func New(db database.Queries, dbPool *pgxpool.Pool, cfg *config.Config) *Server {
	router := chi.NewRouter()

	router.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))
	router.Use(middleware.Logger)
	router.Use(middleware.Recoverer)
	router.Use(httprate.LimitByIP(cfg.NumberOfRequests, cfg.RateLimitWindowDuration))

	s3Client, s3PresignClient := storage.NewS3Clients(cfg)

	res := &resolver.Resolver{
		DB:              db,
		DBPool:          dbPool,
		Cfg:             cfg,
		S3Client:        s3Client,
		S3PresignClient: s3PresignClient,
		S3BucketName:    cfg.S3BucketName,
	}

	c := generated.Config{
		Resolvers: res,
	}

	// setup directives
	c.Directives.Auth = directive.Auth
	c.Directives.HasRole = directive.HasRole

	srv := handler.NewDefaultServer(generated.NewExecutableSchema(c))

	router.Handle("/", playground.Handler("GraphQL Playground", "/query"))
	router.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})
	router.With(custom_middleware.UserLoaderMiddleware(cfg.JwtSecret)).Handle("/query", srv)

	return &Server{
		Router: router,
	}
}

func (s *Server) Start(port string) {
	log.Printf("Server starting on port %s", port)
	log.Printf("Connect to http://localhost:%s/ for GraphQL playground", port)
	if err := http.ListenAndServe(":"+port, s.Router); err != nil {
		log.Fatalf("server failed to start: %v", err)
	}
}
