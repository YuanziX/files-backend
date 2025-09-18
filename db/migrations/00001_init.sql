-- +goose Up
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
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (owner_id, parent_id, name)
);

CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    physical_file_id UUID NOT NULL REFERENCES physical_files(id) ON DELETE RESTRICT,
    folder_id UUID REFERENCES folders(id) ON DELETE SET NULL,
    filename VARCHAR(255) NOT NULL,
    tags TEXT[],
    upload_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (owner_id, folder_id, filename)
);

CREATE TABLE shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    file_id UUID REFERENCES files(id) ON DELETE CASCADE,
    folder_id UUID REFERENCES folders(id) ON DELETE CASCADE,
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shared_with_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    share_type VARCHAR(50) NOT NULL,
    public_token VARCHAR(255) UNIQUE,
    download_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_share_target CHECK ((file_id IS NOT NULL AND folder_id IS NULL) OR (file_id IS NULL AND folder_id IS NOT NULL))
);

-- +goose Down
DROP TABLE IF EXISTS shares;
DROP TABLE IF EXISTS files;
DROP TABLE IF EXISTS folders;
DROP TABLE IF EXISTS physical_files;
DROP TABLE IF EXISTS users;
