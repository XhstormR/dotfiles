#!/usr/bin/env fish

# https://github.com/chubin/wttr.in
function weather_status
    curl --silent --max-time 3 --user-agent 'a' 'https://wttr.in/wnz?lang=zh-cn&format=%l:+%C+%t\n' 2>/dev/null
end
