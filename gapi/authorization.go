package gapi

import (
	"context"
	"strings"

	"github.com/anthonyq98/simplebank/token"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

const (
	authorizationHeaderKey  = "authorization"
	authorizationTypeBearer = "bearer"
	authorizationPayloadKey = "authorization_payload"
)

func (server *Server) authorizeUser(ctx context.Context) (*token.Payload, error) {
	metadata, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, status.Errorf(codes.Unauthenticated, "metadata is not provided")
	}

	authorizationHeader := metadata.Get(authorizationHeaderKey)
	if len(authorizationHeader) == 0 {
		return nil, status.Errorf(codes.Unauthenticated, "authorization header is not provided")
	}

	fields := strings.Fields(authorizationHeader[0])

	if len(fields) < 2 {
		return nil, status.Errorf(codes.Unauthenticated, "invalid authorization header format")
	}

	authorizationType := strings.ToLower(fields[0])
	if authorizationType != authorizationTypeBearer {
		return nil, status.Errorf(codes.Unauthenticated, "unsupported authorization type %s", authorizationType)
	}

	accessToken := fields[1]
	payload, err := server.tokenMaker.VerifyToken(accessToken)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "access token is invalid: %v", err)
	}

	return payload, nil
}
