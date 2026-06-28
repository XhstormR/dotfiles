local function setup()
    -- https://github.com/sxyazi/yazi/blob/main/yazi-fs/src/sorter.rs
    ps.sub("ind-sort", function(opt)
        local cwd = cx.active.current.cwd
        if cwd:ends_with("Downloads") then
            opt.by, opt.reverse = "mtime", false
        elseif cwd:ends_with("Music") then
            opt.by, opt.reverse = "mtime", true
        else
            opt.by, opt.reverse = "extension", false
        end
        return opt
    end)
end

return { setup = setup }
