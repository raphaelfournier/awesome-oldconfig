root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
--    awful.button({ modkey, }, 3, function ()
--                                              if menuinstance then
--                                                  menuinstance:hide()
--                                                  menuinstance = nil
--                                              else
--                                                  menuinstance = awful.menu.clients({ width=250 })
--                                              end
--                                          end)
))
-- }}}
val=nil

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
-- || des fonctions pour déplacer et redimensionner les fenetres au clavier
    awful.key({ altkey, "Control" }, "Down",  function () awful.client.moveresize(0, 0, 0, 20) end),
    awful.key({ altkey, "Control" }, "Up",    function () awful.client.moveresize(0, 0, 0, -20) end),
    awful.key({ altkey, "Control" }, "Left",  function () awful.client.moveresize(0, 0, -20, 0) end),
    awful.key({ altkey, "Control" }, "Right", function () awful.client.moveresize(0, 0, 20, 0) end),
    awful.key({ altkey, "Shift"   }, "Down",  function () awful.client.moveresize(0, 20, 0, 0) end),
    awful.key({ altkey, "Shift"   }, "Up",    function () awful.client.moveresize(0, -20, 0, 0) end),
    awful.key({ altkey, "Shift"   }, "Left",  function () awful.client.moveresize(-20, 0, 0, 0) end),
    awful.key({ altkey, "Shift"   }, "Right", function () awful.client.moveresize(20, 0, 0, 0) end),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "s", function () mymainmenu:toggle({keygrabber=true, coords={x=25, y=30} })        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey,           }, "x", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn(terminal,false) end),
    awful.key({                   }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/marie/screenshots/ 2>/dev/null'") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey,           }, "a", revelation.revelation),
    awful.key({ altkey, "Shift"   }, "n", function () raise_all()                       end),
    awful.key({ modkey,           }, "<", function () dmenu_command()                   end), 
    awful.key({ modkey, "Control" }, "<", function () dmenu_netcfg()                    end), 
    awful.key({ modkey, "Shift"   }, "q", function () dmenu_mpd()                       end), 
    awful.key({ modkey,           }, "q", function () dmenu_system()                    end), 
    awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox")       end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn("evolution")     end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("pcmanfm")       end),

    awful.key({ modkey,           }, "v", function () awful.util.spawn("amixer -q sset PCM 2%+")       end),
    awful.key({ modkey, "Shift"   }, "v", function () awful.util.spawn("amixer -q sset PCM 1%-")       end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("amixer -q sset Master 2%+")    end),
    awful.key({ modkey, "Shift"   }, "g", function () awful.util.spawn("amixer -q sset Master 1%-")    end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({ modkey,           }, "n", function () awful.util.spawn("mpc next")                     end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.util.spawn("mpc prev")                     end),
    awful.key({ modkey,           }, ",", function () awful.util.spawn("mpc toggle")                   end),
    awful.key({ modkey,  "Shift"  }, ",", function () awful.util.spawn("mpc stop")                     end),
    awful.key({ modkey, "Shift"   }, "w", function () awful.util.spawn("urxvtc -e ncmpcpp")            end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("xscreensaver-command -lock")   end),
    awful.key({ modkey,           }, "d", function () coverart()                                       end),
-- transset permet de modifier la transparence d'une fenêtre
    awful.key({ modkey,           }, "!", function () awful.util.spawn("transset-df -a --inc 0.1")     end),
    awful.key({ modkey, "Shift"   }, "!", function () awful.util.spawn("transset-df -a --dec 0.1")     end),
-- Prompts
    awful.key({ modkey }, "Return", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "r",      function () lua_prompt()                    end),
    awful.key({ modkey }, "F4",     function () manual_prompt()                 end),
    awful.key({ modkey }, "F5",     function () pwd_prompt()                    end),
    awful.key({ modkey }, "F6",     function () calc_prompt()                   end),
    awful.key({ modkey }, "F7",     function () dict_prompt()                   end),
    awful.key({ modkey }, "F9", function ()
              awful.menu.menu_keys.down = { "Down", "Alt_L" }
                      local cmenu = awful.menu.clients({width=230}, {
                        keygrabber=true, coords={x=525, y=330} }) end),
    awful.key({ modkey }, "F8",     function () converter_prompt()              end)
)

