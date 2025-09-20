-- name: ListSubfoldersByParentWithSortAndFilter :many
SELECT 
    id,
    name,
    created_at,
    parent_id,
    path,
    owner_id
FROM folders
WHERE 
    parent_id = sqlc.narg('parent_id')::uuid
    AND (sqlc.narg('name_filter')::text IS NULL OR name ILIKE '%' || sqlc.narg('name_filter') || '%')
    AND (sqlc.narg('created_after')::timestamptz IS NULL OR created_at >= sqlc.narg('created_after'))
    AND (sqlc.narg('created_before')::timestamptz IS NULL OR created_at <= sqlc.narg('created_before'))
ORDER BY
    CASE WHEN sqlc.narg('sort_field')::text = 'NAME' AND sqlc.narg('sort_order')::text = 'ASC' THEN name END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'NAME' AND sqlc.narg('sort_order')::text = 'DESC' THEN name END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'CREATED_AT' AND sqlc.narg('sort_order')::text = 'ASC' THEN created_at END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'CREATED_AT' AND sqlc.narg('sort_order')::text = 'DESC' THEN created_at END DESC,
    name ASC;

-- name: ListRootFoldersByOwnerWithSortAndFilter :many
SELECT 
    id,
    name,
    created_at,
    parent_id,
    path,
    owner_id
FROM folders
WHERE 
    owner_id = @owner_id
    AND parent_id IS NULL
    AND (sqlc.narg('name_filter')::text IS NULL OR name ILIKE '%' || sqlc.narg('name_filter') || '%')
    AND (sqlc.narg('created_after')::timestamptz IS NULL OR created_at >= sqlc.narg('created_after'))
    AND (sqlc.narg('created_before')::timestamptz IS NULL OR created_at <= sqlc.narg('created_before'))
ORDER BY
    CASE WHEN sqlc.narg('sort_field')::text = 'NAME' AND sqlc.narg('sort_order')::text = 'ASC' THEN name END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'NAME' AND sqlc.narg('sort_order')::text = 'DESC' THEN name END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'CREATED_AT' AND sqlc.narg('sort_order')::text = 'ASC' THEN created_at END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'CREATED_AT' AND sqlc.narg('sort_order')::text = 'DESC' THEN created_at END DESC,
    name ASC;