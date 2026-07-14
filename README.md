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

Update the Home Manager flake inputs:

```bash
cd ~/.config/home-manager
nix flake update
home-manager switch --flake ~/.config/home-manager#ychateauvert
```

To update a single input instead of all inputs, pass the input name:

```bash
cd ~/.config/home-manager
nix flake update nixpkgs
home-manager switch --flake ~/.config/home-manager#ychateauvert
```
