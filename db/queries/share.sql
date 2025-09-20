-- name: ShareFileWithUser :exec
INSERT INTO shares (file_id, folder_id, owner_id, shared_with_user_id, share_type)
VALUES ($1, NULL, $2, $3, 'user');

-- name: ShareFilePublicly :exec
INSERT INTO shares (file_id, folder_id, owner_id, public_token, share_type)
VALUES ($1, NULL, $2, $3, 'public');

-- name: ShareFolderWithUser :exec
INSERT INTO shares (file_id, folder_id, owner_id, shared_with_user_id, share_type)
VALUES (NULL, $1, $2, $3, 'user');

-- name: ShareFolderPublicly :exec
INSERT INTO shares (file_id, folder_id, owner_id, public_token, share_type)
VALUES (NULL, $1, $2, $3, 'public');

-- name: RevokePublicShare :exec
DELETE FROM shares
WHERE owner_id = $1
  AND public_token = $2
  AND share_type = 'public';

-- name: RevokeUserShare :exec
DELETE FROM shares
WHERE owner_id = $1
  AND (
    (file_id = $2 AND folder_id IS NULL)
    OR (folder_id = $2 AND file_id IS NULL)
  )
  AND shared_with_user_id = $3
  AND share_type = 'user';

-- name: CheckUserOwnsShare :one
SELECT EXISTS (
    SELECT 1 FROM shares
    WHERE public_token = $1 AND owner_id = $2
);

-- name: GetMyShares :many
SELECT * FROM shares
WHERE owner_id = $1;

-- name: GetFolderShares :many
SELECT * FROM shares
WHERE folder_id = $1
  AND owner_id = $2;

-- name: GetFileShares :many
SELECT * FROM shares
WHERE file_id = $1
  AND owner_id = $2;

-- name: GetFolderIdByPublicToken :one
SELECT folder_id FROM shares
WHERE public_token = $1
  AND share_type = 'public';