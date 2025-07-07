# Build stage
FROM golang:1.24.3-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.18.3/migrate.linux-amd64.tar.gz | tar xvz
RUN mv migrate .

# Production stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env /app/app.env
COPY start.sh /app/start.sh
COPY wait-for.sh /app/wait-for.sh
COPY db/migration ./migration

EXPOSE 8080

CMD ["/app/main"]
ENTRYPOINT ["/app/start.sh"]