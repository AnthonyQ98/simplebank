postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

simplebank-container:
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@postgres12:5432/simple_bank?sslmode=disable" simplebank:latest

createdb:
	docker exec -it postgres12 createdb --username root --owner root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration --database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration --database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration --database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration --database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

migrateforce: 
	migrate -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -path db/migration force 0

DB_CONTAINER=postgres12
DB_IMAGE=postgres:12-alpine
DB_NAME=simple_bank
DB_USER=root
DB_PASSWORD=secret
DB_PORT=5432

db:
	@echo "Stopping and removing existing PostgreSQL container..."
	-docker stop $(DB_CONTAINER)
	-docker rm $(DB_CONTAINER)

	@echo "Starting new PostgreSQL container..."
	docker run --name $(DB_CONTAINER) -p $(DB_PORT):5432 -e POSTGRES_USER=$(DB_USER) -e POSTGRES_PASSWORD=$(DB_PASSWORD) -d $(DB_IMAGE)

	@echo "Waiting for PostgreSQL to be ready..."
	sleep 5 # Adjust if needed

	@echo "Creating database..."
	docker exec -it $(DB_CONTAINER) psql -U $(DB_USER) -c "CREATE DATABASE $(DB_NAME);"

	@echo "Running migrations..."
	migrate -database "postgresql://$(DB_USER):$(DB_PASSWORD)@localhost:$(DB_PORT)/$(DB_NAME)?sslmode=disable" -path db/migration up

	@echo "Database reset complete."

sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/Store.go github.com/anthonyq98/simplebank/db/sqlc Store

.PHONY: createdb dropdb postgres migrateup migratedown migrateforce db server mock test sqlc migratedown1 migrateup1 