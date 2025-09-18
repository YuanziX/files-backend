-- name: CreateFolder :one
INSERT INTO folders (owner_id, parent_id, name)
VALUES ($1, $2, $3)
RETURNING *;

-- name: ListRootFoldersByOwner :many
SELECT * FROM folders
WHERE owner_id = $1 AND parent_id IS NULL
ORDER BY name;

-- name: ListSubfoldersByParent :many
SELECT * FROM folders
WHERE owner_id = $1 AND parent_id = $2
ORDER BY name;

-- name: GetFolderByID :one
SELECT * FROM folders
WHERE id = $1 AND owner_id = $2;