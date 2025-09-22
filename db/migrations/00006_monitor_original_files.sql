-- +goose Up
ALTER TABLE files ADD COLUMN is_original BOOLEAN NOT NULL DEFAULT FALSE;

-- +goose Down
ALTER TABLE files DROP COLUMN is_original;