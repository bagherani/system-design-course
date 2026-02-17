# Dockerfile for LikeServiceWithDB Next.js application
#
# Prerequisites: Build the app locally first:
#   pnpm build --filter=like-service-with-db
#
# Build from the monorepo root directory:
#   docker build -f apps/LikeServiceWithDB/Dockerfile -t like-service-with-db:latest .
#
# Run the container (set REDIS_CLUSTER_NODES for Redis):
#   docker run -p 3000:3000 -e REDIS_CLUSTER_NODES=... like-service-with-db:latest

FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --chown=nextjs:nodejs apps/LikeServiceWithDB/.next/standalone ./
COPY --chown=nextjs:nodejs apps/LikeServiceWithDB/.next/static ./system-design-course/apps/LikeServiceWithDB/.next/static

# Standalone in pnpm monorepo can omit next / workspace deps; install runtime deps (same pattern as UsersService)
WORKDIR /app/system-design-course/apps/LikeServiceWithDB
RUN rm -f package.json package-lock.json && \
  echo '{"name":"like-service-with-db","type":"module","dependencies":{"next":"16.1.0","react":"^19.2.0","react-dom":"^19.2.0","ioredis":"^5.4.1"}}' > package.json && \
  npm install --omit=dev && \
  chown -R nextjs:nodejs node_modules

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

WORKDIR /app/system-design-course/apps/LikeServiceWithDB
CMD ["node", "server.js"]
