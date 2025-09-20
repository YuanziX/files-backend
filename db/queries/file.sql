-- name: ListFilesByFolder :many
SELECT
    f.id, f.filename, f.upload_date,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.folder_id = $1
ORDER BY f.filename;

-- name: ListRootFilesByOwner :many
SELECT
    f.id, f.filename, f.upload_date,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.owner_id = $1 AND f.folder_id IS NULL
ORDER BY f.filename;

-- name: GetFileById :one
SELECT
    f.owner_id, f.id, f.filename, f.upload_date,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.id = $1;

-- name: CanAccessFile :one
SELECT EXISTS (
    SELECT 1
    FROM shares s
    WHERE s.file_id = $1
      AND (
        (s.share_type = 'public' AND s.public_token = $2)
        OR
        (s.share_type = 'user' AND s.shared_with_user_id = $3)
      )
    
    UNION
    
    SELECT 1
    FROM shares s
    JOIN folders sf ON sf.id = s.folder_id
    JOIN files f ON f.id = $1
    JOIN folders ff ON ff.id = f.folder_id
    WHERE ff.path <@ sf.path
      AND (
        (s.share_type = 'public' AND s.public_token = $2)
        OR
        (s.share_type = 'user' AND s.shared_with_user_id = $3)
      )
);

-- name: GetFileForDownload :one
SELECT
    f.owner_id,
    f.filename,
    pf.content_hash
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE f.id = $1;

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

-- name: CheckFileOwnership :one
SELECT EXISTS (
    SELECT 1 FROM files WHERE id = $1 AND owner_id = $2
);

-- name: GetFileByIdAndOwner :one
SELECT * FROM files WHERE id = $1
AND owner_id = $2;

