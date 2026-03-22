#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# NewEraNeovim - Uninstaller
# Removes Neovim and the NewEraNeovim configuration.
# ============================================================================

NVIM_INSTALL_DIR="/usr/local"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

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

# -- Sudo Check --------------------------------------------------------------
SUDO=""

check_sudo() {
  if [[ "$EUID" -eq 0 ]]; then
    return
  fi

  if command -v sudo &>/dev/null; then
    sudo -v 2>/dev/null
    if [[ $? -eq 0 ]]; then
      SUDO="sudo"
    else
      warn "Sudo authentication failed. System-wide Neovim removal may fail."
    fi
  else
    warn "'sudo' not found. System-wide Neovim removal may fail."
  fi
}

# -- Detect how Neovim was installed -----------------------------------------
detect_install_method() {
  if [[ -f "${NVIM_INSTALL_DIR}/bin/nvim" ]]; then
    INSTALL_METHOD="manual"
  elif command -v nvim &>/dev/null; then
    local nvim_path
    nvim_path="$(command -v nvim)"
    if [[ "$nvim_path" == "/usr/bin/nvim" ]]; then
      INSTALL_METHOD="package_manager"
    elif [[ "$nvim_path" == *"homebrew"* || "$nvim_path" == *"linuxbrew"* ]]; then
      INSTALL_METHOD="brew"
    elif [[ "$nvim_path" == *"snap"* ]]; then
      INSTALL_METHOD="snap"
    elif [[ "$nvim_path" == *"flatpak"* ]]; then
      INSTALL_METHOD="flatpak"
    else
      INSTALL_METHOD="unknown"
    fi
  else
    INSTALL_METHOD="not_installed"
  fi
}

# -- Remove Neovim binary ----------------------------------------------------
remove_neovim() {
  detect_install_method

  case "$INSTALL_METHOD" in
    not_installed)
      info "Neovim is not installed. Skipping binary removal."
      return
      ;;
    manual)
      info "Removing Neovim from ${NVIM_INSTALL_DIR}..."
      $SUDO rm -f "${NVIM_INSTALL_DIR}/bin/nvim"
      $SUDO rm -rf "${NVIM_INSTALL_DIR}/share/nvim"
      $SUDO rm -rf "${NVIM_INSTALL_DIR}/lib/nvim"
      success "Neovim binary removed."
      ;;
    brew)
      info "Removing Neovim via Homebrew..."
      brew uninstall neovim
      success "Neovim removed via Homebrew."
      ;;
    snap)
      info "Removing Neovim via Snap..."
      $SUDO snap remove nvim
      success "Neovim removed via Snap."
      ;;
    flatpak)
      info "Removing Neovim via Flatpak..."
      flatpak uninstall io.neovim.nvim
      success "Neovim removed via Flatpak."
      ;;
    package_manager)
      info "Neovim was installed via system package manager."
      if command -v apt-get &>/dev/null; then
        $SUDO apt-get remove -y neovim
      elif command -v dnf &>/dev/null; then
        $SUDO dnf remove -y neovim
      elif command -v pacman &>/dev/null; then
        $SUDO pacman -Rns --noconfirm neovim
      elif command -v zypper &>/dev/null; then
        $SUDO zypper remove -y neovim
      elif command -v apk &>/dev/null; then
        $SUDO apk del neovim
      else
        warn "Could not detect package manager. Remove neovim manually."
        return
      fi
      success "Neovim removed via package manager."
      ;;
    *)
      local nvim_path
      nvim_path="$(command -v nvim)"
      warn "Neovim found at ${nvim_path} but install method is unknown."
      read -rp "Attempt to remove ${nvim_path}? [y/N] " answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        $SUDO rm -f "$nvim_path"
        success "Removed ${nvim_path}."
      fi
      ;;
  esac
}

# -- Remove config and data --------------------------------------------------
remove_config() {
  if [[ -e "$CONFIG_DIR" ]]; then
    if [[ -L "$CONFIG_DIR" ]]; then
      info "Removing config symlink: ${CONFIG_DIR}"
      rm -f "$CONFIG_DIR"
    else
      info "Removing config directory: ${CONFIG_DIR}"
      rm -rf "$CONFIG_DIR"
    fi
    success "Config removed."
  else
    info "No config found at ${CONFIG_DIR}."
  fi
}

remove_data() {
  local removed=false

  for dir in "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
    if [[ -d "$dir" ]]; then
      info "Removing ${dir}..."
      rm -rf "$dir"
      removed=true
    fi
  done

  if $removed; then
    success "Data, state, and cache cleared."
  else
    info "No data/cache directories found."
  fi
}

# -- Restore backup -----------------------------------------------------------
restore_backup() {
  local backups
  backups=$(find "$(dirname "$CONFIG_DIR")" -maxdepth 1 -name "nvim.backup.*" -type d 2>/dev/null | sort -r)

  if [[ -z "$backups" ]]; then
    return
  fi

  echo ""
  info "Found previous config backups:"
  local i=1
  local backup_list=()
  while IFS= read -r backup; do
    echo "  ${i}) ${backup}"
    backup_list+=("$backup")
    i=$((i + 1))
  done <<< "$backups"
  echo "  ${i}) Don't restore"

  read -rp "Restore a backup? [1-${i}]: " choice
  choice="${choice:-$i}"

  if [[ "$choice" -ge 1 && "$choice" -lt "$i" ]]; then
    local selected="${backup_list[$((choice - 1))]}"
    mv "$selected" "$CONFIG_DIR"
    success "Restored backup from ${selected}"
  fi
}

# -- Main ---------------------------------------------------------------------
main() {
  echo ""
  echo -e "${BOLD}========================================${NC}"
  echo -e "${BOLD}   NewEraNeovim Uninstaller${NC}"
  echo -e "${BOLD}========================================${NC}"
  echo ""

  detect_install_method

  if [[ "$INSTALL_METHOD" != "not_installed" ]]; then
    local nvim_version
    nvim_version="$(nvim --version 2>/dev/null | head -1 || echo "unknown")"
    info "Found Neovim: ${BOLD}${nvim_version}${NC}"
  fi

  echo ""
  echo -e "${BOLD}What would you like to remove?${NC}"
  echo "  1) Everything (Neovim + config + data)"
  echo "  2) Config and data only (keep Neovim installed)"
  echo "  3) Neovim only (keep config and data)"
  echo "  4) Cancel"
  echo ""
  read -rp "Choose [1-4]: " action
  action="${action:-4}"

  case "$action" in
    1)
      echo ""
      echo -e "${RED}${BOLD}This will remove:${NC}"
      echo "  - Neovim binary"
      echo "  - Config:  ${CONFIG_DIR}"
      echo "  - Data:    ${DATA_DIR}"
      echo "  - State:   ${STATE_DIR}"
      echo "  - Cache:   ${CACHE_DIR}"
      echo ""
      read -rp "Are you sure? [y/N] " confirm
      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted."
        exit 0
      fi
      check_sudo
      remove_neovim
      remove_config
      remove_data
      restore_backup
      ;;
    2)
      echo ""
      read -rp "Remove config and all Neovim data? [y/N] " confirm
      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted."
        exit 0
      fi
      remove_config
      remove_data
      restore_backup
      ;;
    3)
      echo ""
      read -rp "Remove Neovim binary? [y/N] " confirm
      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted."
        exit 0
      fi
      check_sudo
      remove_neovim
      ;;
    *)
      info "Cancelled."
      exit 0
      ;;
  esac

  echo ""
  success "Uninstall complete."
  echo ""
}

main "$@"
