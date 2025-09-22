# files-backend

**files-backend** is a backend service written in Go that provides a robust API for file storage, management, and retrieval. It is designed for extensibility, security, and integration with cloud storage solutions (S3-compatible), supporting features required by modern file handling applications.

---

## Key Functionality

### 1. GraphQL API

- **GraphQL Playground**: Interactive endpoint at `/` for API exploration and testing.
- **Main API Endpoint**: `/query` for all GraphQL operations.
- **Authentication & Authorization**:
  - JWT-based authentication for user identification.
  - Role-based access control using custom GraphQL directives (`@auth`, `@hasRole`).

### 2. File Operations

- **Upload & Download**: Integrates with S3-compatible storage for efficient file upload and download.
- **Validation**: Ensures file size and MIME type compliance using custom utilities.
- **Presigned URLs**: Generates S3 presigned URLs for secure, temporary access to files.
- **Avoids reuploading files**: Uses references to already uploaded files rather than reuploading them, leveraging file hashes for deduplication.
- **Move/Delete Operations**: Supports moving files between folders and deleting files with proper validation.
- **Hash-based Reference**: Files can be referenced and managed via cryptographic hashes to prevent duplication and simplify management.

### 3. Folder and File Management

- **Folder CRUD**: API supports creation, querying, renaming, and deletion of folders.
- **Files**: Supports creating, moving, renaming, and deleting files.
- **Sorting & Filtering**: Advanced sorting and filtering options for files and folders based on name, type, size, and timestamps.
- **Bulk Operations**: Efficient bulk operations for moving or deleting multiple files/folders.

### 4. Database Integration

- **PostgreSQL**: Utilizes a connection pool for scalable database access.
- **Transactional Support**: Query interface supports transactions for atomic operations.
- **Schema Management**: Uses SQL migrations (`goose`) and code generation (`sqlc`) for type-safe queries.\*\*

### 5. S3 Integration

- **Configurable S3 Client**: Supports custom endpoints and credentials, allowing use with AWS S3, MinIO, or other compatible providers.
- **Presigning**: Generates presigned URLs for uploads/downloads, enabling secure, time-limited access.
- **Bucket Management**: All S3 bucket settings are environment-driven for easy deployment configuration.

### 6. Security & Middleware

- **JWT Secret Management**: Reads secrets from environment variables for token generation and verification.
- **CORS Support**: Configurable CORS to allow cross-origin requests from various clients.
- **Rate Limiting**: Per-IP rate limiting to mitigate abuse (`httprate` middleware).
- **Logging & Recovery**: Request logging and panic recovery middleware for robust error handling.
- **Custom Middleware**: User loader and role resolution middleware for flexible authentication/authorization flows.

### 7. Configuration

- **Environment-based Config**: Reads settings (port, DB URL, S3 keys, etc.) from `.env` for deployment flexibility.
- **S3 Settings**: All S3-related config (endpoint, region, bucket, credentials) are environment-driven.
- **Rate Limiting**: Number of requests and window duration configurable via environment variables.

### 8. Utilities

- **Token Generation**: Secure random token generation for various needs.
- **MIME Handling**: MIME type extraction and alias mapping for file validation.
- **Sort/Filter Builders**: Helper functions for constructing sort and filter parameters for queries.
- **File Verification**: Utilities for verifying file size, MIME type, and hash validity.

### 9. Docker Support

- **Dockerfile Included**: Multi-stage build for lightweight deployment; exposes port 8888 for service access.
- **Alpine Base Image**: Ensures minimal footprint and fast container startup.

---

## Architecture

- **Go Modules**: Modular codebase with clean separation (server, config, auth, storage, database).
- **Extensible GraphQL Schema**: Easily add new queries and mutations via `gqlgen`.
- **Dependency Injection**: Central struct (`Resolver`) for all shared resources.
- **Cloud Native**: Designed for containerized deployments and cloud integration.
- **Middleware-Driven**: Request/response pipeline built around composable middleware.

---

## Contributing

Open to issues and PRs for improvements or new features!
