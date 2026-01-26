import { NextRequest } from "next/server";

export async function GET(request: NextRequest) {
  // return the current server ip address and port
  const ip = request.headers.get("x-forwarded-for") ?? "unknown";
  const port = request.headers.get("x-forwarded-port") ?? "unknown";
  // Get service identification from environment variables
  const serviceName = process.env.SERVICE_NAME ?? "unknown";
  const servicePort = process.env.SERVICE_PORT ?? "unknown";
  return new Response(`OK from ${ip}:${port} (backend: ${serviceName}:${servicePort})`);
}