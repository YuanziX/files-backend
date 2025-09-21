-- +goose Up
CREATE INDEX idx_files_full_text ON files USING GIN (to_tsvector('english', filename));
CREATE INDEX idx_folders_full_text ON folders USING GIN (to_tsvector('english', name));

-- +goose Down
DROP INDEX idx_files_full_text;
DROP INDEX idx_folders_full_text;