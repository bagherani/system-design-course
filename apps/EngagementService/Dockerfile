# Dockerfile for EngagementService (Next.js + gRPC server).
# Builds the app inside Docker and runs both processes.
# Build from the monorepo root: docker build -f apps/EngagementService/Dockerfile -t engagement-service:latest .

# Next.js 16 requires Node >= 20.9.0
FROM node:20-alpine AS builder
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

# Copy full monorepo so workspace install and build work
COPY . .

# Use install without --frozen-lockfile so lockfile format matches image pnpm version
RUN pnpm install
RUN pnpm build --filter=engagement-service

# Runner: run Next.js + gRPC server
FROM node:20-alpine AS runner
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.0.0 --activate

COPY --from=builder /app/package.json /app/pnpm-lock.yaml /app/pnpm-workspace.yaml ./
COPY --from=builder /app/apps/EngagementService ./apps/EngagementService
COPY --from=builder /app/packages/grpc-engagement ./packages/grpc-engagement
COPY --from=builder /app/node_modules ./node_modules

# Put static files where Next.js standalone expects them (create .next first; standalone doesn't include it)
RUN mkdir -p apps/EngagementService/.next/standalone/system-design-course/apps/EngagementService/.next && \
    cp -r apps/EngagementService/.next/static apps/EngagementService/.next/standalone/system-design-course/apps/EngagementService/.next/

COPY --from=builder /app/apps/EngagementService/scripts/docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000 50051

ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
ENV ENGAGEMENT_GRPC_PORT=50051

ENTRYPOINT ["/entrypoint.sh"]
