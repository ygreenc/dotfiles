# dotfiles

Install Nix [home-manager](https://github.com/nix-community/home-manager)

Set up the Home Manager flake:

```bash
ln -s ~/.dotfiles/home-manager ~/.config/home-manager
```

Apply the Home Manager configuration:

```bash
home-manager switch --flake ~/.config/home-manager#ychateauvert
```
