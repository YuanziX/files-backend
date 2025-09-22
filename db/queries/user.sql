-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 LIMIT 1;

-- name: CreateUser :one
INSERT INTO users (name, email, password_hash)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetUserUsageStats :one
SELECT 
    COALESCE(SUM(pf.size_bytes), 0) AS total_storage_used,
    COALESCE(SUM(CASE WHEN f.is_original = true THEN pf.size_bytes ELSE 0 END), 0) AS actual_storage_used
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.owner_id = $1;

-- name: GetUsers :many
SELECT * FROM users
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: CountUsers :one
SELECT COUNT(*) FROM users;
