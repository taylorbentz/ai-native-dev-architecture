// Illustrative health-check route. Generic placeholder — no real framework wired up.

interface HealthResponse {
  status: "ok";
  uptimeSeconds: number;
}

const startedAt = Date.now();

export function health(): HealthResponse {
  return {
    status: "ok",
    uptimeSeconds: Math.floor((Date.now() - startedAt) / 1000),
  };
}
