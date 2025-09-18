generate:
	sqlc generate
	go get github.com/99designs/gqlgen@latest
	go run github.com/99designs/gqlgen generate

run:
	go run ./cmd/server

setup:
	go mod tidy

init: setup generate run