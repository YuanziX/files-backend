-- +goose Up
ALTER TABLE folders ADD COLUMN real_path VARCHAR(1024) NOT NULL DEFAULT '/';

-- +goose Down
ALTER TABLE folders DROP COLUMN real_path;
