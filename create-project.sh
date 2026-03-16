#!/bin/bash

# ─────────────────────────────────────────────────────────────
# create-project.sh
# Creates a new project repo from George's design template,
# clones it locally, installs dependencies, and opens VS Code.
#
# Prerequisites:
#   - GitHub CLI installed and authenticated (gh auth login)
#   - Node.js 18+ installed
#   - VS Code CLI installed (code command available)
#   - T7 Editing external drive mounted
#
# Usage:
#   chmod +x create-project.sh
#   ./create-project.sh
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
RESET='\033[0m'

echo ""
echo -e "${BOLD}╔══════════════════════════════════╗${RESET}"
echo -e "${BOLD}║     New Project Setup            ║${RESET}"
echo -e "${BOLD}╚══════════════════════════════════╝${RESET}"
echo ""

# ── Check prerequisites ───────────────────────────────────────
echo -e "${BLUE}Checking prerequisites...${RESET}"

if ! command -v gh &> /dev/null; then
  echo -e "${RED}✗ GitHub CLI (gh) not found. Install it: https://cli.github.com${RESET}"
  exit 1
fi

if ! command -v node &> /dev/null; then
  echo -e "${RED}✗ Node.js not found. Install it: https://nodejs.org${RESET}"
  exit 1
fi

if ! command -v code &> /dev/null; then
  echo -e "${YELLOW}⚠ VS Code CLI (code) not found — you'll need to open the project manually.${RESET}"
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
  echo -e "  Connect the drive before running this script to use your preferred location."
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
read -p "$(echo -e ${BOLD})Project name (kebab-case, e.g. client-dashboard): $(echo -e ${RESET})" PROJECT_NAME

if [[ -z "$PROJECT_NAME" ]]; then
  echo -e "${RED}✗ Project name cannot be empty.${RESET}"
  exit 1
fi

if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9-]+$ ]]; then
  echo -e "${RED}✗ Use lowercase letters, numbers, and hyphens only.${RESET}"
  exit 1
fi

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
echo -e "${BOLD}Creating:${RESET}"
echo -e "  Repo:       ${GREEN}$PROJECT_NAME${RESET} (${VISIBILITY})"
echo -e "  Template:   ${BLUE}$TEMPLATE_REPO${RESET}"
echo -e "  Local path: ${BLUE}$ACTIVE_DIR/$PROJECT_NAME${RESET}"
echo ""
read -p "Continue? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

# ── Move to projects dir and create repo ──────────────────────
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

# ── Move into project ─────────────────────────────────────────
cd "$PROJECT_NAME" 2>/dev/null || { echo -e "${RED}✗ Could not find cloned directory.${RESET}"; exit 1; }

# ── Install dependencies ──────────────────────────────────────
echo ""
echo -e "${BLUE}Installing dependencies...${RESET}"
npm install
echo -e "${GREEN}✓ Dependencies installed${RESET}"

# ── Set up .env.local ─────────────────────────────────────────
if [ -f ".env.example" ]; then
  cp .env.example .env.local
  echo -e "${GREEN}✓ .env.local created from .env.example${RESET}"
  echo -e "${YELLOW}  ↳ Fill in your Supabase keys in .env.local before running the dev server${RESET}"
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
  echo -e "  cd $(pwd)"
  echo -e "  code ."
fi

echo ""
echo -e "${GREEN}${BOLD}All done! Project ready: $PROJECT_NAME${RESET}"
echo -e "${BLUE}Location: $ACTIVE_DIR/$PROJECT_NAME${RESET}"
echo ""
