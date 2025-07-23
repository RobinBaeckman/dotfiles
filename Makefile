# =============================================================================
# 💡 Makefile – Enkelt gränssnitt för att hantera dotfiles och Nix-miljö
#
# Detta är din kommandopanel – kör "make help" för att se vad du kan göra.
#
# 🟢 Vanlig uppdatering efter lång paus:
#    make update
#
# 🛠️ Ny dator / fresh setup:
#    make full-setup
# =============================================================================

# === 🔧 Variabler ===
FLAKE_PATH := ./nix-flakes/profile
RESULT_PATH := $(FLAKE_PATH)/result
STOW := stow
STOWRC := .stowrc

# === 🧭 Standardkommandot ===
.DEFAULT_GOAL := help

# === 📋 Hjälpmeny ===
.PHONY: help
help:
	@echo "📦 Available targets:"
	@echo "  make full-setup           - 🛠️ Första setup på ny dator (Nix + dotfiles)"
	@echo "  make update               - 🔄 Uppdatera alla verktyg (flake update + install)"
	@echo "  make link-dotfiles        - 🔗 Symlänka dotfiles till ~/.config"
	@echo "  make unlink-dotfiles      - ❌ Ta bort symlänkar"
	@echo "  make nix-profile-install  - 📥 Bygg och installera Nix-paket från flake"

# === 🛠️ Full ny setup (för ny dator) ===
.PHONY: full-setup
full-setup: link-dotfiles nix-profile-install

# === 🔗 Symlänka dotfiles ===
.PHONY: link-dotfiles
link-dotfiles:
	@echo "🔗 Symlänkar dotfiles till ~/.config ..."
	$(STOW) -v --restow --target ~/.config .

# === ❌ Ta bort symlänkar ===
.PHONY: unlink-dotfiles
unlink-dotfiles:
	@echo "❌ Tar bort symlänkar från ~/.config ..."
	$(STOW) -v --delete --target ~/.config .

# === 📥 Bygg och installera Nix-profile från flake ===
.PHONY: nix-profile-install
nix-profile-install:
	@echo "🔨 Bygger flake..."
	nix build $(FLAKE_PATH) --out-link $(RESULT_PATH)
	@echo "🧹 Tar bort gammal profil (om finns)..."
	nix profile remove profile-env || true
	@echo "🗑️  Rensar gammal garbage..."
	nix-collect-garbage -d
	@echo "📦 Installerar ny profil..."
	nix profile install $(RESULT_PATH)

# === 🔄 Uppdatera flake + installera senaste paket ===
.PHONY: update
update:
	@echo "🔄 Kör nix flake update..."
	nix flake update --flake $(FLAKE_PATH)
	@echo "📥 Installerar uppdaterad profil..."
	$(MAKE) nix-profile-install
