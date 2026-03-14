{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Flutter configuration
  android.flutter.enable = true;

  # Bun backend configuration
  languages.javascript = {
    enable = true;
    bun = {
      enable = true;
      # install.enable = true;
    };
  };

  # SQLite package
  packages = [
    pkgs.sqlite-interactive
  ];

  # See full reference at https://devenv.sh/reference/options/
}
