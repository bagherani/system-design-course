# Dockerfile for FeedService Next.js application.
# Multi-stage: build in Docker so standalone output (including node_modules) is complete.
# Build from monorepo root: docker build -f apps/FeedService/Dockerfile -t feed-service:latest .

FROM node:20-alpine AS builder
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

COPY . .
RUN pnpm install
RUN pnpm build --filter=feed-service

# Runner: copy only the standalone output (has node_modules + server.js)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy full standalone tree from builder (structure is apps/FeedService/ + node_modules at /app)
COPY --from=builder /app/apps/FeedService/.next/standalone ./
COPY --from=builder /app/apps/FeedService/.next/static ./apps/FeedService/.next/static

# grpc-engagement loads proto at runtime; path resolves to /app/packages/grpc-engagement/proto/engagement.proto
RUN mkdir -p /app/packages/grpc-engagement/proto && chown -R nextjs:nodejs /app/packages
COPY --from=builder --chown=nextjs:nodejs /app/packages/grpc-engagement/proto/engagement.proto /app/packages/grpc-engagement/proto/engagement.proto

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

WORKDIR /app/apps/FeedService
CMD ["node", "server.js"]
