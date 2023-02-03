{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.uri.java;
in
  with lib; {
    options.uri.java = {
      enable = mkEnableOption "Enables and configures Java toolchains";
    };

    config = mkIf cfg.enable {
      home-manager.users.uri = {...}: {
        home.file."jdks/openjdk8".source = pkgs.jdk8;
        home.file."jdks/openjdk11".source = pkgs.jdk11;

        home.packages = with pkgs; [
          jdk
          gradle
          gradle-completion
          maven
        ];
      };
    };
  }
