# 🚀 Build & Package Scripts — EN–RO

This folder contains helper scripts to **build and package your Next.js project** into a ZIP,
ready for attaching to GitHub Releases.

---

## ⚙️ Scripts Included

### 1) build_and_package_npm.sh
- 🇬🇧 Uses **npm** to install dependencies, build, and package the project.
- 🇷🇴 Folosește **npm** pentru a instala dependențe, a construi și a arhiva proiectul.

**When to use / Când să-l folosești:**
- If your project has **package-lock.json** (npm lockfile).
- Dacă proiectul are **package-lock.json** (lockfile pentru npm).

**Run / Rulează:**
```bash
chmod +x build_and_package_npm.sh
./build_and_package_npm.sh
```

Optional variables / Variabile opționale:
```bash
APP_NAME="app-us" OUT_ZIP="app-us-build.zip" ROOT_DIR="." ./build_and_package_npm.sh
```

---

### 2) build_and_package_pnpm.sh
- 🇬🇧 Uses **pnpm** to install dependencies, build, and package the project.
- 🇷🇴 Folosește **pnpm** pentru a instala dependențe, a construi și a arhiva proiectul.

**When to use / Când să-l folosești:**
- If your project has **pnpm-lock.yaml** (pnpm lockfile).
- Dacă proiectul are **pnpm-lock.yaml** (lockfile pentru pnpm).

**Run / Rulează:**
```bash
chmod +x build_and_package_pnpm.sh
./build_and_package_pnpm.sh
```

Optional variables / Variabile opționale:
```bash
APP_NAME="app-us" OUT_ZIP="app-us-build.zip" ROOT_DIR="." ./build_and_package_pnpm.sh
```

---

## 📦 What the scripts do / Ce fac scripturile
1. Install deps → `npm ci` or `pnpm install`  
   🇷🇴 Instalează dependențele.
2. Run build → `npm run build` or `pnpm build`  
   🇷🇴 Rulează build-ul de producție.
3. Collects files → `.next/`, `public/`, `package.json`, lockfile, configs, optional helpers.  
   🇷🇴 Colectează fișierele necesare.
4. Creates ZIP → `app-us-build.zip`  
   🇷🇴 Creează arhiva finală pentru Release.

---

## ✅ Checklist before Release / Checklist înainte de Release
- [ ] Build succeeds locally (`npm run build` or `pnpm build`).
- [ ] ZIP contains `.next/`, `public/`, `package.json`, lockfile, configs.
- [ ] Attach ZIP to GitHub Release (Assets).

---
