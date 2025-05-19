{
  config,
  pkgs,
  lib,
  ...
}:

let
  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd --type d --hidden '^\.git$' ~/Git ~/Work -x dirname | sed "s|^$HOME|~|" | sort | fzf | sed "s|^~|$HOME|")
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    fi

    if [[ -z $TMUX ]]; then
        tmux attach -t $selected_name
    else
        tmux switch-client -t $selected_name
    fi
  '';
in
{
  home.packages = [
    tmux-sessionizer
    pkgs.tmux
  ];

  xdg.configFile."tmux/tmux.conf".source = ../dotfiles/tmux/tmux.conf;
}
