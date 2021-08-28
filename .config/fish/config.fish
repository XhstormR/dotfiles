fish_add_path -Pma /usr/bin # 移动至最后，降低优先级
fish_add_path (brew --prefix coreutils)/libexec/gnubin

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

export LESS='-iFRMNX --mouse --use-color'

export _ZL_CD='cd'

export FZF_ALT_C_COMMAND='fd -H -E .git -t d . $dir'
export FZF_CTRL_T_COMMAND='fd -H -E .git -t f . $dir'
export FZF_DEFAULT_COMMAND='fd -H -E .git'
export FZF_ALT_C_OPTS='-0 --preview "exa -T {} | head -100"'
export FZF_CTRL_T_OPTS='-0 --preview "bat -f -r :100 {}"'
export FZF_DEFAULT_OPTS='-0 -m'
export FZF_TMUX=1
alias f='fzf'

export NNN_PLUG='p:preview-tui;o:fzopen;c:fzcd;'
export NNN_COLORS='#0c'
alias nnn='nnn -adeUH -Pp'

export EXA_COLORS='da=2;0:gm=1;0'
alias exa='exa --group-directories-first --color=auto --time-style=long-iso -abFg --git --icons --color-scale --sort=Name'

# alias ls='ls --group-directories-first --color=auto --time-style=long-iso -hFX'
alias ls='exa'
alias l='ls -l'
alias la='l -a'
alias ll='l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias df='df -h'
alias du='du -h'

alias whence='type -a'
alias hexdump='hexdump -C'
alias grep='grep --color=auto -n'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias pgrep='pgrep -a'

alias vi='vim'
alias cat='bat'

alias ..='c ..'
alias ...='c ../..'
alias ....='c ../../..'

alias dt='c ~/Desktop'
alias dc='c ~/Documents'
alias dl='c ~/Downloads'
alias pj='c ~/IdeaProjects'

alias gs='git status'
alias gd='git diff'

alias now='date +"%F %T"'
alias week='date +"%V"'
alias myip='curl -sk https://myip.ipip.net/'
alias diff='git diff --no-index --color-words'
alias rand='openssl rand -hex 30'
alias aria2c='aria2c -s16 -x16 -k1M'
alias reload='exec fish'
alias map='xargs -n1'
alias fs='du -sbh'
alias cb='pbcopy' # Clipboard
alias jq='jq -C'
alias xq='xmllint --format'
alias e='idea -e'

function o
    # set -l path (cygpath -w (pwd))
    # explorer $path

    # nautilus .

    if count $argv > /dev/null
        open $argv
    else
        open .
    end
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

function fkill
  set -l header (ps aux | head -1)
  set -l pid (ps aux | fzf -e --header "$header" | tr -s ' ' | cut -d ' ' -f 2)
  if test -n "$pid"
    kill -9 $pid
  end
end

function proxy_on
    set -xU all_proxy socks5://127.0.0.1:1080
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
    set -l statusb_color (set_color brblue --bold)
    set -l prompt_pwd (prompt_pwd | sed "s,/,$status_color/$status_color,g" | sed "s,\(.*\)/[^m]*m,\1/$statusb_color,")

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

    set -l prompt_time (date +"%T")
    set -l prompt_duration (math $CMD_DURATION / 1000)
    set -l prompt_right (printf '(%.2fs) %s ' $prompt_duration $prompt_time)

    set -l left_width (string_width $prompt_left)
    set -l right_width (string_width $prompt_right)
    set -l space_width (math $COLUMNS - $left_width - $right_width + 5)
    set -l prompt_space (printf '%'$space_width's')

    printf '%s%s%s\n %s ' \
    $prompt_left \
    $prompt_space \
    $prompt_right \
    $prompt_suffix
end

# https://github.com/fish-shell/fish-shell/issues/4012
function string_width
    set --local empty ''
    set --local raw_string (string replace --all --regex '\e\[[^m]*m' $empty -- $argv)
    string length -- $raw_string
end

function preexec --on-event fish_preexec
end

function postexec --on-event fish_postexec
end

if type tmux > /dev/null 2>&1 ; and not set -q TMUX
    tmux attach -c (pwd) || tmux new
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