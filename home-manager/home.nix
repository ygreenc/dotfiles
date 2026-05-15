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
    pkgs.python312Packages.boto3
    pkgs.bat
    pkgs.fx
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
    pkgs.rage
    pkgs.ripgrep
    pkgs.sops
    pkgs.tdrop
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
      k = "kubectl";
      j = "just";
      ls = "eza --hyperlink";
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
          rev = "v6.2.0";
          hash = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
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

      # Support mouse events
      set -g mouse on
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
      news.version = 99999;

      uda.issue.type = "string";
      uda.issue.label = "Issue";

      uda.notion.type = "string";
      uda.notion.label = "Notion";

      report.ls.columns = [ "id" "start.active" "depends.indicator" "project" "tags" "recur.indicator" "wait.remaining" "scheduled.countdown" "due.countdown" "until.countdown" "description.count" "issue" "notion" ];
      report.ls.labels = [ "ID" "A" "D" "Project" "Tags" "R" "Wait" "S" "Due" "Until" "Description"  "Issue" "Notion"];

      report.next.columns = [ "id" "start.age" "entry.age" "depends" "priority" "project" "tags" "recur" "scheduled.countdown" "due.relative" "until.remaining" "description" "urgency" "issue" "notion"];
      report.next.labels = ["ID" "Active" "Age" "Deps" "P" "Project" "Tag" "Recur" "S" "Due" "Until" "Description" "Urg" "Issue" "Notion"];
      report.next.filte = "status:pending -WAITING -BLOCKED limit:page";

      urgency.user.project.wfp.coefficient = 2;
      urgency.user.project.freerice.coefficient = 1;
    };
  };

  programs.awscli = {
    enable = true;

    package = pkgs.awscli2.overridePythonAttrs (old: {
      doCheck = false;
      dontCheck = true;
      checkPhase = "true";
    });

    settings = {
      "default" = {
        "region" = "eu-west-1";
        "signature_version" = "s3v4";
      };

      "profile devalto" = {
        "region" = "us-east-1";
      };

      "profile wfp-ci" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "878230841112";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "eu-west-1";
      };

      "profile wfp-dev" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "521231022227";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "eu-west-1";
      };

      "profile wfp-qa" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "033102915094";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "eu-west-1";
      };

      "profile wfp-prod" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "207251198262";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "us-east-1";
      };

      "profile freerice" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "564635962753";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "us-east-1";
      };

      "profile comet" = {
        "sso_start_url" = "https://wfp.awsapps.com/start#/";
        "sso_region" = "eu-west-1";
        "sso_account_id" = "184517591100";
        "sso_role_name" = "LocalApplicationAdministrator";
        "region" = "eu-west-1";
      };
    };
  };

  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.numbat.enable = true;
  programs.visidata.enable = true;
  programs.helix.enable = true;

  programs.emacs = {
    enable = true;

    package = pkgs.emacs;

    extraPackages = epkgs: with epkgs; [
      evil
      evil-collection
      general

      which-key
      vertico
      orderless
      marginalia
      consult
      embark
      embark-consult

      magit
      direnv
      markdown-mode
      nix-mode
    ];
  };

  services.emacs.enable = true;

  xdg.configFile."emacs/early-init.el".text = ''
    ;; Home Manager/Nix provides packages, so don't auto-load package.el.
    (setq package-enable-at-startup nil)
  '';

  xdg.configFile."emacs/init.el".text = ''
    (setq inhibit-startup-screen t
          ring-bell-function 'ignore
          use-package-always-ensure nil
          custom-file (locate-user-emacs-file "custom.el"))

    (load custom-file 'noerror 'nomessage)
    (require 'use-package)

    ;; Vim layer
    (use-package evil
      :init
      (setq evil-want-keybinding nil
            evil-want-C-u-scroll t
            evil-want-C-i-jump nil)
      :config
      (evil-mode 1))

    (use-package evil-collection
      :after evil
      :config
      (evil-collection-init))

    ;; SPC leader, Vim-style
    (use-package general
      :after evil
      :config
      (general-create-definer my/leader
        :states '(normal visual motion)
        :keymaps 'override
        :prefix "SPC")

      (my/leader
        "f f" '(find-file :which-key "find file")
        "b b" '(consult-buffer :which-key "switch buffer")
	"s g" '(consult-ripgrep :which-key "search recursively")
        "g g" '(magit-status :which-key "git")
        "p p" '(project-switch-project :which-key "project")
        "h k" '(describe-key :which-key "describe key")
        "h f" '(describe-function :which-key "describe function")
        "h v" '(describe-variable :which-key "describe variable")))

    ;; Discoverability
    (use-package which-key
      :config
      (which-key-mode 1))

    ;; Better minibuffer/completion
    (use-package vertico
      :config
      (vertico-mode 1))

    (use-package orderless
      :custom
      (completion-styles '(orderless basic)))

    (use-package marginalia
      :config
      (marginalia-mode 1))

    (use-package consult
      :commands
      (consult-line
       consult-buffer
       consult-goto-line
       consult-ripgrep
       consult-find
       consult-grep
       consult-git-grep)
       
      :bind (("C-s" . consult-line)
             ("C-x b" . consult-buffer)
             ("M-g g" . consult-goto-line)))

    ;; Git
    (use-package magit
      :bind (("C-x g" . magit-status)))

    ;; direnv integration
    (use-package direnv
      :config
      (direnv-mode 1))

    (use-package markdown-mode
      :commands (markdown-mode gfm-mode)
      :mode
      (("\\.md\\'" . gfm-mode)
       ("README\\.md\\'" . gfm-mode)
       ("\\.markdown\\'" . markdown-mode)))
  '';
}
