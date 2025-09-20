-- +goose Up
ALTER TABLE folders ALTER COLUMN real_path TYPE TEXT;

-- +goose Down
ALTER TABLE folders ALTER COLUMN real_path TYPE VARCHAR(1024);