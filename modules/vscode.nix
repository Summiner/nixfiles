{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.uri.vscode;
in
  with lib; {
    options.uri.vscode = {
      enable = mkEnableOption "Enables and configures vscode";
    };

    config = mkIf cfg.enable {
      home-manager.users.uri = {...}: {
        programs.vscode = {
          enable = true;
          package = pkgs.vscodium;
          extensions = with pkgs.vscode-extensions;
            [
              matklad.rust-analyzer
              tamasfe.even-better-toml
              jnoortheen.nix-ide
              kamadorueda.alejandra
              dbaeumer.vscode-eslint
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "vscode-fluent";
                publisher = "macabeus";
                version = "1.0.0";
                sha256 = "814e374452e9e9e99896893ad1c1de2dae2486285a668f985c66ef25eb08a9f2";
              }
            ];
        };
      };
    };
  }
