import Link from "next/link";
export default function Navbar() {
  return (
    <nav className="container mx-auto flex gap-4 p-4">
      <Link href="/">Home</Link>
      <Link href="/about">About</Link>
    </nav>
  );
}
