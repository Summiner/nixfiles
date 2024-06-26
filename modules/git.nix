{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.cookiecutie.git;
in
  with lib; {
    options.cookiecutie.git = {
      enable = mkEnableOption "Enables and configures git";
      name = mkOption rec {
        type = types.str;
        default = "Summiner";
        description = "Username to use with git";
        example = default;
      };
      email = mkOption rec {
        type = types.str;
        default = "summiner13@gmail.com";
        description = "Email to use with git";
        example = default;
      };
    };

    config = mkIf cfg.enable {
      home-manager.users.jamie = {...}: {
        programs.git = {
          enable = true;
          package = pkgs.gitFull;
          lfs.enable = true;
          userEmail = cfg.email;
          userName = cfg.name;
          extraConfig = {
            submodule = {
              recurse = true;
            };
            push = {
              autoSetupRemote = true;
            };
            pull = {
              rebase = true;
              # ff = "only";
            };
            commit = {
              gpgSign = true;
            };
            http = {
              postBuffer = 2097152000;
            };
            https = {
              postBuffer = 2097152000;
            };
            init.defaultBranch = "main";
            # Rewrite unencrypted git://github.com URLs to the encrypted version which isn't deprecated
            ${''url "git@github.com:"''} = {insteadOf = "git://github.com/";};
          };
        };
      };
    };
  }
