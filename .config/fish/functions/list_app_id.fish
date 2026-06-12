#!/usr/bin/env fish

function list_app_id
    for app_dir in (fd --max-depth 1 --type d --extension app -- . ~/Applications /Applications)
        set plist (path filter -f \
            "$app_dir/Contents/Info.plist" \
            "$app_dir/WrappedBundle/Info.plist"
        )
        set bundle_id (defaults read $plist[1] CFBundleIdentifier)
        echo "$app_dir  -  $bundle_id"
    end
end
