#!/usr/bin/env fish

function list_app
    for app_dir in (fd --max-depth 1 --type d --extension app -- . \
        ~/Applications/ \
        /Applications/ \
        /System/Library/CoreServices/Applications/ \
    )
        set plist (path filter -f \
            "$app_dir/Contents/Info.plist" \
            "$app_dir/WrappedBundle/Info.plist"
        )
        set bundle_id (defaults read $plist[1] CFBundleIdentifier)
        echo "$app_dir  -  $bundle_id"
    end
end

function fzf-app --description 'Enter to open selected app'
    set -l sel (list_app 2>/dev/null | fzf --prompt='Apps> ' --layout=reverse)
    and open (string split -m1 '  -  ' -- $sel)[1]
end
