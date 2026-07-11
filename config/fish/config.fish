if status is-interactive
    fastfetch
end

set -g fish_greeting
set -gx PATH $PATH $HOME/.dotnet/tools $HOME/.local/bin

set -Ux SSL_CERT_DIR "$HOME/.aspnet/dev-certs/trust:/etc/ssl/certs"

set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x LC_ALL C.UTF-8