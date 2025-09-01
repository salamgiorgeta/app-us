export const runtime = 'edge';

export async function GET() {
  // TODO: execută job digest (cron)
  return Response.json({ ok: true, job: 'digest' });
}
