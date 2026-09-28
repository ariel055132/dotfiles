# Homebrew setting
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
else if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv fish | source
end

# Commands to run in interactive sessions can go here
if status is-interactive
    
    # No Greetings
    set fish_greeting ""

    # Eza Setting -> Original Setting
    if command -q eza
        alias ls  'eza --icons=auto --group-directories-first'
        alias la  'eza --icons=auto --group-directories-first -a'
        alias ll  'eza --icons=auto --group-directories-first -l'
        alias lla 'eza --icons=auto --group-directories-first -la'
        alias lt  'eza --icons=auto --group-directories-first --tree --level=2'
    else
        alias ls 'ls -p -G'
        alias la 'ls -A'
        alias ll 'ls -l'
        alias lla 'll -A'
    end

    # Starship setting
    if command -q starship
        starship init fish | source
    end
end
