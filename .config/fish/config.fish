fish_config theme choose Dracula

fish_add_path /usr/bin
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path ~/.local/bin
fish_add_path "$MAMBA_ROOT_PREFIX/bin"
fish_add_path "$MAMBA_ROOT_PREFIX/lib/jvm/bin"

eval micromamba shell hook --shell fish | source
eval fzf --fish | source

set -g fish_prompt_pwd_dir_length 0
# https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=leo
set -g fish_greeting '
   ██╗     ███████╗ ██████╗
   ██║     ██╔════╝██╔═══██╗
   ██║     █████╗  ██║   ██║
   ██║     ██╔══╝  ██║   ██║
   ███████╗███████╗╚██████╔╝
   ╚══════╝╚══════╝ ╚═════╝
    _____
   /     \
   vvvvvvv/|____/|
      I  /O,O    |
      I /_____   |      /|/|
     J|/^ ^ ^ \  |    /00  |    _//|
      |^ ^ ^ ^ |W|   |/^^\ |   /oo |
       \m___m__|_|    \m_m_|   \mm_|
'

export LANG='C'
export VISUAL='subl'
export EDITOR='subl'
export HISTCONTROL='ignoreboth'
export GPG_TTY=(tty)

export PAGER='moar'
export MOAR='--no-linenumbers -no-clear-on-exit -quit-if-one-screen -mousemode scroll'

export FZF_ALT_C_COMMAND='fd -H -E .git -t d . $dir'
export FZF_CTRL_T_COMMAND='fd -H -E .git -t f . $dir'
export FZF_DEFAULT_COMMAND='fd -H -E .git'
export FZF_ALT_C_OPTS='--preview "eza -T -L3 {} | head -100"'
export FZF_CTRL_T_OPTS='--preview "bat -f -r :100 {}"'
export FZF_DEFAULT_OPTS='-0 --multi --border --style=full --info=inline-right --marker ▏ --pointer ▌ --highlight-line --color marker:green,pointer:green,prompt:green,gutter:-1,selected-bg:238'
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p 90%'
alias f='fzf'

export NNN_BMS='t:~/.local/share/Trash/;'
export NNN_PLUG='p:preview-tui;o:fzopen;c:fzcd;z:autojump;x:!chmod +x $nnn*;'
export NNN_PAGER=$PAGER
export NNN_TRASH='1'
export NNN_COLORS='#0c'
functions --copy n __n
alias n='__n -adexoiUH -Te -Pp'

export EZA_COLORS='da=2;0:gm=1;0'
alias eza='eza --group-directories-first --color=auto --time-style=long-iso -abgF --git --icons --color-scale --sort=Extension --hyperlink'

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias ls='eza'
alias ll='ls -l'
alias la='ll -a'
alias l='ll'

# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

alias df='df -h'
alias du='du -h'

alias whence='type -a'
alias hexdump='hexdump -C'
alias grep='grep --color=auto -n'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias pgrep='pgrep -a'
alias mkdir='mkdir -p'
alias fd='fd --hyperlink=auto'

alias vi='vim'
alias cat='bat'
alias xxd='hexyl'
alias rm='trash'

alias ..='c ..'
alias ...='c ../..'
alias ....='c ../../..'

alias dt='c ~/Desktop'
alias dc='c ~/Documents'
alias dl='c ~/Downloads'
alias dp='c ~/IdeaProjects'

alias g='git'
alias gs='git status'
alias gd='git diff'

alias now='date +"%F %T"'
alias week='date +"%V"'
alias myip='dig -4 +short myip.opendns.com @resolver1.opendns.com; curl -sk https://myip.ipip.net/'
alias tree='l -T'
alias diff='delta'
alias rand='openssl rand -hex 30'
alias aria2c='aria2c -s16 -x16 -k1M'
alias reload='exec fish'
alias map='xargs -n1'
alias cpu='top -o cpu'
alias mem='top -o rsize'
alias fs='du -sbh'
alias cb='fish_clipboard_copy' # Clipboard
alias jq='jq -r'
alias xq='xmllint --format'
alias e='subl'

function o -a path
    # set -l path (cygpath -w (pwd))

    # if count $argv > /dev/null
    #     echo $argv
    # else
    #     echo none
    # end

    [ -n "$path" ]; or set -l path .
    open $path
    # explorer $path
    # nautilus $path
end

function c
    cd $argv[1] && ll
end

function z
    __zoxide_z $argv && ll
end

function x
    set -l name (basename $argv[1] | string split -r -m1 .)[1]
    7zz x $argv[1] -y -o$name
end

function h
    $argv[1] --help || $argv[1] -help || $argv[1] help
end

function v
    $argv[1] --version || $argv[1] -version || $argv[1] version
end

function take
    mkdir -p $argv && cd $argv
end

function fkill -a pattern
  if test -n "$pattern"
    pkill -9 $pattern
    return
  end

  set -l header (ps aux | head -1)
  set -l pid (ps aux | fzf -e --header "$header" | tr -s ' ' | cut -d ' ' -f 2)
  if test -n "$pid"
    kill -9 $pid
  end
end

function __proxy_on
    set -xU all_proxy socks5h://127.0.0.1:1080
    set -xU http_proxy http://127.0.0.1:1080
    set -xU https_proxy http://127.0.0.1:1080
    set -xU GIT_SSH_COMMAND 'ssh -o ProxyCommand="socat - PROXY:127.0.0.1:%h:%p,proxyport=1080"'
end

function __proxy_off
    set -e all_proxy
    set -e http_proxy
    set -e https_proxy
    set -e GIT_SSH_COMMAND
end

function proxy_toggle
    if set -q all_proxy
        __proxy_off
    else
        __proxy_on
    end
    true
end

function fish_user_key_bindings
    fzf_key_bindings
end

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -l color_normal (set_color normal)
    set -l color_status (set_color bryellow --bold)

    set -l suffix '❯'
    if fish_is_root_user
        set suffix '#'
    end
    set -l prompt_login  (printf '%s┏━ %s%s' $color_status (prompt_login) $color_normal)
    set -l prompt_suffix (printf '%s┗━━%s%s' $color_status $suffix $color_normal)

    set -l color_status (set_color brblue)
    set -l prompt_pwd_hyperlink (printf '\e]8;;file://%s\e\\\%s\e]8;;\e\\' (string escape --style=url -- $PWD) (prompt_pwd))
    set -l prompt_pwd (printf '%s%s%s' $color_status $prompt_pwd_hyperlink $color_normal)

    # set -l prompt_vcs (fish_vcs_prompt) # too slow
    if test -n "$prompt_vcs"
        set prompt_vcs (printf '%s ' $prompt_vcs)
    end

    set -l color_status  (set_color $fish_color_status)
    set -l color_statusb (set_color $fish_color_status --bold)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$color_status" "$color_statusb" $last_pipestatus)
    if test -n "$prompt_status"
        set prompt_status (printf '%s ' $prompt_status)
    end

    set -l prompt_proxy ''
    if set -q all_proxy
        set prompt_proxy '🚀 '
    end

    set -l prompt_left (printf '%s:%s %s%s%s' $prompt_login $prompt_pwd $prompt_vcs $prompt_status $prompt_proxy)

    set -l prompt_time (date +"%T")
    set -l prompt_duration (math $CMD_DURATION / 1000)
    set -l prompt_right (printf ' (%.2fs) %s ' $prompt_duration $prompt_time)

    set -l color_status (set_color yellow)
    set -l width_left (string length --visible $prompt_left)
    set -l width_right (string length --visible $prompt_right)
    set -l width_space (math max 0, $COLUMNS - $width_left - $width_right)
    set -l prompt_space (string pad -w$width_space -c━ '')
    set -l prompt_space (printf '%s%s%s' $color_status $prompt_space $color_normal)

    printf '%s%s%s\n%s ' \
    $prompt_left \
    $prompt_space \
    $prompt_right \
    $prompt_suffix
end

function preexec --on-event fish_preexec
end

function postexec --on-event fish_postexec
end

if type tmux > /dev/null 2>&1 ; and not set -q TMUX
    tmux -2u attach -c (pwd) || tmux -2u new
end

## MacOS
# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Recursively delete .DS_Store files
alias cleanup="fd '.DS_Store' --hidden --no-ignore --type file -X rm -v"

# Change working directory to the top-most Finder window location
function cdf
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
