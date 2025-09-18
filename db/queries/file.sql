-- name: ListFilesByOwner :many
SELECT * FROM files
WHERE owner_id = $1
ORDER BY upload_date DESC;

-- name: GetPhysicalFileByHash :one
SELECT * FROM physical_files
WHERE content_hash = $1 LIMIT 1;

-- name: CreateFileReference :one
INSERT INTO files (owner_id, physical_file_id, filename)
VALUES ($1, $2, $3)
RETURNING *;

-- name: CreatePhysicalFile :one
INSERT INTO physical_files (content_hash, mime_type, size_bytes, storage_path, reference_count)
VALUES ($1, $2, $3, $4, 1)
RETURNING *;