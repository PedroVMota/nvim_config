#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# NewEraNeovim - Neovim Installer
# Fetches and installs the latest stable Neovim release with dependencies.
# ============================================================================

NVIM_INSTALL_DIR="/usr/local"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# -- Colors ------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }

# -- OS Detection ------------------------------------------------------------
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PKG_MANAGER="brew"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
      ubuntu|debian|linuxmint|pop) OS="debian";  PKG_MANAGER="apt"    ;;
      fedora|rhel|centos|rocky|alma) OS="fedora"; PKG_MANAGER="dnf"   ;;
      arch|manjaro|endeavouros)    OS="arch";     PKG_MANAGER="pacman" ;;
      opensuse*|sles)              OS="suse";     PKG_MANAGER="zypper" ;;
      alpine)                      OS="alpine";   PKG_MANAGER="apk"   ;;
      *)                           OS="unknown";  PKG_MANAGER=""       ;;
    esac
  else
    OS="unknown"
    PKG_MANAGER=""
  fi
}

# -- Sudo Check --------------------------------------------------------------
SUDO=""

check_sudo() {
  if [[ "$EUID" -eq 0 ]]; then
    info "Running as root."
    return
  fi

  echo ""
  echo -e "${BOLD}This script needs sudo to install packages and Neovim system-wide.${NC}"
  read -rp "Do you have sudo access? [Y/n] " answer
  answer="${answer:-Y}"

  if [[ "$answer" =~ ^[Yy]$ ]]; then
    if command -v sudo &>/dev/null; then
      sudo -v 2>/dev/null
      if [[ $? -eq 0 ]]; then
        SUDO="sudo"
        success "Sudo access confirmed."
      else
        error "Sudo authentication failed."
        exit 1
      fi
    else
      error "'sudo' command not found. Please install sudo or run as root."
      exit 1
    fi
  else
    error "Sudo is required to install dependencies and Neovim."
    exit 1
  fi
}

# -- Install Dependencies ----------------------------------------------------
install_deps() {
  info "Installing dependencies..."

  case "$PKG_MANAGER" in
    apt)
      $SUDO apt-get update -qq
      $SUDO apt-get install -y -qq \
        git curl wget unzip tar gzip \
        build-essential cmake gettext \
        ripgrep fd-find nodejs npm
      ;;
    dnf)
      $SUDO dnf install -y -q \
        git curl wget unzip tar gzip \
        gcc gcc-c++ make cmake gettext \
        ripgrep fd-find nodejs npm
      ;;
    pacman)
      $SUDO pacman -Syu --noconfirm --needed \
        git curl wget unzip tar gzip \
        base-devel cmake gettext \
        ripgrep fd nodejs npm
      ;;
    zypper)
      $SUDO zypper install -y \
        git curl wget unzip tar gzip \
        gcc gcc-c++ make cmake gettext-tools \
        ripgrep fd nodejs npm
      ;;
    apk)
      $SUDO apk add --no-cache \
        git curl wget unzip tar gzip \
        build-base cmake gettext-dev \
        ripgrep fd nodejs npm
      ;;
    brew)
      brew install git curl wget unzip \
        cmake gettext ripgrep fd node
      ;;
    *)
      warn "Unknown package manager. Please install manually:"
      warn "  git, curl, cmake, ripgrep, fd, node, npm"
      read -rp "Continue anyway? [y/N] " cont
      if [[ ! "$cont" =~ ^[Yy]$ ]]; then
        exit 1
      fi
      ;;
  esac

  success "Dependencies installed."
}

# -- Fetch Latest Neovim Version ---------------------------------------------
get_latest_version() {
  info "Fetching latest Neovim release..."
  LATEST_VERSION=$(curl -sL "https://api.github.com/repos/neovim/neovim/releases/latest" \
    | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')

  if [[ -z "$LATEST_VERSION" ]]; then
    error "Could not fetch latest Neovim version from GitHub."
    exit 1
  fi

  success "Latest version: ${BOLD}${LATEST_VERSION}${NC}"
}

# -- Check Current Version ---------------------------------------------------
check_current_version() {
  if command -v nvim &>/dev/null; then
    CURRENT_VERSION="v$(nvim --version | head -1 | sed -E 's/NVIM v//')"
    info "Currently installed: ${BOLD}${CURRENT_VERSION}${NC}"

    if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
      success "Neovim is already up to date (${LATEST_VERSION})."
      read -rp "Reinstall anyway? [y/N] " reinstall
      if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
        setup_config
        echo ""
        success "Done! Nothing to install."
        exit 0
      fi
    fi
  else
    info "Neovim is not currently installed."
  fi
}

# -- Install Neovim ----------------------------------------------------------
install_neovim() {
  local arch
  arch="$(uname -m)"

  # Determine download URL based on OS and architecture
  case "$OS" in
    macos)
      if [[ "$arch" == "arm64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${LATEST_VERSION}/nvim-macos-arm64.tar.gz"
      else
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${LATEST_VERSION}/nvim-macos-x86_64.tar.gz"
      fi
      ;;
    *)
      if [[ "$arch" == "x86_64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${LATEST_VERSION}/nvim-linux-x86_64.tar.gz"
      elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${LATEST_VERSION}/nvim-linux-arm64.tar.gz"
      else
        warn "No prebuilt binary for ${arch}. Building from source..."
        install_neovim_from_source
        return
      fi
      ;;
  esac

  info "Downloading Neovim ${LATEST_VERSION} for ${OS}/${arch}..."
  curl -Lo "${TMP_DIR}/nvim.tar.gz" "$DOWNLOAD_URL"

  info "Installing to ${NVIM_INSTALL_DIR}..."
  tar -xzf "${TMP_DIR}/nvim.tar.gz" -C "$TMP_DIR"

  # The extracted folder name varies
  local extracted_dir
  extracted_dir=$(find "$TMP_DIR" -maxdepth 1 -type d -name "nvim-*" | head -1)

  if [[ -z "$extracted_dir" ]]; then
    error "Failed to extract Neovim archive."
    exit 1
  fi

  # Remove old installation if present
  $SUDO rm -rf "${NVIM_INSTALL_DIR}/share/nvim"
  $SUDO rm -f "${NVIM_INSTALL_DIR}/bin/nvim"

  $SUDO cp -r "${extracted_dir}/"* "${NVIM_INSTALL_DIR}/"

  success "Neovim ${LATEST_VERSION} installed to ${NVIM_INSTALL_DIR}/bin/nvim"
}

install_neovim_from_source() {
  info "Cloning Neovim ${LATEST_VERSION} source..."
  git clone --depth 1 --branch "${LATEST_VERSION}" \
    https://github.com/neovim/neovim.git "${TMP_DIR}/neovim-src"

  cd "${TMP_DIR}/neovim-src"
  info "Building Neovim (this may take a few minutes)..."
  make CMAKE_BUILD_TYPE=Release -j"$(nproc 2>/dev/null || echo 2)"
  $SUDO make install
  cd - >/dev/null

  success "Neovim ${LATEST_VERSION} built and installed."
}

# -- Setup Config -------------------------------------------------------------
setup_config() {
  if [[ -d "$CONFIG_DIR" ]]; then
    if [[ -L "$CONFIG_DIR" ]]; then
      local target
      target="$(readlink -f "$CONFIG_DIR")"
      if [[ "$target" == "$SCRIPT_DIR" ]]; then
        success "Config already linked to this repository."
        return
      fi
    fi

    warn "Existing Neovim config found at ${CONFIG_DIR}"
    echo "  1) Backup and replace with NewEraNeovim"
    echo "  2) Skip (keep current config)"
    read -rp "Choose [1/2]: " choice

    case "$choice" in
      1)
        BACKUP_DIR="${CONFIG_DIR}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$CONFIG_DIR" "$BACKUP_DIR"
        info "Backed up to ${BACKUP_DIR}"
        ;;
      *)
        info "Keeping existing config."
        return
        ;;
    esac
  fi

  ln -sf "$SCRIPT_DIR" "$CONFIG_DIR"
  success "Linked ${SCRIPT_DIR} -> ${CONFIG_DIR}"
}

# -- Verify Installation ------------------------------------------------------
verify_install() {
  echo ""
  if command -v nvim &>/dev/null; then
    local installed_version
    installed_version="$(nvim --version | head -1)"
    success "Installation verified: ${BOLD}${installed_version}${NC}"
  else
    warn "nvim not found in PATH. You may need to add ${NVIM_INSTALL_DIR}/bin to your PATH:"
    echo ""
    echo "  export PATH=\"${NVIM_INSTALL_DIR}/bin:\$PATH\""
    echo ""
  fi
}

# -- Main ---------------------------------------------------------------------
main() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}   NewEraNeovim Installer${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""

  detect_os
  info "Detected OS: ${BOLD}${OS}${NC} (${PKG_MANAGER})"

  check_sudo
  get_latest_version
  check_current_version

  echo ""
  echo -e "${BOLD}This will:${NC}"
  echo "  1. Install dependencies (git, ripgrep, fd, node, etc.)"
  echo "  2. Download and install Neovim ${LATEST_VERSION}"
  echo "  3. Link this config to ~/.config/nvim"
  echo ""
  read -rp "Proceed? [Y/n] " proceed
  proceed="${proceed:-Y}"

  if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
  fi

  install_deps
  install_neovim
  setup_config
  verify_install

  echo ""
  success "All done! Run ${BOLD}nvim${NC} to start."
  echo ""
}

main "$@"
