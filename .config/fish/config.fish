fish_config theme choose Dracula

fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path ~/.pixi/bin
fish_add_path ~/.local/bin

eval fzf --fish | source
eval zoxide init fish | source
eval brew shellenv | source

set -a fish_complete_path ~/.pixi/completions/fish
set -g fish_prompt_pwd_dir_length 0
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_show_informative_status 1

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

export LANG='C.UTF-8'
export LC_ALL='C.UTF-8'
export EDITOR='code'
export VISUAL='code'
export HISTCONTROL='ignoreboth'
export GPG_TTY=(tty)
export SHELL=(command -v fish)

export PAGER='less'
export LESS="--raw-control-chars --quit-if-one-screen --redraw-on-quit --mouse --status-line --ignore-case --long-prompt --use-color --incsearch --file-size --follow-name"

export FZF_ALT_C_COMMAND='fd -t d . $dir'
export FZF_CTRL_T_COMMAND='fd -t f . $dir'
export FZF_DEFAULT_COMMAND='fd'
export FZF_ALT_C_OPTS='--preview "eza --color=always --tree --level 3 {}"'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --line-range :200 {}" --preview-window "~4" --bind "ctrl-o:execute-silent($EDITOR --goto {})" --bind "focus:bg-transform-header(file -bI {}),f2:execute(cat {})"'
export FZF_DEFAULT_OPTS='-0 -1 --gap --wrap --multi --ansi --tmux 85% --border --style=full --info=inline-right --marker-multi-line "╔║╚" --marker "║" --pointer ▌ --gutter " " --highlight-line --color marker:green,pointer:green,prompt:green,selected-bg:238,border:#9999cc --preview-window "wrap:70%" --bind "alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview,ctrl-y:execute-silent(echo {} | cb)+abort"'
alias f='fzf'

export EZA_COLORS='da=2;0:gm=1;0'
alias eza='eza -abgF --group-directories-first --color=auto --time-style=long-iso --git-repos-no-status --octal-permissions --flags --icons --color-scale --sort=Extension --hyperlink'

export XDG_CONFIG_HOME="$HOME/.config"
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
alias fd='fd --hidden --follow --exclude .git --color=always --hyperlink=auto'
alias yt-dlp='yt-dlp --embed-metadata' # --cookies-from-browser chrome

alias vi='vim'
alias cat='bat'
alias xxd='hexyl'

alias ..='c ..'
alias ...='c ../..'
alias ....='c ../../..'

alias dt='c ~/Desktop'
alias dc='c ~/Documents'
alias dl='c ~/Downloads'
alias dp='c ~/IdeaProjects'

alias g='lazygit'
alias gs='git status'
alias gd='git diff'

alias now='date +"%F %T"'
alias week='date +"%V"'
alias tree='l -T'
alias diff='delta'
alias rand='openssl rand -hex 30'
alias aria2c='aria2c -s16 -x16 -k1M'
alias map='xargs -n1'
alias cpu='top -o cpu'
alias mem='top -o rsize'
alias cb='fish_clipboard_copy' # Clipboard
alias jq='jq -r'
alias xq='xmllint --format'
alias e='$EDITOR'
alias ip_lan='__fish_print_addresses | perl -nle"/(\d+\.\d+\.\d+\.\d+)/ and print \$1"'
alias ip_wan='curl -sk https://myip.ipip.net/; dig -4 +short myip.opendns.com @resolver1.opendns.com; curl -sk https://ipinfo.io/json'
alias serveme='jwebserver -b 0.0.0.0 --port 8080'
alias reload='exec fish'
alias update='brew update && brew upgrade --greedy --force-bottle && pixi global update'

function rm
    switch (uname)
        case Darwin
            trash $argv
        case Windows_NT 'MINGW64_NT*'
            # https://nircmd.nirsoft.net/moverecyclebin.html
            for i in $argv
                nircmdc.exe moverecyclebin $i
            end
        case Linux
            command rm $argv
        case '*'
            echo "不支持的操作系统: $(uname)"
    end
end

function o -a path
    test -z "$path"; and set path .

    switch (uname)
        case Darwin
            open $path
        case Windows_NT 'MINGW64_NT*'
            start $path
        case Linux
            xdg-open $path
        case '*'
            echo "不支持的操作系统: $(uname)"
    end
end

function c
    cd $argv[1] && ll
end

function z
    __zoxide_z $argv && ll
end

function a
    set -l archive (basename (pwd))
    7zz a -y -aoa -sccUTF-8 $archive $argv
end

function x
    set -l dirname (basename $argv[1] | string split --right --max 1 .)[1]
    7zz x -y -aoa -sccUTF-8 -o$dirname $argv[1]
end

function h
    $argv[1] --help || $argv[1] -help || $argv[1] help
end

function v
    $argv[1] --version || $argv[1] -version || $argv[1] version
end

function md
    mkdir -p $argv && cd $argv
end

function fzf-kill -a pattern
    if test -n "$pattern"
        command pkill -9 $pattern
        return
    end

    set -l cmd_prefix 'ps -e -opid,user,command'
    set -l cmd_selected (fzf \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --bind "enter:execute-silent(kill -9 {1})+reload($cmd_prefix)" \
        --header 'Press Enter to kill
Press CTRL-R to reload' \
        --header-lines=1 \
        --prompt='Processes> ' \
        --preview='ps -f -p {1} || echo "Cannot preview {1} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse \
    )
    set -l pids_selected (printf '%s\n' $cmd_selected | awk '{print $1}')
    if test -n "$pids_selected"
        kill -9 $pids_selected
    end
end

function fzf-docker
    set -l cmd_prefix 'docker ps -a'
    set -l cmd_selected (fzf \
        --bind "start:reload($cmd_prefix)" \
        --bind "ctrl-r:reload($cmd_prefix)" \
        --header 'Press CTRL-R to reload' \
        --header-lines=1 \
        --prompt='Container> ' \
        --preview='docker stats --no-stream {1} || echo "Cannot preview {1} because it exited."' \
        --preview-window="down:4:wrap" \
        --layout=reverse \
    )
    set -l cid_selected (printf '%s\n' $cmd_selected[1] | awk '{print $1}')
    if test -n "$cid_selected"
        docker start $cid_selected && docker exec -it $cid_selected sh
    end
end

function fzf-rg
    set -l cmd_prefix 'rg --no-heading --column --color=always --'
    set -l cmd_selected (fzf \
        --disabled \
        --query "$argv" \
        --bind "start:reload($cmd_prefix {q})" \
        --bind "change:reload($cmd_prefix {q} || true)" \
        --bind "ctrl-o:execute-silent($EDITOR --goto {1}:{2}:{3})" \
        --bind "f2:execute(cat {1})" \
        --bind "focus:bg-transform-header(file -bI {1})" \
        --prompt='Search> ' \
        --delimiter ':' \
        --preview 'bat --color=always --theme="Solarized (dark)" --highlight-line {2} -- {1}' \
        --preview-window '~4,+{2}/3,<80(up)' \
        --layout=reverse \
    )
    set -l files_selected (printf '%s\n' $cmd_selected | awk -F: '{print $1}' | sort -u | string join ' ')
    if test -n "$files_selected"
        commandline $files_selected
    end
end

function fish_user_key_bindings
    fzf_key_bindings
end

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -l color_normal (set_color normal)
    set -l color_status (set_color normal)

    set -l suffix '❯'
    if fish_is_root_user
        set suffix '#'
    end

    if not contains $last_pipestatus 0 141
        set color_status (set_color brred --bold)
    else
        set color_status (set_color brgreen --bold)
    end
    set suffix (printf '%s%s%s' $color_status $suffix $color_normal)

    set -l color_status (set_color bryellow --bold)
    set -l prompt_login  (printf '%s┌─ %s%s' $color_status (prompt_login) $color_normal)
    set -l prompt_suffix (printf '%s└──%s%s' $color_status $suffix $color_normal)

    set -l color_status (set_color brblue)
    set -l prompt_pwd_hyperlink (printf '\e]8;;file://%s\e\\\%s\e]8;;\e\\' (string escape --style=url -- $PWD) (prompt_pwd))
    set -l prompt_pwd (printf '%s%s%s' $color_status $prompt_pwd_hyperlink $color_normal)

    set -l prompt_vcs (fish_vcs_prompt) # too slow
    if test -n "$prompt_vcs"
        set prompt_vcs (printf '%s' $prompt_vcs)
    end

    set -l color_status  (set_color $fish_color_status)
    set -l color_statusb (set_color $fish_color_status --bold)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$color_status" "$color_statusb" $last_pipestatus)
    if test -n "$prompt_status"
        set prompt_status (printf ' %s' $prompt_status)
    end

    set -l prompt_proxy ''
    if set -q all_proxy
        set prompt_proxy ' 🚀'
    end

    set -l prompt_left (printf '%s:%s%s%s%s ' $prompt_login $prompt_pwd $prompt_vcs $prompt_status $prompt_proxy)

    set -l prompt_time (date +"%T")
    set -l prompt_duration (math $CMD_DURATION / 1000)
    set -l prompt_right (printf ' (%.2fs) %s ' $prompt_duration $prompt_time)

    set -l color_status (set_color yellow)
    set -l width_left (string length --visible $prompt_left)
    set -l width_right (string length --visible $prompt_right)
    set -l width_space (math max 0, $COLUMNS - $width_left - $width_right)
    set -l prompt_space (string pad -w$width_space -c─ '')
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
