fish_add_path ~/.local/bin
fish_add_path /usr/local/bin
fish_add_path -Pma /usr/bin # 移动至最后，降低优先级

eval conda "shell.fish" "hook" $argv | source

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

export TERM='screen-256color'
export LANG='C'
export VISUAL='idea'
export HISTCONTROL='ignoreboth'
export GPG_TTY=(tty)

export LESS='-iRMX --mouse --use-color'
export LESS_TERMCAP_so=\e'[0;47;30m'
export LESS_TERMCAP_mb=\e'[1;33m'
export LESS_TERMCAP_md=\e'[1;31m'
export LESS_TERMCAP_us=\e'[4;32m'
export LESS_TERMCAP_me=\e'[0m'
export LESS_TERMCAP_se=\e'[0m'
export LESS_TERMCAP_ue=\e'[0m'

export FZF_ALT_C_COMMAND='fd -H -E .git -t d . $dir'
export FZF_CTRL_T_COMMAND='fd -H -E .git -t f . $dir'
export FZF_DEFAULT_COMMAND='fd -H -E .git'
export FZF_ALT_C_OPTS='-0 --preview "exa -T -L3 {} | head -100"'
export FZF_CTRL_T_OPTS='-0 --preview "bat -f -r :100 {}"'
export FZF_DEFAULT_OPTS='-0 -m'
export FZF_TMUX=1
export FZF_TMUX_OPTS='-p'
alias f='fzf'

export NNN_BMS='t:~/.local/share/Trash/;'
export NNN_PLUG='p:preview-tui;o:fzopen;c:fzcd;z:autojump;x:!chmod +x $nnn*;'
export NNN_TRASH='1'
export NNN_COLORS='#0c'
alias nnn='nnn -adexUH -Te -Pp'

export EXA_COLORS='da=2;0:gm=1;0'
alias exa='exa --group-directories-first --color=auto --time-style=long-iso -abFg --git --icons --color-scale --sort=Extension'

# alias ls='ls --group-directories-first --color=auto --time-style=long-iso -hFX'
alias ls='exa'
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
alias cb='pbcopy' # Clipboard
alias jq='jq -C'
alias xq='xmllint --format'
alias e='idea -e'

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

function proxy_on
    set -xU all_proxy socks5h://127.0.0.1:1080
    set -xU http_proxy http://127.0.0.1:1080
    set -xU https_proxy http://127.0.0.1:1080
    set -xU GIT_SSH_COMMAND 'ssh -o ProxyCommand="socat - PROXY:127.0.0.1:%h:%p,proxyport=1080"'
end

function proxy_off
    set -e all_proxy
    set -e http_proxy
    set -e https_proxy
    set -e GIT_SSH_COMMAND
end

function proxy_toggle
    if set -q all_proxy
        proxy_off
    else
        proxy_on
    end
    true
end

function fish_user_key_bindings
    fzf_key_bindings
end

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    set -l status_color (set_color bryellow --bold)
    set -l suffix '❯'
    if fish_is_root_user
        set suffix '#'
    end
    set -l prompt_suffix (printf '%s' $status_color $suffix $normal)

    set -l status_color (set_color brblue)
    set -l prompt_pwd (printf '%s' $status_color (prompt_pwd) $normal)

    # set -l prompt_vcs (fish_vcs_prompt) # too slow
    if test -z "$prompt_vcs"
        set prompt_vcs $normal
    end

    set -l status_color  (set_color $fish_color_status)
    set -l statusb_color (set_color $fish_color_status --bold)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    if test -z "$prompt_status"
        set prompt_status $normal
    end

    set -l prompt_left (printf '%s:%s %s%s' (prompt_login) $prompt_pwd $prompt_vcs $prompt_status)

    set -l prompt_proxy ''
    if set -q all_proxy
        set prompt_proxy '🚀'
    end

    set -l prompt_time (date +"%T")
    set -l prompt_duration (math $CMD_DURATION / 1000)
    set -l prompt_right (printf '%s (%.2fs) %s ' $prompt_proxy $prompt_duration $prompt_time)

    set -l left_width (string length --visible $prompt_left)
    set -l right_width (string length --visible $prompt_right)
    set -l space_width (math max 0, $COLUMNS - $left_width - $right_width)
    set -l prompt_space (string pad -w$space_width '')

    printf '%s%s%s\n %s ' \
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
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
# Change working directory to the top-most Finder window location
function cdf
    cd (osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
