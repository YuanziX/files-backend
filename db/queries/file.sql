-- name: ListFilesByOwnerAndFolder :many
SELECT
    f.id, f.filename, f.upload_date,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.owner_id = $1 AND f.folder_id = $2
ORDER BY f.filename;

-- name: ListRootFilesByOwner :many
SELECT
    f.id, f.filename, f.upload_date,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.owner_id = $1 AND f.folder_id IS NULL
ORDER BY f.filename;

-- name: GetPhysicalFileByHash :one
SELECT * FROM physical_files
WHERE content_hash = $1 LIMIT 1;

-- name: CreateFileReference :one
INSERT INTO files (owner_id, physical_file_id, folder_id, filename)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: CreatePhysicalFile :one
INSERT INTO physical_files (content_hash, mime_type, size_bytes, storage_path, reference_count)
VALUES ($1, $2, $3, $4, 1)
RETURNING *;

-- name: GetFileForDeletion :one
SELECT owner_id, physical_file_id FROM files WHERE id = $1;

-- name: DecrementPhysicalFileReferenceCount :exec
UPDATE physical_files SET reference_count = reference_count - 1 WHERE id = $1;

-- name: DeleteFileReference :exec
DELETE FROM files WHERE id = $1;