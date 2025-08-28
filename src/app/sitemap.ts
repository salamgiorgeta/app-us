import type { MetadataRoute } from "next";
export default function sitemap(): MetadataRoute.Sitemap {
  const host = process.env.NEXT_PUBLIC_SITE_URL ?? "https://app-us.vercel.app";
  return [
    { url: `${host}/`, priority: 1.0, changeFrequency: "weekly" },
    { url: `${host}/about`, priority: 0.7, changeFrequency: "monthly" },
  ];
}
