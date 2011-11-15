batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 67, "BAT0")
batwidget2 = widget({ type = "textbox" })
vicious.register(batwidget2, vicious.widgets.bat, "$1$2%", 67, "BAT1")
--
--Pulse Audio widget
--vol= widget({ type = "textbox" })
--vicious.register(vol, vicious.contrib.pulse, "$1%", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
--vol:buttons(awful.util.table.join(
--  awful.button({ }, 1, function () awful.util.spawn("urxvtc -e alsamixer") end),
--  awful.button({ }, 2, function () awful.util.spawn("amixer -q sset Master toggle") end),
--  awful.button({ }, 4, function () vicious.contrib.pulse.add(5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
--  awful.button({ }, 5, function () vicious.contrib.pulse.add(-5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end)
--))
--

volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1%",2,"PCM")
volwidget:buttons(
 awful.util.table.join(
 awful.button({ }, 1, function () awful.util.spawn("urxvtc -e alsamixer") end),
 awful.button({ }, 2, function () awful.util.spawn("amixer -q sset PCM toggle") end),
 awful.button({ }, 4, function () awful.util.spawn("amixer -q sset PCM 2%+") end),
 awful.button({ }, 5, function () awful.util.spawn("amixer -q sset PCM 2%-") end)
 )
)
generalvolwidget = widget({ type = "textbox" })
vicious.register(generalvolwidget, vicious.widgets.volume, "$1%",2,"Master")
generalvolwidget:buttons(awful.util.table.join(
 awful.button({ }, 1, function () awful.util.spawn("urxvtc -e alsamixer") end),
 awful.button({ }, 2, function () awful.util.spawn("amixer -q sset Master toggle") end),
 awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 2%+") end),
 awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 2%-") end)
 )
)

datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, '<span color="' .. beautiful.border_focus .. '">%a %d %b %R</span>', 61)

datewidget:buttons(awful.util.table.join(
                    awful.button({ }, 1, function() add_calendar(0) end),
                    awful.button({ }, 3, function() remove_calendar(0) end),
                    awful.button({ }, 5, function() add_calendar(-1) end),
                    awful.button({ }, 4, function() add_calendar(1) end)
              ))
 
local calendar = nil
local offset = 0
 
function remove_calendar()
    if calendar ~= nil then
        naughty.destroy(calendar)
        calendar = nil
        offset = 0
    end
end
 
function add_calendar(inc_offset)
        local save_offset = offset
        remove_calendar()
        offset = save_offset + inc_offset
        local datespec = os.date("*t")
        datespec = datespec.year * 12 + datespec.month - 1 + offset
        datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
        local cal = awful.util.pread("cal -m " .. datespec)
        cal = string.gsub(cal, "^%s*(.-)%s*$", "%1")
        calendar = naughty.notify({
                                     text = string.format('<span font_desc="%s">%s</span>', "Inconsolata Medium 13", os.date("%A %d %B %Y") .. "\n" .. cal),
                                     timeout = 0, hover_timeout = 0.5,
                                     width = 220, position = "top_right", screen = mouse.screen
                                  })
end
