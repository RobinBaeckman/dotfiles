# Define variables for Nix flakes and stow
FLAKE_PATH := ./nix-flakes/profile
RESULT_PATH := $(FLAKE_PATH)/result
STOW := stow
STOW_DIR := $(shell pwd)
STOWRC := .stowrc

# Default target
.DEFAULT_GOAL := help

# Help target for displaying available commands
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make setup               - Set up the environment (link dotfiles and install Nix packages)"
	@echo "  make link-dotfiles       - Link dotfiles to the appropriate locations using stow"
	@echo "  make unlink-dotfiles     - Unlink dotfiles from their locations"
	@echo "  make nix-profile-install - Build the flake and install the Nix profile"
	@echo "  make help                - Display this help message"

# Target for setting up the environment (linking dotfiles and installing Nix packages)
.PHONY: setup
setup: link-dotfiles nix-profile-install

# Target for linking dotfiles with stow
.PHONY: link-dotfiles
link-dotfiles:
	$(STOW) -v --restow --target ~/.config .

# Target for unlinking dotfiles (unstowing)
.PHONY: unlink-dotfiles
unlink-dotfiles:
	$(STOW) -v --delete --target ~/.config .

# Target to build the flake and install the Nix profile
.PHONY: nix-profile-install
nix-profile-install:
	@echo "Building the flake..."
	nix build $(FLAKE_PATH) --out-link $(RESULT_PATH)
	@echo "Removing the existing profile..."
	nix profile remove profile-env || true
	@echo "Running garbage collection..."
	nix-collect-garbage -d
	@echo "Installing the profile..."
	nix profile install $(RESULT_PATH)
