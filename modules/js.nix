{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.uri.javascript;
in
  with lib; {
    options.uri.javascript = {
      enable = mkEnableOption "Enables and configures Javascript toolchains";
    };

    config = mkIf cfg.enable {
      home-manager.users.jamie = {...}: {
        home.packages = with pkgs; [
          deno
          nodejs
          node2nix
          yarn2nix
        ];
      };
    };
  }
