clientkeys = awful.util.table.join(
-- un petit ajout personnel : avec mod+shift+left/right on déplace rapidement
-- une fenetre sur le bureau d'à-côté
    awful.key({ modkey, "Shift"   }, "Left",   function (c) 
      currtag = c:tags()[1]
      local destag = 0
      if currtag then
        for i, v in ipairs(tags[mouse.screen]) do
          if v == currtag then
              destag = i-1
              break
          end
        end
      end
      if destag == 0 then
        destag = #tags[mouse.screen]
      end
      awful.client.movetotag(tags[mouse.screen][destag])
    end),
    awful.key({ modkey, "Shift"   }, "Right",   function (c) 
      currtag = c:tags()[1]
      local destag = 0
      if currtag then
        for i, v in ipairs(tags[mouse.screen]) do
          if v == currtag then
              destag = i+1
              break
          end
        end
      end
      if destag == #tags[mouse.screen]+1 then
        destag = 1
      end
      awful.client.movetotag(tags[mouse.screen][destag])
    end),
    -- fin de l'ajout
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ altkey,           }, "r",      function (c) c.minimized = true               end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "p",      function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"   }, "o",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- pour se déplacer avec les chiffres d'un bureau à l'autre
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

-- run or raise
globalkeys = awful.util.table.join(globalkeys, aweror.genkeys(modkey))

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
--    awful.button({ modkey }, 4, function () awful.util.spawn("transset-df -a --inc 0.1")  end),
--    awful.button({ modkey }, 5, function () awful.util.spawn("transset-df -a --dec 0.1")  end)
    )
root.keys(globalkeys)
