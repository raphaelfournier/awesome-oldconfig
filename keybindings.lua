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
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
--    awful.key({ modkey,           }, "z", function () mymainmenu:toggle()        end),

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

    -- Standard program
    awful.key({ modkey,           }, "x", function () awful.util.spawn(terminal) end),
    -- lance un terminal en slave
    awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn(terminal,false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
-- Newt command brutally quits Awesome !!
--    awful.key({ modkey, "Shift"   }, "q", awesome.quit), 
-- || prend une capture d'ecran et la met dans le dossier images/screenshots/
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/marie/screenshots/ 2>/dev/null'") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

-- || my own keybindings
-- revelation = expose comme sous Mac ou avec Compiz -> requiert revelation.lua
    awful.key({ modkey,           }, "a", revelation.revelation),
--    awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox-beta-bin")       end),
    awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox")       end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn("thunderbird")       end),
    awful.key({ modkey, "Shift"   }, "w", function () awful.util.spawn("uzbl-tabbed")       end),
--    awful.key({ modkey,           }, "c", function () awful.util.spawn("thunderbird")  end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("pcmanfm")       end),
    awful.key({ modkey,           }, "<", function () awful.util.spawn("dmenu_run -f -p 'Run command:' " .. dmenuopts) end), 
--    awful.key({ modkey, "Shift"   }, "f", function () awful.util.spawn("ls -l /etc/network.d | grep ^- | awk '{print $9}' | dmenu -p 'Select a network profile:'" .. dmenuopts) end), 
    awful.key({ modkey, "Shift"   }, "q", 
              function () 
                numsong = awful.util.pread("mpc playlist | nl -s ' ' | tr -s \" \" | dmenu " .. dmenuopts .. "| cut -d \" \" -f2")
                awful.util.spawn(numsong ~= "" and "mpc play " .. numsong or nil) 
              end), 
    awful.key({ modkey,           }, "q", 
              function () 
                choice = awful.util.pread("echo -e 'foobar\nlogout\nsuspend\nhalt\nreboot' | dmenu -f " .. dmenuopts)
                if     choice == "logout\n"   then awesome.quit()
                elseif choice == "halt\n" then awful.util.spawn("sudo halt")
                elseif choice == "reboot\n"   then awful.util.spawn("sudo reboot")
                elseif choice == "suspend\n"  then awful.util.spawn("sudo pm-suspend")
                else   choice = ""
                end
              end), 

-- || quelques commandes pour regler le volume
    awful.key({ modkey,           }, "v", function () awful.util.spawn("amixer -q sset PCM 2%+") end),
    awful.key({ modkey, "Shift"   }, "v", function () awful.util.spawn("amixer -q sset PCM 1%-") end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("amixer -q sset Master 2%+") end),
    awful.key({ modkey, "Shift"   }, "g", function () awful.util.spawn("amixer -q sset Master 1%-") end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("amixer -q sset Master toggle") end),
-- mpd/mpc est mon lecteur de musique
    awful.key({ modkey,           }, "n", function () awful.util.spawn("mpc next") end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey,           }, ",", function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey,  "Shift"  }, ",", function () awful.util.spawn("mpc stop") end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey,           }, "d", function () 
                                                naughty.config.presets.normal.position = naughty_coverart_position,
                                                coverart_show()
                                              end),
-- transset permet de modifier la transparence d'une fenêtre
    awful.key({ modkey,           }, "!", function () awful.util.spawn("transset-df -a --inc 0.1")  end),
    awful.key({ modkey, "Shift"   }, "!", function () awful.util.spawn("transset-df -a --dec 0.1") end),
-- Prompt normal (lancer une commande)
    awful.key({ modkey },            "Return",     function () mypromptbox[mouse.screen]:run() end),
-- Prompt lua
    awful.key({ modkey }, "r",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
-- afficher rapidement une page de manuel dans un terminal dedié
    awful.key({ modkey }, "F4", function ()
          awful.prompt.run({ prompt = "Manual: " }, mypromptbox[mouse.screen].widget,
              --  Use GNU Emacs for manual page display
              --  function (page) awful.util.spawn("emacsclient --eval '(manual-entry \"'" .. page .. "'\")'", false) end,
              --  Use the KDE Help Center for manual page display
              --  function (page) awful.util.spawn("khelpcenter man:" .. page, false) end,
              --  Use the terminal emulator for manual page display
                  function (page) awful.util.spawn("urxvt -e man " .. page, false) end,
                  function(cmd, cur_pos, ncomp)
                    local pages = {}
                    local m = 'IFS=: && find $(manpath||echo "$MANPATH") -type f -printf "%f\n"| cut -d. -f1'
                    local c, err = io.popen(m)
                    if c then while true do
                      local manpage = c:read("*line")
                      if not manpage then break end
                      if manpage:find("^" .. cmd:sub(1, cur_pos)) then
                          table.insert(pages, manpage)
                      end
                    end
                    c:close()
                    else io.stderr:write(err) end
                    if #cmd == 0 then return cmd, cur_pos end
                    if #pages == 0 then return end
                    while ncomp > #pages do ncomp = ncomp - #pages end
                    return pages[ncomp], cur_pos
                  end)
              end),
              awful.key({ altkey, "Shift"   }, "n",
                      function ()
                          local allclients = client.get(mouse.screen)

                          for _,c in ipairs(allclients) do
                              if c.minimized and c:tags()[mouse.screen] ==
              awful.tag.selected(mouse.screen) then
                                  c.minimized = false
                                  client.focus = c
                                  c:raise()
                                  return
                              end
                          end
                      end),
-- une calculatrice
    awful.key({ modkey }, "F6", function ()
          awful.prompt.run({  
            fg_cursor = "black",bg_cursor="red",
            prompt = "<span color='#00FF00'>Calc:</span> " }, mypromptbox[mouse.screen].widget, -- a green prompt
            function(expr)
                val = awful.util.pread("echo " .. expr .." | bc -l")
                naughty.notify({ text = expr .. ' = <span color="white">' .. val .. "</span>"--,
--                                 timeout = 10,hover_timeout = 0.5, width = 380, position = "bottom_right", screen = mouse.screen
                               })
                end,
                nil, awful.util.getdir("cache") .. "/calc")
              end),
    awful.key({ modkey }, "F8", function ()
        awful.prompt.run({ 
          fg_cursor = "black",bg_cursor="blue", prompt = " Ask: " }, 
          mypromptbox[mouse.screen].widget,
          function(expression)
            index = 1
            words={}
            sep = 0
            localequiv="font "
            localand="et "
            for word in expression:gmatch("%w+") 
            do 
              words[index]=word
              if word == "en" then sep = index end
              index= index+1
            end
            if index ~=1 and #words == sep + 1 then 
              if words[sep+1] == "C" then
                celsius = awful.util.pread("echo \"scale=2;(" .. words[1] .."-32)*5/9\" | bc -l")
                kelvin = celsius + 273.15
                answer = words[1].."°F "..localequiv..celsius:sub(1,#celsius-1).."°C\nand to "..kelvin.."°K"
              elseif words[sep+1] == "F" then
                farenheit = awful.util.pread("echo \"scale=2;(" .. words[1] .."*9/5)+32\" | bc -l")
                kelvin = words[1] + 273.15
                answer = words[1].."°C equals to "..farenheit:sub(1,#celsius-1).."°F\n"..localand..kelvin.."°K"
              elseif words[sep+1] == "km" then
                answer = words[1].." miles ".. localequiv..words[1]*1.609 .." km"
              elseif words[sep+1] == "miles" then
                answer = words[1].." km equals to ".. words[1]/1.609 .." miles"
              elseif words[sep+1] == "litres" then
                answer = words[1].." gallons ".. localequiv..words[1]*3.785 .." litres"
              elseif words[sep+1] == "gallons" then
                answer = words[1].." litres equals to ".. words[1]/3.785 .." gallons"
              elseif words[sep+1] == "kg" then
                answer = words[1].." lb ".. localequiv..words[1]*0.45359237 .." kg"
              elseif words[sep+1] == "lb" then
                answer = words[1].." kg equals to ".. words[1]/0.45359237 .." lb"
              elseif words[sep+1] == "sqm" then
                answer = words[1].." sq ft ".. localequiv..words[1]*0.09290304 .." mètres carrés"
              elseif words[sep+1] == "sqft" then
                answer = words[1].." mètres carrés equals to ".. words[1]/0.09290304 .." sq ft"
              elseif words[sep+1] == "ml" then
                answer = words[1].." ounce ".. localequiv..words[1]*28.4130625 .." ml"
              elseif words[sep+1] == "ounce" then
                answer = words[1].." ml ".. localequiv..words[1]/28.4130625 .." ounces"
              elseif words[sep+1] == "cm" then
                cm = words[1]*30.48+words[3]*2.54
                answer = words[1].." ft ".. words[3].." inches ".. localequiv..cm .." centimètres"
              elseif words[sep+1] == "imperial" then
                ft = (words[1]-(words[1]%30.48))/30.48
                inch = (words[1]%30.48)/2.54
                answer = words[1] .. " cm equals to ".. ft .. " feet and "..inch.." inches"
              end
            else
                answer = "problem with your input"
            end
                naughty.notify({ text = answer, width = 400})
          end,
          nil, awful.util.getdir("cache") .. "/convert") 
        end),
    awful.key({ modkey }, "F7", function ()
        awful.prompt.run({ 
          fg_cursor = "black",bg_cursor="orange", prompt = "<span color='#008DFA'>Dict:</span> " }, 
          mypromptbox[mouse.screen].widget,
          function(word)
                local f = io.popen("dict -d eng-fra " .. word .. " 2>&1")
                local fr = ""
                for line in f:lines() do
                fr = fr .. line .. '\n'
                end
                f:close()
                naughty.notify({ text = fr, timeout = 0, width = 400 })
          end,
          nil, awful.util.getdir("cache") .. "/dict") 
        end)
)

