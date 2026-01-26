# Dockerfile for LikeService Next.js application
# 
# Prerequisites: Build the app locally first:
#   pnpm build --filter=like-service
#
# Build from the monorepo root directory:
#   docker build -f apps/LikeService/Dockerfile -t like-service:latest .
#
# Run the container:
#   docker run -p 3000:3000 like-service:latest

FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy pre-built standalone output from local filesystem
# The standalone build includes all dependencies and is self-contained
# Next.js standalone preserves the monorepo directory structure
# Structure: .next/standalone/system-design-course/apps/LikeService/server.js
COPY --chown=nextjs:nodejs apps/LikeService/.next/standalone ./
# Copy static files (they need to be in the same relative path as the app)
COPY --chown=nextjs:nodejs apps/LikeService/.next/static ./system-design-course/apps/LikeService/.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# The standalone build structure includes the monorepo root name
# Path: /app/system-design-course/apps/LikeService/server.js
WORKDIR /app/system-design-course/apps/LikeService
CMD ["node", "server.js"]
