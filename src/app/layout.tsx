import type { Metadata } from "next";

import "./globals.css";
import Navbar from "@/components/Navbar";
export const metadata: Metadata = {

 title: "app-us",
  description: "Next.js + Tailwind + Prettier starter",
};
export default function RootLayout({ children }: { children: React.ReactNode }) {
return (

<html lang="en">
 <body className="min-h-screen">
 <header className="border-b">
 <Navbar />
 </header>
 <main className="container mx-auto p-4">{children}</main>
 </body>
  </html>
);

}
