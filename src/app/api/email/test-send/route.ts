export const runtime = 'edge';

export async function POST(_req: Request) {
  // TODO: trimite email de test (ex: Resend)
  return Response.json({ ok: true, sent: true });
}