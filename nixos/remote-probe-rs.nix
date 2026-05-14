{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "remote-probe-rs" ''
      # Cargo runner: forwards all args to `probe-rs` on a remote host over SSH.
      # Any arg that's a regular local file (typically the ELF Cargo built) is
      # scp'd to the remote and replaced with the remote path; the rest passes
      # through verbatim. PROBE_RS_PROBE is forwarded so a probe selected
      # locally takes effect remotely.
      #
      # Required env: PROBE_RS_REMOTE_HOST  - the rig's hostname (Netbird name works).
      # Optional env: PROBE_RS_PROBE        - VID:PID[:Serial] of the probe to use.
      set -euo pipefail

      HOST="''${PROBE_RS_REMOTE_HOST:?set PROBE_RS_REMOTE_HOST to the rig hostname}"

      ARGS=()
      for arg in "$@"; do
          if [ -f "$arg" ]; then
              REMOTE="/tmp/probe-bin-$(id -un)-$(basename -- "$arg")"
              ${pkgs.openssh}/bin/scp -q "$arg" "$HOST:$REMOTE"
              ARGS+=("$REMOTE")
          else
              ARGS+=("$arg")
          fi
      done

      ENV_PREFIX=""
      if [ -n "''${PROBE_RS_PROBE:-}" ]; then
          ENV_PREFIX=$(printf 'PROBE_RS_PROBE=%q ' "$PROBE_RS_PROBE")
      fi

      QUOTED=""
      for a in "''${ARGS[@]}"; do
          QUOTED+=" $(printf '%q' "$a")"
      done

      exec ${pkgs.openssh}/bin/ssh "$HOST" "''${ENV_PREFIX}probe-rs$QUOTED"
    '')
  ];
}
