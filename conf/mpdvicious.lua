--
--mpdwidget = widget({ type = "textbox" })
--vicious.register(mpdwidget, vicious.widgets.mpd, 
--  function (widget,args)
--    local colorbal=' <span color ="#dc8cc3">'
--    local endcolorbal='</span>'
--    if args["{state}"] == "Stop" then return ""
--    else
--      if args["{state}"] == "N/A" then return ""
--      else
--        if args["{state}"] == "Pause" then colorbal='<span color ="white">' end
--        if args["{Title}"] ~= "N/A" then return colorbal .. args["{Artist}"] .. ' - ' .. args["{Title}"] .. endcolorbal
--        else 
--          if args["{Name}"] == "N/A" then return colorbal .. args["{Name}"] .. endcolorbal
--          else
--            return colorbal .. args["{file}"] .. endcolorbal or nil
--          end
--        end
--      end
--    end
--  end,5)
--
--mpdwidget:add_signal("mouse::enter", function() mpd_popup()                        
--        end)
--mpdwidget:add_signal("mouse::leave", function() mpd_popdown()                        
--        end)
--mpdwidget:buttons(awful.util.table.join(
--    awful.button({ }, 1, function () awful.util.spawn("urxvt -e ncmpcpp", false) end),
--    awful.button({ }, 2, function () awful.util.spawn("mpc toggle", false) end),
--    awful.button({ }, 3, function () awful.util.spawn("mpc stop", false) end),
--    awful.button({ }, 4, function () awful.util.spawn("mpc next", false) end),
--    awful.button({ }, 5, function () awful.util.spawn("mpc prev", false) end)
--))
--
--function mpd_popup()
--         local mpdcontent = awful.util.pread("/usr/bin/mpc playlist")
--         popupmpd = naughty.notify({
--           text = mpdcontent,
--           timeout = 10, hover_timeout = 1,
--           width = 500, position = "top_right", screen = mouse.screen
--         })
--end
--
--function mpd_popdown()
--   naughty.destroy(popupmpd)
--   popupmpd = nil
--end


