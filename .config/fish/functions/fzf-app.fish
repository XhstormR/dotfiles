#!/usr/bin/env fish

function list_app --description 'List local apps: <path>  -  <bundle id>'
    for app_dir in (fd --follow --max-depth 1 --type d --extension app -- . \
        ~/Applications/ \
        /Applications/ \
        /Applications/Utilities/ \
        /System/Applications/ \
        /System/Applications/Utilities/ \
        /System/Library/CoreServices/Applications/ \
    )
        set -l plist (path filter -f \
            "$app_dir/Contents/Info.plist" \
            "$app_dir/WrappedBundle/Info.plist"
        )
        set -l bundle_id (defaults read $plist[1] CFBundleIdentifier)
        echo "$app_dir  -  $bundle_id"
    end
end

function fzf-app --description 'Enter to open selected app'
    set -l apps (list_app 2>/dev/null | fzf --prompt='Apps> ' --layout=reverse --delimiter='  -  ' --accept-nth=1)
    and open $apps
end
