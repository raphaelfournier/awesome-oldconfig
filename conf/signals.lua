-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
  -- avoid gaps at end/bottom of screen
--    c.size_hints_honor = false
--if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
--              if c.titlebar then awful.titlebar.remove(c)
--                            else awful.titlebar.add(c, {modkey = modkey}) 
--              end
--end

-- Add a titlebar
--     awful.titlebar.add(c, { modkey = modkey })
    --
--    client.add_signal("focus", function(c)
--                                c.border_color = beautiful.border_focus
--                                c.opacity = 1
--                              end)
--client.add_signal("unfocus", function(c)
--                                c.border_color = beautiful.border_normal
--                                c.opacity = 0.7
--                              end)


    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

