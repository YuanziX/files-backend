-- name: GetAllFilesForAdmin :many
SELECT
    f.id, f.filename, f.upload_date, f.download_count, f.owner_id,
    pf.mime_type, pf.size_bytes
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
ORDER BY f.upload_date DESC
LIMIT $1 OFFSET $2;

-- name: CountAllFilesForAdmin :one
SELECT COUNT(*) FROM files;
