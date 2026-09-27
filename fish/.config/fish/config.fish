# 初始化 Homebrew 環境
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
else if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv fish | source
end

# No Greetings
set fish_greeting ""

# Starship setup
starship init fish | source

# More useful command with alias
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"

# 其他 fish 設定可以放在下面

if status is-interactive
    # Commands to run in interactive sessions can go here
end
