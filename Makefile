# ==============================================================================
# 🧰 Makefile – Hantera dina verktyg & inställningar
#
# 📦 Du definierar vilka appar/verktyg som ska finnas i flake.nix
#
# Vanliga scenarion:
#   make init            – Första setup på ny dator
#   make apply-changes   – När du ändrat vilka appar som ska ingå
#   make upgrade         – Uppdatera alla appar till senaste versioner
#   make refresh         – Installera om och återlänka allt
#   make reset           – Rensa bort ALLT (verktyg och länkar)
# ==============================================================================

FLAKE_PATH := ./nix-flakes/profile
RESULT_PATH := $(FLAKE_PATH)/result
TARGET := ~/.config
STOW := stow

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo ""
	@echo "🧰 Tillgängliga kommandon:"
	@echo ""
	@echo "  make init            – 🔧 Sätt upp allt första gången (dotfiles + appar)"
	@echo "  make apply-changes   – 🪄 När du lagt till / tagit bort appar i flake.nix"
	@echo "  make upgrade         – 🔄 Hämta senaste versioner av alla appar"
	@echo "  make refresh         – ♻️  Återställ allt (länkar + installation)"
	@echo "  make reset           – 🧹 Rensa bort ALLT (länkar, appar och cache)"
	@echo ""

.PHONY: init
init: link install

.PHONY: apply-changes
apply-changes:
	@echo "📦 Bygger ny uppsättning appar enligt flake.nix..."
	nix build $(FLAKE_PATH) --out-link $(RESULT_PATH)
	@echo "📥 Installerar om allt från ändrad flake..."
	nix profile install $(RESULT_PATH)

.PHONY: upgrade
upgrade:
	@echo "🔄 Uppdaterar till senaste versioner av verktyg..."
	nix flake update --flake $(FLAKE_PATH)
	$(MAKE) apply-changes

.PHONY: refresh
refresh: unlink link apply-changes

.PHONY: reset
reset: unlink
	@echo "🧹 Rensar installerade appar och gammal cache..."
	nix profile remove profile-env || true
	nix-collect-garbage -d
	@rm -rf $(RESULT_PATH)

.PHONY: link
link:
	@echo "🔗 Skapar symlänkar till ~/.config..."
	$(STOW) -v --restow --target $(TARGET) .

.PHONY: unlink
unlink:
	@echo "❌ Tar bort symlänkar från ~/.config..."
	$(STOW) -v --delete --target $(TARGET) .
