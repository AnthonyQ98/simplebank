# Build stage
FROM golang:1.24.3-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN go build -o simplebank main.go

# Production stage
FROM alpine:latest
COPY --from=builder /app/simplebank /usr/local/bin/
EXPOSE 8080

CMD ["simplebank"]