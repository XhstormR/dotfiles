#!/usr/bin/env fish

function md2pdf
    set -l input $argv[1]
    set -l output "$input.pdf"

    if not test -f "$input"
        echo "文件不存在: $input"
        return 1
    end

    pandoc "$input" --output="$output" --from=gfm --to=typst --pdf-engine=typst --toc --standalone
end
