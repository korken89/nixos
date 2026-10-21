{
  pkgs,
  lib,
  ...
}:
let
  # Fuzzy pick an existing workspace or a zoxide directory and attach, sesh style.
  herdr-pick = pkgs.writeShellApplication {
    name = "herdr-pick";
    runtimeInputs = [
      pkgs.herdr
      pkgs.gum
      pkgs.jq
      pkgs.zoxide
      pkgs.util-linux
    ];
    text = ''
      if ! herdr workspace list >/dev/null 2>&1; then
        setsid -f herdr server >/dev/null 2>&1
        for _ in $(seq 50); do
          herdr workspace list >/dev/null 2>&1 && break
          sleep 0.1
        done
      fi

      workspaces=$(herdr workspace list | jq -r '.result.workspaces[] | "\(.workspace_id)\t\(.label)"')

      # Same icons and colors as `sesh list -i`
      ws_icon=$'\e[34m\ue62e\e[39m'
      dir_icon=$'\e[36m\uf114\e[39m'

      choice=$(
        {
          cut -f2 <<<"$workspaces" | sed "s|^|$ws_icon |"
          zoxide query -l | sed -e "s|^$HOME|~|" -e "s|^|$dir_icon |"
        } | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a workspace' --height 50 --no-strip-ansi
      ) || exit 0

      icon=''${choice%% *}
      name=''${choice#* }

      if [[ $icon == *$'\ue62e'* ]]; then
        id=$(awk -F'\t' -v l="$name" '$2 == l { print $1; exit }' <<<"$workspaces")
        herdr workspace focus "$id" >/dev/null
      else
        herdr workspace create --cwd "''${name/#\~/$HOME}" --label "$name" --focus >/dev/null
      fi

      if [ -z "''${HERDR_PANE_ID:-}" ]; then
        exec herdr
      fi
    '';
  };

  herdr-urls = pkgs.writeShellApplication {
    name = "herdr-urls";
    runtimeInputs = [
      pkgs.herdr
      pkgs.gum
      pkgs.xdg-utils
    ];
    text = ''
      if ! urls=$(
        herdr pane read "$HERDR_ACTIVE_PANE_ID" --source recent-unwrapped --lines 2000 \
          | grep -Eo '(http|https)://[a-zA-Z0-9./?=_%:+&~@-]*' \
          | tac \
          | awk '!seen[$0]++'
      ); then
        echo "No URLs found"
        read -rsn1 -t 1 || true
        exit 0
      fi

      url=$(gum filter --height 50 <<<"$urls") || exit 0
      xdg-open "$url"
    '';
  };
in
{
  home.packages = [
    pkgs.herdr
    herdr-pick
    herdr-urls
  ];

  xdg.configFile."fish/config.fish".text = lib.mkBefore ''
    bind \cf 'herdr-pick; commandline -f repaint'
  '';

  xdg.configFile."herdr/config.toml".source = (pkgs.formats.toml { }).generate "herdr-config.toml" {
    onboarding = false;

    theme = {
      name = "one-dark";
      auto_switch = false;
    };

    # Managed by nix
    update = {
      version_check = false;
      manifest_check = false;
    };

    keys = {
      prefix = "ctrl+a";
      switch_tab = "alt+1..9";

      # Navigate mode (prefix+w): j/k between workspaces, shift for panes
      navigate_workspace_up = [
        "k"
        "up"
      ];
      navigate_workspace_down = [
        "j"
        "down"
      ];
      navigate_pane_up = "shift+k";
      navigate_pane_down = "shift+j";

      command = [
        {
          key = "prefix+ctrl+u";
          type = "popup";
          command = "herdr-urls";
          width = "50%";
          height = "50%";
        }
      ];
    };

    ui = {
      confirm_close = false;
      prompt_new_tab_name = false;
      status_indicators = "symbols";
      sound.enabled = false;
      toast.delivery = "terminal";
    };
  };
}
