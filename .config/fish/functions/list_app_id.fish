#!/usr/bin/env fish

function list_app_id
    for app_dir in (fd --max-depth 1 --type d --extension app -- . ~/Applications /Applications)
        set bundle_id (mdls -name kMDItemCFBundleIdentifier -r $app_dir)
        echo "$app_dir  -  $bundle_id"
    end
end
