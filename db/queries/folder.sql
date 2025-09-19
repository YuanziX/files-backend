-- name: GetFolderPath :one
SELECT path FROM folders WHERE id = $1 AND owner_id = $2;

-- name: CreateFolder :one
INSERT INTO folders (id, owner_id, parent_id, name, path)
VALUES ($1, $2, $3, $4, $5)
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
WHERE id = $1;

-- name: DeleteFolder :exec
DELETE FROM folders
WHERE id = $1 AND owner_id = $2;

-- name: DecrementPhysicalFileRefsInFolder :exec
UPDATE physical_files pf
SET reference_count = reference_count - 1
WHERE pf.id IN (
    SELECT f.physical_file_id
    FROM files f
    JOIN folders fo ON fo.id = f.folder_id
    WHERE fo.path <@ (SELECT target.path FROM folders target WHERE target.id = $1)
);

-- name: DeleteFilesInFolder :exec
DELETE FROM files f
WHERE f.folder_id IN (
    SELECT fo.id
    FROM folders fo
    WHERE fo.path <@ (SELECT target.path FROM folders target WHERE target.id = $1)
);

-- name: DeleteFoldersRecursively :exec
DELETE FROM folders fo
WHERE fo.path <@ (SELECT target.path FROM folders target WHERE target.id = $1);

-- name: CanAccessFolder :one
SELECT EXISTS (
    SELECT 1
    FROM shares s
    JOIN folders f ON f.id = $1
    JOIN folders sf ON sf.id = s.folder_id
    WHERE f.path <@ sf.path
      AND (
        (s.share_type = 'public' AND s.public_token = $2)
        OR
        (s.share_type = 'user' AND s.shared_with_user_id = $3)
      )
);
