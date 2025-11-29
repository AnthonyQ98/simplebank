# SimpleBank

A robust banking system built with Go, featuring a secure and scalable backend API. This project implements real-world banking operations including accounts, transfers, and authentication using modern development practices.

## ✨ Features

- **Account Management**
  - Create and manage bank accounts
  - Track balances and transactions
  - Support multiple currencies
  
- **Transaction Processing**
  - Secure money transfers between accounts
  - Transaction history and tracking
  - Concurrent transaction handling
  
- **Authentication & Authorization**
  - Secure user authentication
  - Role-based access control
  - Session management

## 🛠 Tech Stack

### Backend
- **Language**: Go 1.24+
- **Database**: PostgreSQL
- **ORM**: SQLC for type-safe SQL
- **API**: RESTful API with Gin framework
- **Auth**: JWT, PASETO
- **Testing**: Go testing, Testify

### Frontend (Planned - Stack may change)
- **Framework**: React
- **Styling**: Tailwind CSS
- **State Management**: Redux
- **API Integration**: Axios

### Infrastructure
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Deployment**: AWS
- **Database Migration**: golang-migrate

## 🚀 Getting Started

### Prerequisites
```bash
go 1.24+
docker
postgresql
make
```

### Development Setup

1. Clone the repository
```bash
git clone https://github.com/yourusername/simplebank.git
cd simplebank
```

2. Start PostgreSQL container
```bash
docker run --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:latest
```

3. Setup the database
```bash
make createdb    # Create database
make migrateup   # Run migrations
```

4. Run the server
```bash
make server      # Starts the backend server
```

5. Run tests
```bash
make test        # Run all tests
```

## 📐 Project Structure

```
simplebank/
├── api/          # REST API handlers
├── db/           # Database layer
│   ├── migration/  # SQL migrations
│   └── sqlc/      # Generated Go code
├── token/        # Authentication logic
├── util/         # Utility functions
├── frontend/     # React frontend (planned)
└── tests/        # Integration tests
```

## 🔒 Security Features

- Secure password hashing
- Token-based authentication
- Database connection pooling
- SQL injection prevention
- Transaction isolation levels
- Rate limiting
- Input validation

## 📝 API Documentation

API documentation will be available at `/swagger/index.html` when running the server.

Key endpoints:
- `POST /accounts` - Create account
- `GET /accounts/:id` - Get account details
- `POST /transfers` - Create transfer
- `GET /transfers` - List transfers
- More endpoints coming soon...

## 🧪 Testing

The project includes:
- Unit tests
- Integration tests
- Mock tests for external services
- Load tests for performance benchmarking

Run tests with:
```bash
make test        # Run all tests
make test_cover  # Run tests with coverage
```

## 📦 Deployment

Deployment instructions coming soon...

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

