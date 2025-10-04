# Auto-start Niri on TTY1
if test -z "$WAYLAND_DISPLAY" && test "$XDG_VTNR" -eq 1
  exec @niri@/bin/niri-session
end

# Interactive shell setup
if status --is-interactive
    @direnv@/bin/direnv hook fish | source
    @keychain@/bin/keychain --eval --quiet -Q id_ed25519 | source
end

# Keychain integration
begin
    set -l HOSTNAME (hostname)
    if test -f ~/.keychain/$HOSTNAME-fish
        source ~/.keychain/$HOSTNAME-fish
    end
end

# ls replacement with eza
function ls -d 'eza instead of ls when output is a terminal'
  if isatty 1
    if type --quiet @eza@/bin/eza
      @eza@/bin/eza --group-directories-first --git --icons $argv
    else
      command ls --color=auto $argv
    end
  else
    command ls $argv
  end
end

# ls aliases
function ll -d 'alias ls -l'
  ls -l $argv
end

function lt
  ls -l --tree $argv
end

function la -d 'alias ls -la'
  ls -la $argv
end
