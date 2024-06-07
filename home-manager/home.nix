{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ychateauvert";
  home.homeDirectory = "/home/ychateauvert";

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.packages = [
    pkgs.age
    pkgs.ansible
    pkgs.ansible-lint
    pkgs.python310Packages.boto3
    pkgs.awscli2
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.k9s
    pkgs.kind
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubeseal
    pkgs.opentofu
    pkgs.ripgrep
    pkgs.sops
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      set -U fish_greetings
      fish_add_path ~/.nix-profile/bin
    '';

    shellAliases = {
      dco = "docker compose";
      pco = "podman-compose";
      k = "kubectl";
      lrel = "php ~/src/logalto-releases-tracker/bin/console";
      j = "just";
    };

    shellAbbrs = {
      dco = "docker compose";
      pco = "podman-compose";
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
      ksvg1x = {
        description = "Generate Freerice 1x png";
        body = ''
          ksvgtopng5 85 86 "$(pwd)/$argv[1]" "$(pwd)/$(basename -s .svg $argv[1])@1x.png"
          echo "Generated: $(basename -s .svg $argv[1])@1x.png"
        '';
      };
      ksvg2x = {
        description = "Generate Freerice 2x png";
        body = ''
          ksvgtopng5 170 171 "$(pwd)/$argv[1]" "$(pwd)/$(basename -s .svg $argv[1])@2x.png"
          echo "Generated: $(basename -s .svg $argv[1])@2x.png"
        '';
      };
      ksvg4x = {
        description = "Generate Freerice 4x png";
        body = ''
          ksvgtopng5 340 341 "$(pwd)/$argv[1]" "$(pwd)/$(basename -s .svg $argv[1])@4x.png"
          echo "Generated: $(basename -s .svg $argv[1])@4x.png"
        '';
      };
      freerice-svg = {
        description = "Generate Freerice pngs";
        body = ''
          ksvg1x "$argv[1]"
          ksvg2x "$argv[1]"
          ksvg4x "$argv[1]"
        '';
      };
    };

    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.1.1";
          hash = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }

      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env;
      }
    ];

    interactiveShellInit = ''
      set --global --export ANSIBLE_VAULT_IDENTITY_LIST "~/src/logalto-servers/.vault,comet@~/src/comet-galaxy/.vault,sygestran@~/src/sygestran/.vault"
      set --global --export DIGITALOCEAN_TOKEN $(cat ~/.digitalocean_token)
      set --global --export EDITOR vim
      set --global --export TFENV_CONFIG_DIR ~/.config/tfenv

      set --universal tide_right_prompt_items status cmd_duration context jobs node rustc docker php go kubectl terraform aws time
      set --universal tide_jobs_number_threshold 2

      eval $(doctl completion fish)
    '';

  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
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

      # Temporary swap files directory
      directory = ["~/.vim/swap"];

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

  programs.k9s = {
    enable = true;
  };

  programs.taskwarrior = {
    enable = true;

    package = pkgs.taskwarrior3;

    config = {
      uda.issue.type = "string";
      uda.issue.label = "Issue";

      report.ls.columns = [ "id" "start.active" "depends.indicator" "project" "tags" "recur.indicator" "wait.remaining" "scheduled.countdown" "due.countdown" "until.countdown" "description.count" "issue" ];
      report.ls.labels = [ "ID" "A" "D" "Project" "Tags" "R" "Wait" "S" "Due" "Until" "Description"  "Issue" ];

      report.next.columns = [ "id" "start.age" "entry.age" "depends" "priority" "project" "tags" "recur" "scheduled.countdown" "due.relative" "until.remaining" "description" "urgency" "issue" ];
      report.next.labels = ["ID" "Active" "Age" "Deps" "P" "Project" "Tag" "Recur" "S" "Due" "Until" "Description" "Urg" "Issue" ];

      urgency.user.project.wfp.coefficient = 2;
      urgency.user.project.freerice.coefficient = 1;
    };
  };
}
