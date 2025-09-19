generate:
	sqlc generate
	go get github.com/99designs/gqlgen@latest
	go run github.com/99designs/gqlgen generate

run:
	go run ./cmd/server

setup:
	go mod tidy

init: setup generate
	docker start 1c87fe71529a 2879078a0b6d 