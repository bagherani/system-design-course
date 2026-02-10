# Dockerfile for UsersService Next.js application
#
# Prerequisites: Build the app locally first:
#   pnpm build --filter=users-service
#
# Build from the monorepo root directory:
#   docker build -f apps/UsersService/Dockerfile -t users-service:latest .
#
# Run the container:
#   docker run -p 3000:3000 users-service:latest

FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy pre-built standalone output from local filesystem
# Next.js standalone preserves the monorepo directory structure
# Structure: .next/standalone/system-design-course/apps/UsersService/server.js
COPY --chown=nextjs:nodejs apps/UsersService/.next/standalone ./
# Copy static files (they need to be in the same relative path as the app)
COPY --chown=nextjs:nodejs apps/UsersService/.next/static ./system-design-course/apps/UsersService/.next/static

# Standalone trace in pnpm monorepo can omit next/cassandra-driver; install runtime deps (same pattern as other apps that need extra deps)
WORKDIR /app/system-design-course/apps/UsersService
RUN rm -f package.json package-lock.json && \
  echo '{"name":"users-service","type":"module","dependencies":{"next":"16.1.0","cassandra-driver":"^4.8.0","react":"^19.2.0","react-dom":"^19.2.0"}}' > package.json && \
  npm install --omit=dev && \
  chown -R nextjs:nodejs node_modules

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Path: /app/system-design-course/apps/UsersService/server.js
WORKDIR /app/system-design-course/apps/UsersService
CMD ["node", "server.js"]
