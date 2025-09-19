-- +goose Up
CREATE EXTENSION IF NOT EXISTS ltree;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user',
    storage_quota_bytes BIGINT NOT NULL DEFAULT 10485760,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE physical_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content_hash VARCHAR(64) UNIQUE NOT NULL,
    mime_type VARCHAR(255) NOT NULL,
    size_bytes BIGINT NOT NULL,
    storage_path VARCHAR(1024) NOT NULL,
    reference_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_physical_files_hash ON physical_files(content_hash);

CREATE TABLE folders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES folders(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    path LTREE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (owner_id, parent_id, name)
);
CREATE INDEX idx_folders_owner ON folders(owner_id);
CREATE INDEX idx_folders_path ON folders USING GIST (path);

CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    physical_file_id UUID NOT NULL REFERENCES physical_files(id) ON DELETE RESTRICT,
    folder_id UUID REFERENCES folders(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    upload_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (owner_id, folder_id, filename)
);
CREATE INDEX idx_files_owner_folder ON files(owner_id, folder_id);
CREATE INDEX idx_files_physical_file ON files(physical_file_id);

CREATE TYPE share_type AS ENUM ('user', 'public');

CREATE TABLE shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    file_id UUID REFERENCES files(id) ON DELETE CASCADE,
    folder_id UUID REFERENCES folders(id) ON DELETE CASCADE,
    share_type share_type NOT NULL,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shared_with_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    public_token VARCHAR(255) UNIQUE,
    download_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_share_target CHECK (
        (file_id IS NOT NULL AND folder_id IS NULL) OR
        (file_id IS NULL AND folder_id IS NOT NULL)
    )
);
CREATE INDEX idx_shares_shared_with ON shares(shared_with_user_id);
CREATE INDEX idx_shares_token ON shares(public_token);

-- +goose Down
DROP TABLE IF EXISTS shares CASCADE;
DROP TABLE IF EXISTS files CASCADE;
DROP TABLE IF EXISTS folders CASCADE;
DROP TABLE IF EXISTS physical_files CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS share_type;
DROP EXTENSION IF EXISTS ltree;
