# Dockerfile for LikeService Next.js application
# 
# Build from the monorepo root directory:
#   docker build -f apps/LikeService/Dockerfile -t like-service:latest .
#
# Run the container:
#   docker run -p 3000:3000 like-service:latest

# Stage 1: Dependencies
FROM node:18-alpine AS deps
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages ./packages
COPY apps/LikeService/package.json ./apps/LikeService/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Stage 2: Builder
FROM node:18-alpine AS builder
RUN corepack enable && corepack prepare pnpm@9.0.0 --activate
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/packages ./packages

# Copy source files
COPY apps/LikeService ./apps/LikeService
COPY package.json pnpm-workspace.yaml ./

# Set working directory to the app
WORKDIR /app/apps/LikeService

# Build the Next.js app
RUN pnpm build

# Stage 3: Runner
FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy necessary files from builder
# Note: standalone mode bundles all dependencies, so we copy the entire standalone directory
COPY --from=builder --chown=nextjs:nodejs /app/apps/LikeService/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/apps/LikeService/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/LikeService/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
