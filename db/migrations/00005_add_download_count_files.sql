-- +goose Up
ALTER TABLE files ADD COLUMN download_count INT NOT NULL DEFAULT 0;

-- +goose Down
ALTER TABLE files DROP COLUMN download_count;
