#!/bin/sh
set -e

# Start gRPC server in background (port 50051)
# Use tsx so we can run grpc-server.ts (@repo/grpc-engagement is TS). Prefer .bin, else node.
TSX=""
for p in /app/node_modules/.bin/tsx /app/apps/EngagementService/node_modules/.bin/tsx; do
  if [ -x "$p" ]; then TSX="$p"; break; fi
done
if [ -z "$TSX" ] && [ -f /app/node_modules/tsx/dist/cli.mjs ]; then
  TSX="node /app/node_modules/tsx/dist/cli.mjs"
fi
if [ -z "$TSX" ]; then
  echo "Error: tsx not found" >&2
  exit 1
fi
(cd /app/apps/EngagementService && $TSX scripts/grpc-server.ts) &
GRPC_PID=$!

# Find server.js under standalone (path can vary; Next.js puts it under system-design-course/apps/EngagementService)
STANDALONE_ROOT="/app/apps/EngagementService/.next/standalone"
SERVER_JS=$(find "$STANDALONE_ROOT" -name 'server.js' -type f -path '*apps/EngagementService*' 2>/dev/null | head -1)

if [ -z "$SERVER_JS" ]; then
  echo "Error: server.js not found under $STANDALONE_ROOT"
  exit 1
fi

# Copy static files next to server.js if needed (create .next if missing)
SERVER_DIR=$(dirname "$SERVER_JS")
if [ -d "/app/apps/EngagementService/.next/static" ] && [ ! -d "$SERVER_DIR/.next/static" ]; then
  mkdir -p "$SERVER_DIR/.next"
  cp -r /app/apps/EngagementService/.next/static "$SERVER_DIR/.next/"
fi

# Run Next.js in foreground (port 3000); run from app dir so Node finds node_modules (parent has it)
export PORT=3000
export HOSTNAME="0.0.0.0"
cd "$(dirname "$SERVER_JS")"
exec node server.js
