{ config, lib, pkgs, ... }:

with lib;

{
  options.tofu.dev.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Dev Tooling";
  };

  config = mkIf config.tofu.dev.enable {
    programs.git = {
      enable = true;
      userName = "Adrian E";
      userEmail = "adrian@edelen.haus";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "nano";
        push.autoSetupRemote = true;
      };
      aliases = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        lg = "log --oneline --graph --decorate";
      };
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimdiffAlias = true;

      extraConfig = ''
        set number
      '';
    };
  };
}
