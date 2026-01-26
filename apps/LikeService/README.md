# Like Service

A Next.js API service that provides a `/like` endpoint for handling post likes.

## API Endpoint

### `/api/like/[postid]`

Accepts a `postid` as a route parameter.

**Methods:**
- `GET /api/like/[postid]` - Retrieve like information for a post
- `POST /api/like/[postid]` - Like a post
- `DELETE /api/like/[postid]` - Unlike a post

**Example:**
```
GET /api/like/123
POST /api/like/123
DELETE /api/like/123
```

## How to Run

### Prerequisites

Make sure you have `pnpm` installed. If not, install it:
```bash
npm install -g pnpm
```

### Installation

From the root of the turborepo project, install dependencies:
```bash
pnpm install
```

### Development

To run the Like Service in development mode:

```bash
cd apps/LikeService
pnpm dev
```

Or from the root directory:
```bash
pnpm --filter like-service dev
```

The service will start on `http://localhost:3002`

### Build

To build the application:

```bash
cd apps/LikeService
pnpm build
```

### Production

To run the production build:

```bash
cd apps/LikeService
pnpm start
```

## Docker

### Building the Docker Image

To build the Docker image, run the following command from the **root of the monorepo**:

```bash
docker build -f apps/LikeService/Dockerfile -t like-service:latest .
```

This will create a Docker image tagged as `like-service:latest`.

### Running the Docker Container

To run the container:

```bash
docker run -p 3000:3000 like-service:latest
```

The service will be available at `http://localhost:3000`

## Testing the API

Once the server is running, you can test the API endpoint:

```bash
# GET request
curl http://localhost:3002/api/like/123

# POST request
curl -X POST http://localhost:3002/api/like/123

# DELETE request
curl -X DELETE http://localhost:3002/api/like/123
```

All requests will return a JSON response with the like count and whether the current user has liked the post.
