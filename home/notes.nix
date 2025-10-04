{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.notesDirectory = lib.mkOption {
    type = lib.types.str;
    default = "$HOME/Notes";
    description = "Directory where notes are stored";
  };

  config.home.packages = [
    (pkgs.writeShellScriptBin "take-notes" (
      builtins.replaceStrings [ "@NOTES_DIR@" ] [ config.notesDirectory ] (
        builtins.readFile ../scripts/notes.sh
      )
    ))
  ];
}
