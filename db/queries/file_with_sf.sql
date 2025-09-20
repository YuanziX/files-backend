-- name: ListFilesByFolderWithSortAndFilter :many
SELECT 
    f.id,
    f.filename,
    f.upload_date,
    pf.size_bytes,
    pf.mime_type,
    f.owner_id,
    f.physical_file_id,
    f.folder_id
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE 
    f.folder_id = sqlc.narg('folder_id')::uuid
    AND (sqlc.narg('filename_filter')::text IS NULL OR f.filename ILIKE '%' || sqlc.narg('filename_filter') || '%')
    AND (sqlc.narg('mime_type_filter')::text IS NULL OR pf.mime_type ILIKE '%' || sqlc.narg('mime_type_filter') || '%')
    AND (sqlc.narg('min_size')::bigint IS NULL OR pf.size_bytes >= sqlc.narg('min_size'))
    AND (sqlc.narg('max_size')::bigint IS NULL OR pf.size_bytes <= sqlc.narg('max_size'))
    AND (sqlc.narg('uploaded_after')::timestamptz IS NULL OR f.upload_date >= sqlc.narg('uploaded_after'))
    AND (sqlc.narg('uploaded_before')::timestamptz IS NULL OR f.upload_date <= sqlc.narg('uploaded_before'))
ORDER BY
    CASE WHEN sqlc.narg('sort_field')::text = 'FILENAME' AND sqlc.narg('sort_order')::text = 'ASC' THEN f.filename END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'FILENAME' AND sqlc.narg('sort_order')::text = 'DESC' THEN f.filename END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'SIZE' AND sqlc.narg('sort_order')::text = 'ASC' THEN pf.size_bytes END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'SIZE' AND sqlc.narg('sort_order')::text = 'DESC' THEN pf.size_bytes END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'UPLOAD_DATE' AND sqlc.narg('sort_order')::text = 'ASC' THEN f.upload_date END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'UPLOAD_DATE' AND sqlc.narg('sort_order')::text = 'DESC' THEN f.upload_date END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'MIME_TYPE' AND sqlc.narg('sort_order')::text = 'ASC' THEN pf.mime_type END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'MIME_TYPE' AND sqlc.narg('sort_order')::text = 'DESC' THEN pf.mime_type END DESC,
    f.filename ASC;

-- name: ListRootFilesByOwnerWithSortAndFilter :many
SELECT 
    f.id,
    f.filename,
    f.upload_date,
    pf.size_bytes,
    pf.mime_type,
    f.owner_id,
    f.physical_file_id,
    f.folder_id
FROM files f
JOIN physical_files pf ON f.physical_file_id = pf.id
WHERE 
    f.owner_id = @owner_id
    AND f.folder_id IS NULL
    AND (sqlc.narg('filename_filter')::text IS NULL OR f.filename ILIKE '%' || sqlc.narg('filename_filter') || '%')
    AND (sqlc.narg('mime_type_filter')::text IS NULL OR pf.mime_type ILIKE '%' || sqlc.narg('mime_type_filter') || '%')
    AND (sqlc.narg('min_size')::bigint IS NULL OR pf.size_bytes >= sqlc.narg('min_size'))
    AND (sqlc.narg('max_size')::bigint IS NULL OR pf.size_bytes <= sqlc.narg('max_size'))
    AND (sqlc.narg('uploaded_after')::timestamptz IS NULL OR f.upload_date >= sqlc.narg('uploaded_after'))
    AND (sqlc.narg('uploaded_before')::timestamptz IS NULL OR f.upload_date <= sqlc.narg('uploaded_before'))
ORDER BY
    CASE WHEN sqlc.narg('sort_field')::text = 'FILENAME' AND sqlc.narg('sort_order')::text = 'ASC' THEN f.filename END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'FILENAME' AND sqlc.narg('sort_order')::text = 'DESC' THEN f.filename END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'SIZE' AND sqlc.narg('sort_order')::text = 'ASC' THEN pf.size_bytes END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'SIZE' AND sqlc.narg('sort_order')::text = 'DESC' THEN pf.size_bytes END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'UPLOAD_DATE' AND sqlc.narg('sort_order')::text = 'ASC' THEN f.upload_date END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'UPLOAD_DATE' AND sqlc.narg('sort_order')::text = 'DESC' THEN f.upload_date END DESC,
    CASE WHEN sqlc.narg('sort_field')::text = 'MIME_TYPE' AND sqlc.narg('sort_order')::text = 'ASC' THEN pf.mime_type END ASC,
    CASE WHEN sqlc.narg('sort_field')::text = 'MIME_TYPE' AND sqlc.narg('sort_order')::text = 'DESC' THEN pf.mime_type END DESC,
    f.filename ASC;