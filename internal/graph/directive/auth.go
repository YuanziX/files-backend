package directive

import (
	"context"
	"fmt"

	"github.com/99designs/gqlgen/graphql"
	"github.com/YuanziX/files-backend/internal/graph/model"
	"github.com/YuanziX/files-backend/internal/utils"
)

func Auth(ctx context.Context, obj any, next graphql.Resolver) (any, error) {
	if _, ok := utils.GetUserID(ctx); !ok {
		return nil, fmt.Errorf("access denied: you must be logged in")
	}
	return next(ctx)
}

func HasRole(ctx context.Context, obj any, next graphql.Resolver, role model.Role) (any, error) {
	roleFromCtx, ok := utils.GetRole(ctx)
	if !ok || roleFromCtx == "" {
		return nil, fmt.Errorf("access denied: not authenticated")
	}

	if roleFromCtx != role.String() {
		return nil, fmt.Errorf("access denied: you do not have the required '%s' role", role)
	}

	return next(ctx)
}
