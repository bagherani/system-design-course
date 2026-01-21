# Like Service

A Next.js API service that provides a `/like` endpoint for handling post likes.

## API Endpoint

### `/api/like/[postid]`

Accepts a `postid` as a route parameter.

**Methods:**
- `GET /api/like/[postid]` - Retrieve like information for a post
- `POST /api/like/[postid]` - Like a post

**Example:**
```
GET /api/like/123
POST /api/like/123
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

## Testing the API

Once the server is running, you can test the API endpoint:

```bash
# GET request
curl http://localhost:3002/api/like/123

# POST request
curl -X POST http://localhost:3002/api/like/123
```

Both requests will return a JSON response with the postid that was provided.
