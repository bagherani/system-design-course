import { NextRequest } from "next/server";

export async function GET(request: NextRequest) {
  const ip = request.headers.get("x-forwarded-for") ?? "unknown";
  const port = request.headers.get("x-forwarded-port") ?? "unknown";
  const serviceName = process.env.SERVICE_NAME ?? "engagement-service";
  const servicePort = process.env.SERVICE_PORT ?? "unknown";
  return new Response(`OK from ${ip}:${port} (backend: ${serviceName}:${servicePort})`);
}
