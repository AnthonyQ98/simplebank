DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

simplebank-container:
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@postgres12:5432/simple_bank?sslmode=disable" simplebank:latest

createdb:
	docker exec -it postgres12 createdb --username root --owner root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration --database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration --database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration --database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration --database "$(DB_URL)" -verbose down 1

migrateforce: 
	migrate -database "$(DB_URL)" -path db/migration force 0

migratenew:
	migrate create -ext sql -dir db/migration -seq $(name)

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

dbdocs:
	dbdocs build doc/db.dbml

dbschema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/Store.go github.com/anthonyq98/simplebank/db/sqlc Store

up:
	docker compose up

down:
	docker compose down
	docker rmi postgres:12-alpine
	docker rmi simplebank-api

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative --go-grpc_out=pb --go-grpc_opt=paths=source_relative --grpc-gateway_out=pb --grpc-gateway_opt paths=source_relative --openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank proto/*.proto
	statik -src=./doc/swagger -dest=./doc

evans:
	evans -r repl -p 9090 --host localhost

redis: 
	docker run --name redis -p 6379:6379 -d redis:8-alpine

.PHONY: createdb dropdb postgres migrateup migratedown migrateforce db server mock test sqlc migratedown1 migrateup1 up down dbdocs dbschema proto evans redis