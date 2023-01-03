{ config, pkgs, ... }:

let 
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./doom;  # Directory containing your config.el init.el
                                      # and packages.el files
};

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ygreenc";
  home.homeDirectory = "/home/ygreenc";

  home.packages = [
    pkgs.ansible
    pkgs.ansible-lint
    pkgs.awscli2
    doom-emacs
    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.fzf
    pkgs.htop
    pkgs.jq
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubeseal
    pkgs.ripgrep
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      set -U fish_greetings
    '';

    shellAliases = {
      dco = "docker compose";
      k = "kubectl";
    };

    shellAbbrs = {
      dco = "docker compose";
      k = "kubectl";
    };

    functions = { 
      faws = {
        description = "Choose AWS profile from list";
        body = "set --global --export AWS_PROFILE $(aws configure list-profiles | fzf +m)";
      };
      fcode = {
        body = "cd \"$HOME/src/$(fd --type directory --max-depth 1 --strip-cwd-prefix --base-directory $HOME/src . | fzf +m)\"";
        description = "Choose project directory to cd to";
      };
      git-remove-untracked = {
        description = "Remove branches deleted remotely";
        body = "git fetch --prune && git branch -v | grep \"\[gone\" | awk \"{print \$1}\" | xargs git branch -D $argv;";
      };
    };

    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "32e4b8dcf84d618801bd5ce82bc9e95b917c3935";
          sha256 = "14bdvrnd1v8ffac6fmpfs2cy4q19a4w02yrkc2xjiyqhj9lazgzy";
        };
      }
    ];

    interactiveShellInit = ''
      set --global --export ANSIBLE_VAULT_IDENTITY_LIST "~/src/logalto-servers/.vault,comet@~/src/comet-galaxy/.vault,sygestran@~/src/sygestran/.vault"
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";

    extraConfig =''
      set -ga terminal-overrides ",*256col*:Tc"

      # Set scrollback limit
      set -g history-limit 30000

      # Set Prefix to Ctrl + a
      unbind C-b
      set-option -g prefix C-a

      # Set windows numbering start at 1
      set -g base-index 1
      set -g pane-base-index 1

      # Update Client terminal titles
      set -g set-titles on

      # Shorten command delay
      set -sg escape-time 1

      # Set Tmux term to 256 colors
      set -g default-terminal "screen-256color"

      # Styles
      set -g status-bg colour243
      set -g status-fg colour16

      # Set vi keybindings
      set -g mode-keys vi

      # Some keybindings
      # Go back to last-window
      bind C-a last-window
      # Kill pane
      bind k kill-pane
      # Split horizontally
      bind | split-window -h
      # Split vertically
      bind - split-window
    '';
  };

  programs.vim = {
    enable = true;

    settings = {
      background = "dark";
      
      # Tabs are spaces, No thank you tabs
      expandtab = true;

      # Increase history size
      history = 2000;

      # Enable buffer switch without saving
      hidden = true;
      # Default search is case-insensitive
      ignorecase = true;

      # Line numbering
      number = true;

      # When uppercase detected, search case-sensitive
      smartcase = true;

      # Temporary files directory
      backupdir = ["~/.vim/backup"];

      # Undo
      undodir = ["~/.vim/undo"];
      undofile = true;

      # Use 4-spaces indent
      shiftwidth = 4;

      # Indentation is 4 columns
      tabstop = 4;
    };

    extraConfig = ''
      " Leader key
      let mapleader = ','

      " Undotree
      let g:undotree_SetFocusWhenToggle=1
      nnoremap <Leader>u :UndotreeToggle<CR>
    '';

    plugins = with pkgs; [
      vimPlugins.fzf-vim
      vimPlugins.nerdcommenter
      vimPlugins.undotree
      vimPlugins.vim-easymotion
      vimPlugins.vim-surround
    ];
  };
}
