export function getStreamProxyUrl(originalUrl: string): string {
  try {
    const parsed = new URL(originalUrl);
    const host = parsed.protocol + "//" + parsed.host;
    const hostEncoded = btoa(host).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
    const path = parsed.pathname.replace(/^\//, "");
    const query = parsed.search ? parsed.search : "";
    return `/api/stream/${hostEncoded}/${path}${query}`;
  } catch {
    return originalUrl;
  }
}
