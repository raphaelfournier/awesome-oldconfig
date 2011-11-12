----
weatherwidget = widget({ type = "textbox" })
metarid = "LFPO"
weathercommand = "weather -i " .. metarid .. " --headers=Temperature --quiet -m | awk '{printf(\"%s%s\",$2,\"°C\")}'"
text = awful.util.pread(weathercommand) or ""
weatherwidget.text = '<span color="' .. beautiful.fg_focus .. '">' .. text .. '</span>'
weathertimer = timer( { timeout = 900 } ) 
weathertimer:add_signal( "timeout", function() weatherwidget.text = awful.util.pread(weathercommand .. " &") end)
weathertimer:start() -- Start the timer
weatherwidget:buttons(awful.util.table.join(
                    awful.button({ }, 1, function() 
  weather = naughty.notify({
    title="Weather",
    text=awful.util.pread("weather -i " .. metarid .. " -m")
})
 end)
              ))

