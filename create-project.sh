#!/bin/bash

# ─────────────────────────────────────────────────────────────
# create-project.sh
# Creates a new project repo from George's design template.
# Branches scaffold, config, and CLAUDE.md based on project type.
#
# Prerequisites:
#   - GitHub CLI installed and authenticated (gh auth login)
#   - Node.js 18+ installed
#   - VS Code CLI installed (code command available)
#   - T7 Editing external drive mounted (preferred)
# ─────────────────────────────────────────────────────────────

set -e

TEMPLATE_REPO="georgeyiakoumi/project-template"
DRIVE_NAME="T7 Editing"
DRIVE_PATH="/Volumes/$DRIVE_NAME"
PROJECTS_DIR="$DRIVE_PATH/Projects"
FALLBACK_DIR="$HOME/Projects"

# ── Colours ──────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}╔══════════════════════════════════╗${RESET}"
echo -e "${BOLD}║     New Project Setup            ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════╝${RESET}"
echo ""

# ── Check prerequisites ───────────────────────────────────────
echo -e "${BLUE}Checking prerequisites...${RESET}"

if ! command -v gh &> /dev/null; then
  echo -e "${RED}✗ GitHub CLI (gh) not found. Install: https://cli.github.com${RESET}"
  exit 1
fi

if ! command -v node &> /dev/null; then
  echo -e "${RED}✗ Node.js not found. Install: https://nodejs.org${RESET}"
  exit 1
fi

if ! command -v code &> /dev/null; then
  echo -e "${YELLOW}⚠ VS Code CLI (code) not found — open the project manually after.${RESET}"
  VSCODE_AVAILABLE=false
else
  VSCODE_AVAILABLE=true
fi

echo -e "${GREEN}✓ Prerequisites met${RESET}"
echo ""

# ── Check T7 Editing drive ────────────────────────────────────
if [ -d "$DRIVE_PATH" ]; then
  echo -e "${GREEN}✓ $DRIVE_NAME is connected${RESET}"
  mkdir -p "$PROJECTS_DIR"
  ACTIVE_DIR="$PROJECTS_DIR"
else
  echo -e "${YELLOW}⚠ $DRIVE_NAME is not connected.${RESET}"
  echo -e "  Projects will be saved to ${YELLOW}$FALLBACK_DIR${RESET} instead."
  echo ""
  read -p "Continue with fallback location? (y/n): " USE_FALLBACK
  if [[ "$USE_FALLBACK" != "y" && "$USE_FALLBACK" != "Y" ]]; then
    echo -e "${RED}Aborted. Connect $DRIVE_NAME and try again.${RESET}"
    exit 0
  fi
  mkdir -p "$FALLBACK_DIR"
  ACTIVE_DIR="$FALLBACK_DIR"
fi

echo ""

# ── Project name ──────────────────────────────────────────────
while true; do
  read -p "$(echo -e ${BOLD})Project name (kebab-case, e.g. client-dashboard): $(echo -e ${RESET})" PROJECT_NAME

  if [[ -z "$PROJECT_NAME" ]]; then
    echo -e "${RED}✗ Project name cannot be empty.${RESET}"
    echo ""
    continue
  fi

  if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}✗ Use lowercase letters, numbers, and hyphens only.${RESET}"
    echo ""
    continue
  fi

  if gh repo view "georgeyiakoumi/$PROJECT_NAME" &> /dev/null; then
    echo -e "${RED}✗ A repo named '$PROJECT_NAME' already exists on your GitHub account.${RESET}"
    echo ""
    continue
  fi

  if [ -d "$ACTIVE_DIR/$PROJECT_NAME" ]; then
    echo -e "${YELLOW}⚠ A folder named '$PROJECT_NAME' already exists at $ACTIVE_DIR${RESET}"
    read -p "Delete it and continue? (y/n): " DELETE_FOLDER
    if [[ "$DELETE_FOLDER" == "y" || "$DELETE_FOLDER" == "Y" ]]; then
      rm -rf "$ACTIVE_DIR/$PROJECT_NAME"
      echo -e "${GREEN}✓ Deleted $ACTIVE_DIR/$PROJECT_NAME${RESET}"
    else
      echo ""
      continue
    fi
  fi

  break
done

# ── Project type ──────────────────────────────────────────────
echo ""
echo -e "${BOLD}What are you building?${RESET}"
echo -e "  ${CYAN}1)${RESET} Web app        — Next.js + shadcn + Tailwind + Supabase + Netlify"
echo -e "  ${CYAN}2)${RESET} Marketing site — Next.js + shadcn + Tailwind + Netlify"
echo -e "  ${CYAN}3)${RESET} Content site   — Next.js + shadcn + Tailwind + Strapi + Render + Netlify"
echo -e "  ${CYAN}4)${RESET} UI component   — Next.js + shadcn + Tailwind only"
echo -e "  ${CYAN}5)${RESET} Prototype      — Next.js + shadcn + Tailwind only"
echo ""
read -p "$(echo -e ${BOLD})Choose (1-5): $(echo -e ${RESET})" PROJECT_TYPE

case $PROJECT_TYPE in
  1)
    PROJECT_TYPE_LABEL="Web app"
    STACK_SUMMARY="Next.js · shadcn/ui · Tailwind CSS · Supabase · Netlify"
    USE_SUPABASE=true
    USE_NETLIFY=true
    USE_STRAPI=false
    STACK_BLOCK="| Framework | Next.js (App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Icons | Lucide React |
| Database | Supabase |
| Deployment | Netlify |"
    MCP_BLOCK="| **Linear** | Creating/updating issues, logging decisions, tracking progress |
| **Notion** | Creating/updating the master plan document |
| **Netlify** | Checking deployment status and environment config |
| **GitHub** | Repo access, branch/PR status |
| **Excalidraw** | Generating IA diagrams and user flows |"
    ;;
  2)
    PROJECT_TYPE_LABEL="Marketing site"
    STACK_SUMMARY="Next.js · shadcn/ui · Tailwind CSS · Netlify"
    USE_SUPABASE=false
    USE_NETLIFY=true
    USE_STRAPI=false
    STACK_BLOCK="| Framework | Next.js (App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Icons | Lucide React |
| Deployment | Netlify |"
    MCP_BLOCK="| **Linear** | Creating/updating issues, logging decisions, tracking progress |
| **Notion** | Creating/updating the master plan document |
| **Netlify** | Checking deployment status and environment config |
| **GitHub** | Repo access, branch/PR status |
| **Excalidraw** | Generating IA diagrams and user flows |"
    ;;
  3)
    PROJECT_TYPE_LABEL="Content site"
    STACK_SUMMARY="Next.js · shadcn/ui · Tailwind CSS · Strapi · Render · Netlify"
    USE_SUPABASE=true
    USE_NETLIFY=true
    USE_STRAPI=true
    STACK_BLOCK="| Framework | Next.js (App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Icons | Lucide React |
| CMS | Strapi (subfolder → deployed to Render) |
| Database | Supabase (used by Strapi) |
| Deployment | Netlify (frontend) · Render (Strapi) |"
    MCP_BLOCK="| **Linear** | Creating/updating issues, logging decisions, tracking progress |
| **Notion** | Creating/updating the master plan document |
| **Netlify** | Checking frontend deployment status |
| **GitHub** | Repo access, branch/PR status |
| **Excalidraw** | Generating IA diagrams and user flows |"
    ;;
  4)
    PROJECT_TYPE_LABEL="UI component"
    STACK_SUMMARY="Next.js · shadcn/ui · Tailwind CSS"
    USE_SUPABASE=false
    USE_NETLIFY=false
    USE_STRAPI=false
    STACK_BLOCK="| Framework | Next.js (App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Icons | Lucide React |"
    MCP_BLOCK="| **Linear** | Creating/updating issues, logging decisions, tracking progress |
| **Notion** | Creating/updating the master plan document |
| **GitHub** | Repo access, branch/PR status |
| **Excalidraw** | Generating IA diagrams and user flows |"
    ;;
  5)
    PROJECT_TYPE_LABEL="Prototype"
    STACK_SUMMARY="Next.js · shadcn/ui · Tailwind CSS"
    USE_SUPABASE=false
    USE_NETLIFY=false
    USE_STRAPI=false
    STACK_BLOCK="| Framework | Next.js (App Router) |
| Styling | Tailwind CSS |
| Components | shadcn/ui |
| Icons | Lucide React |"
    MCP_BLOCK="| **Linear** | Creating/updating issues, logging decisions, tracking progress |
| **Notion** | Creating/updating the master plan document |
| **GitHub** | Repo access, branch/PR status |
| **Excalidraw** | Generating IA diagrams and user flows |"
    ;;
  *)
    echo -e "${RED}✗ Invalid choice. Run the script again and enter 1–5.${RESET}"
    exit 1
    ;;
esac

# ── Visibility ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Repo visibility:${RESET}"
select VISIBILITY in "private" "public"; do
  case $VISIBILITY in
    private|public) break;;
  esac
done

# ── Confirm ───────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Summary:${RESET}"
echo -e "  Name:       ${GREEN}$PROJECT_NAME${RESET}"
echo -e "  Type:       ${CYAN}$PROJECT_TYPE_LABEL${RESET}"
echo -e "  Stack:      $STACK_SUMMARY"
echo -e "  Visibility: $VISIBILITY"
echo -e "  Location:   ${BLUE}$ACTIVE_DIR/$PROJECT_NAME${RESET}"
echo ""
read -p "Continue? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

cd "$ACTIVE_DIR"

echo ""
echo -e "${BLUE}Creating GitHub repo from template...${RESET}"

if [ "$VISIBILITY" = "private" ]; then
  gh repo create "$PROJECT_NAME" \
    --template "$TEMPLATE_REPO" \
    --private \
    --clone
else
  gh repo create "$PROJECT_NAME" \
    --template "$TEMPLATE_REPO" \
    --public \
    --clone
fi

echo -e "${GREEN}✓ Repo created and cloned${RESET}"
cd "$PROJECT_NAME"

# ── Tailor scaffold based on project type ─────────────────────
echo ""
echo -e "${BLUE}Configuring scaffold for: $PROJECT_TYPE_LABEL...${RESET}"

if [ "$USE_SUPABASE" = false ]; then
  rm -rf supabase
  rm -f lib/supabase/client.ts lib/supabase/server.ts
  rmdir lib/supabase 2>/dev/null || true
  echo -e "  ${YELLOW}↳ Removed Supabase config${RESET}"
fi

if [ "$USE_NETLIFY" = false ]; then
  rm -f netlify.toml
  echo -e "  ${YELLOW}↳ Removed Netlify config${RESET}"
fi

# Rebuild .env.example to match the stack
if [ "$USE_SUPABASE" = false ]; then
  cat > .env.example << 'EOF'
# ── App ───────────────────────────────────────────────────────
NEXT_PUBLIC_APP_URL=http://localhost:3000
EOF
fi

if [ "$USE_STRAPI" = true ]; then
  cat >> .env.example << 'EOF'

# ── Strapi ────────────────────────────────────────────────────
# Set once Strapi is deployed to Render
NEXT_PUBLIC_STRAPI_URL=http://localhost:1337
STRAPI_API_TOKEN=your-strapi-api-token
EOF

  mkdir -p strapi
  cat > strapi/README.md << 'EOF'
# Strapi CMS

This subfolder contains the Strapi CMS instance for this project.

## Local setup

```bash
cd strapi
npx create-strapi-app@latest . --quickstart
```

## Deploying to Render

1. Push this repo to GitHub
2. Go to render.com → New Web Service → connect this repo
3. Set root directory to `strapi`
4. Build command: `npm run build`
5. Start command: `npm run start`

Set these environment variables in Render:
- `DATABASE_URL` — Supabase connection string (Settings → Database → URI)
- `ADMIN_JWT_SECRET` — run: openssl rand -base64 32
- `API_TOKEN_SALT`   — run: openssl rand -base64 32
- `APP_KEYS`         — run: openssl rand -base64 32
- `JWT_SECRET`       — run: openssl rand -base64 32

Once deployed, copy the Render URL to NEXT_PUBLIC_STRAPI_URL in Netlify env vars.
EOF
  echo -e "  ${YELLOW}↳ Added Strapi subfolder — see strapi/README.md to init${RESET}"
fi

echo -e "${GREEN}✓ Scaffold configured${RESET}"

# ── Inject project identity into CLAUDE.md ────────────────────
echo ""
echo -e "${BLUE}Updating CLAUDE.md...${RESET}"

ORIGINAL_CLAUDE=$(cat CLAUDE.md)

cat > CLAUDE.md << EOF
# Project: $PROJECT_NAME
**Type:** $PROJECT_TYPE_LABEL
**Created:** $(date +%Y-%m-%d)

## Stack

| Layer | Tool |
|---|---|
$STACK_BLOCK

## Active MCPs

| MCP | When to use |
|---|---|
$MCP_BLOCK

**Standing rules:**
- Log decisions and trade-offs as comments on the relevant Linear issue — not just in conversation
- If scope changes, update Notion first, then adjust Linear to match
- Never create Linear issues without a corresponding Notion plan entry

---

$ORIGINAL_CLAUDE
EOF

echo -e "${GREEN}✓ CLAUDE.md updated${RESET}"

# ── Rewrite README.md for this project type ───────────────────
echo -e "${BLUE}Updating README.md...${RESET}"

# Build env vars section
if [ "$USE_SUPABASE" = true ] && [ "$USE_STRAPI" = true ]; then
  ENV_SECTION='After the script runs, open `.env.local` and fill in your credentials:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_STRAPI_URL=http://localhost:1337
STRAPI_API_TOKEN=your-strapi-api-token
```

Find Supabase keys under **Settings → API** in your Supabase project. Strapi keys are set once Strapi is deployed to Render.'
elif [ "$USE_SUPABASE" = true ]; then
  ENV_SECTION='After the script runs, open `.env.local` and fill in your Supabase credentials:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

Find these in your Supabase project under **Settings → API**.'
else
  ENV_SECTION='After the script runs, `.env.local` is ready to go:

```bash
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

No external services to configure.'
fi

# Build deployment section
if [ "$USE_NETLIFY" = true ] && [ "$USE_STRAPI" = true ]; then
  DEPLOY_SECTION='## Deployment

### Frontend (Netlify)

Configured via `netlify.toml`. To connect:

1. Push the repo to GitHub
2. Go to [netlify.com](https://netlify.com) → Add new site → Import from GitHub
3. Select the repo — build settings are pre-configured
4. Add environment variables: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `NEXT_PUBLIC_APP_URL`, `NEXT_PUBLIC_STRAPI_URL`, `STRAPI_API_TOKEN`
5. Deploy

### Strapi CMS (Render)

See `strapi/README.md` for full setup instructions.'
elif [ "$USE_NETLIFY" = true ]; then
  DEPLOY_SECTION="## Deployment

Configured for Netlify via \`netlify.toml\`. To connect:

1. Push the repo to GitHub
2. Go to [netlify.com](https://netlify.com) → Add new site → Import from GitHub
3. Select the repo — build settings are pre-configured
4. Add environment variables in **Site → Environment variables**
5. Deploy"
else
  DEPLOY_SECTION='## Running locally

```bash
npm run dev
```

No deployment target is configured. Add one when you are ready to ship.'
fi

# Build repo structure section
if [ "$USE_SUPABASE" = true ] && [ "$USE_STRAPI" = true ]; then
  STRUCTURE_SECTION='```
├── CLAUDE.md
├── .claude/
│   ├── project-setup.md
│   ├── design-psychology.md
│   ├── ui-standards.md
│   └── ux-process.md
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/ui/
├── lib/
│   ├── utils.ts
│   └── supabase/
│       ├── client.ts
│       └── server.ts
├── strapi/
│   └── README.md
├── supabase/
│   └── config.toml
├── public/
├── .env.example
├── netlify.toml
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```'
elif [ "$USE_SUPABASE" = true ]; then
  STRUCTURE_SECTION='```
├── CLAUDE.md
├── .claude/
│   ├── project-setup.md
│   ├── design-psychology.md
│   ├── ui-standards.md
│   └── ux-process.md
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/ui/
├── lib/
│   ├── utils.ts
│   └── supabase/
│       ├── client.ts
│       └── server.ts
├── supabase/
│   └── config.toml
├── public/
├── .env.example
├── netlify.toml
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```'
elif [ "$USE_NETLIFY" = true ]; then
  STRUCTURE_SECTION='```
├── CLAUDE.md
├── .claude/
│   ├── project-setup.md
│   ├── design-psychology.md
│   ├── ui-standards.md
│   └── ux-process.md
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/ui/
├── lib/
│   └── utils.ts
├── public/
├── .env.example
├── netlify.toml
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```'
else
  STRUCTURE_SECTION='```
├── CLAUDE.md
├── .claude/
│   ├── project-setup.md
│   ├── design-psychology.md
│   ├── ui-standards.md
│   └── ux-process.md
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/ui/
├── lib/
│   └── utils.ts
├── public/
├── .env.example
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```'
fi

cat > README.md << EOF
# $PROJECT_NAME

**Type:** $PROJECT_TYPE_LABEL
**Stack:** $STACK_SUMMARY

---

## Getting started

\`\`\`bash
npm run dev
\`\`\`

Open [http://localhost:3000](http://localhost:3000).

---

## Environment variables

$ENV_SECTION

---

$DEPLOY_SECTION

---

## Repo structure

$STRUCTURE_SECTION

---

## Adding shadcn components

\`\`\`bash
npx shadcn add button
npx shadcn add card dialog select table tabs
\`\`\`

Components land in \`components/ui/\` and inherit your brand tokens automatically.

---

## Applying your brand

**\`app/globals.css\`** — update the HSL values for \`--primary\`, \`--accent\`, \`--radius\`, and any other shadcn tokens.

**\`tailwind.config.ts\`** — update \`fontFamily.sans\` to your chosen typeface. Add the font import to \`layout.tsx\` using \`next/font\`.

Both light (\`:root\`) and dark (\`.dark\`) variants are pre-wired. Update both when changing colours.
EOF

echo -e "${GREEN}✓ README.md updated${RESET}"

# ── Install dependencies ──────────────────────────────────────
echo ""
echo -e "${BLUE}Installing dependencies...${RESET}"
npm install
echo -e "${GREEN}✓ Dependencies installed${RESET}"

# ── Set up .env.local ─────────────────────────────────────────
if [ -f ".env.example" ]; then
  cp .env.example .env.local
  echo -e "${GREEN}✓ .env.local created from .env.example${RESET}"
  if [ "$USE_SUPABASE" = true ]; then
    echo -e "${YELLOW}  ↳ Fill in Supabase keys in .env.local before starting the dev server${RESET}"
  fi
  if [ "$USE_STRAPI" = true ]; then
    echo -e "${YELLOW}  ↳ Fill in STRAPI_API_TOKEN once Strapi is deployed to Render${RESET}"
  fi
fi

# ── Open in VS Code ───────────────────────────────────────────
echo ""
if [ "$VSCODE_AVAILABLE" = true ]; then
  echo -e "${BLUE}Opening in VS Code...${RESET}"
  code .
  echo -e "${GREEN}✓ VS Code opened${RESET}"
  echo ""
  echo -e "${BOLD}Claude Code will load CLAUDE.md automatically.${RESET}"
  echo -e "It will run the project setup routine and check MCP connections."
else
  echo -e "${YELLOW}Open VS Code manually:${RESET}"
  echo -e "  cd \"$(pwd)\" && code ."
fi

# ── Done ──────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║     Project ready!               ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${BOLD}Name:${RESET}    $PROJECT_NAME"
echo -e "  ${BOLD}Type:${RESET}    $PROJECT_TYPE_LABEL"
echo -e "  ${BOLD}Stack:${RESET}   $STACK_SUMMARY"
echo -e "  ${BOLD}GitHub:${RESET}  https://github.com/georgeyiakoumi/$PROJECT_NAME"
echo -e "  ${BOLD}Local:${RESET}   $ACTIVE_DIR/$PROJECT_NAME"
echo ""
if [ "$USE_SUPABASE" = true ]; then
  echo -e "  ${YELLOW}→ Fill in .env.local with your Supabase keys${RESET}"
fi
if [ "$USE_STRAPI" = true ]; then
  echo -e "  ${YELLOW}→ cd strapi && npx create-strapi-app@latest . --quickstart${RESET}"
fi
echo ""
