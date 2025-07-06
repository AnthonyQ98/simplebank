# Build stage
FROM golang:1.24.3-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

# Production stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080

CMD ["/app/main"]