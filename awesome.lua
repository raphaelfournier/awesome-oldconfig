-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("revelation")
--require("wicked")
require("vicious")
require("vicious.contrib")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
local home   = os.getenv("HOME")
beautiful.init(home .. "/.config/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
--terminal = "urxvt"
--terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

os.setlocale( os.getenv( 'LANG' ), 'time' )
local exec = awful.util.spawn
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
--    awful.layout.suit.tile,                  --1
--    awful.layout.suit.tile.left,             --2
--    awful.layout.suit.tile.bottom,           --3
--    awful.layout.suit.tile.top,              --4
--    awful.layout.suit.fair,                  --5
--    awful.layout.suit.fair.horizontal,       --6 
--    awful.layout.suit.spiral,                --7
--    awful.layout.suit.spiral.dwindle,        --8
--    awful.layout.suit.max,                   --9
--    awful.layout.suit.max.fullscreen,        --10
--    awful.layout.suit.magnifier,             --11
--    awful.layout.suit.floating               --12
    awful.layout.suit.tile,--1
    awful.layout.suit.max,         --2
    awful.layout.suit.tile.left,         --3
    awful.layout.suit.tile.top,         --4
    awful.layout.suit.floating,         --5
    awful.layout.suit.fair,            --6
    awful.layout.suit.fair.horizontal,         --7
    awful.layout.suit.spiral,                 --8
    awful.layout.suit.spiral.dwindle,         --9
    awful.layout.suit.magnifier,             --10
    awful.layout.suit.max.fullscreen,         --11
    awful.layout.suit.tile.bottom           --12
}
-- }}}

-- {{{ Tags
tags = {
names={"1","2","3","4","5","6","7","8"},
layout = { layouts[1], --1 
           layouts[2], --2 
           layouts[1], --3 
           layouts[1], --4 
           layouts[6], --5 
           layouts[2], --6 
           layouts[5], --7 
           layouts[1]}--8
}

for s = 1, screen.count() do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  awful.tag.setproperty(tags[s][2], "mwfact", 0.62)
  awful.tag.setproperty(tags[s][3], "mwfact", 0.62)
  awful.tag.setproperty(tags[s][4], "mwfact", 0.62)
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/awesome.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
myappsmenu = {
   { "firefox", function() awful.util.spawn("firefox") end},
   { "thunderbird", function() awful.util.spawn("thunderbird") end},
   { "emesene", function() awful.util.spawn("emesene") end},
   { "pidgin", function() awful.util.spawn("pidgin") end},
   { "skype", function() awful.util.spawn("skype") end},
   { "deluge", function() awful.util.spawn("deluge") end},
   { "gqview", function() awful.util.spawn("gqview") end},
   { "pcmanfm", function() awful.util.spawn("pcmanfm") end},
   { "mpc", function() awful.util.spawn("mpc toggle") end},
   { "vlc", function() awful.util.spawn("vlc") end},
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "apps", myappsmenu },
                                        { "open terminal", terminal },
                                        { "reboot", "sudo reboot" },
                                        { "shutdown", "sudo halt" }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}


-- {{{ Widgets
spacesep = widget({ type = "textbox"})
barsep = widget({ type = "textbox"})
spacesep.text = " "
barsep.text = "|"
--
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 67, "BAT0")
batwidget2 = widget({ type = "textbox" })
vicious.register(batwidget2, vicious.widgets.bat, "$1$2%", 67, "BAT1")
--
--Pulse Audio widget
vol= widget({ type = "textbox" })
vicious.register(vol, vicious.contrib.pulse, "$1%", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
vol:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end),
  awful.button({ }, 4, function () vicious.contrib.pulse.add(5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end),
  awful.button({ }, 5, function () vicious.contrib.pulse.add(-5,"alsa_output.pci-0000_00_1b.0.analog-stereo") end)
))

volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1%",2,"PCM")
volwidget:buttons(
 awful.util.table.join(
 awful.button({ }, 1, function () exec("aumix") end),
 awful.button({ }, 2, function () exec("amixer -q sset PCM toggle") end),
 awful.button({ }, 4, function () exec("amixer -q sset PCM 2dB+") end),
 awful.button({ }, 5, function () exec("amixer -q sset PCM 2dB-") end)
 )
)
generalvolwidget = widget({ type = "textbox" })
vicious.register(generalvolwidget, vicious.widgets.volume, "$1%",2,"Master")
generalvolwidget:buttons(awful.util.table.join(
 awful.button({ }, 1, function () exec("aumix") end),
 awful.button({ }, 2, function () exec("amixer -q sset Master toggle") end),
 awful.button({ }, 4, function () exec("amixer -q sset Master 2dB+") end),
 awful.button({ }, 5, function () exec("amixer -q sset Master 2dB-") end)
 )
)
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


require("awesompd.awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
musicwidget.font = "Inconsolata Medium 12" -- Set widget font 
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 4 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/raph/.config/awesome/awesompd/icons" 
musicwidget.mpd_config = "/home/raph/.mpd/mpd.conf"
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks will also contain
-- album cover image.
instance.show_jamendo_album_covers = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
instance.album_cover_size = 150
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = " "
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
   { server = "localhost",
        port = 6600 },
--     { server = "192.168.0.72",
--          port = 6600 } 
}
-- Set the buttons of the widget
musicwidget:register_buttons({ { "", awesompd.MOUSE_MIDDLE, musicwidget:command_toggle() },
                               { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_next_track() },
                               { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_prev_track() },
                               { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
                               { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
                               { "", awesompd.MOUSE_LEFT, musicwidget:command_show_menu() },
                               { "", awesompd.MOUSE_RIGHT, musicwidget:command_stop() } })
musicwidget:run() -- After all configuration is done, run the widget
----
---- {{{ Mail 
mailwidget0 = widget({ type = "textbox" })
vicious.register(mailwidget0, vicious.widgets.mdir, '<span color="#87af87">RF</span> $1', 61, {home ..  "/Mail/Rfnet/INBOX"})
--mailwidget0:buttons(awful.util.table.join(
--  awful.button({ }, 1, function () exec("urxvt -T Mutt -e mutt") end)
--))

mailwidget1 = widget({ type = "textbox" })
vicious.register(mailwidget1, vicious.widgets.mdir, '<span color="#87af87">LB</span> $1', 61, {home ..  "/Mail/Lavabit/Inbox"})

mailwidget2 = widget({ type = "textbox" })
vicious.register(mailwidget2, vicious.widgets.mdir, '<span color="#d78787">LIP6</span> $1', 61, {home ..  "/Mail/Lip6/INBOX"})
--
weatherwidget = widget({ type = "textbox" })
vicious.register(weatherwidget, vicious.widgets.weather, '<span color="#dfaf8f">${tempc}°C</span>', 307, "LFPO")
--weatherwidget:add_signal("mouse::enter", function() weather_popup() end)
--weatherwidget:add_signal("mouse::leave", function() weather_popdown() end)

--function weather_popup()
--        table = vicious.widgets.weather(nil,"LFPO")
--        toto=awful.util.pread("weather -i LFPO")
--        bla = naughty.notify({
--          text = toto,
--          timeout = 0, hover_timeout = 0.5,
--          width = 380, position = "top_right", screen = mouse.screen
--        })
--end
--
--function weather_popdown()
--  naughty.destroy(bla)
--  bla = nil
--end
----
--
----todowidget = widget({ type = "textbox" })
----todowidget.text=string.format('<span color="#8cd0d3">TODO</span>')
----todowidget:add_signal("mouse::enter", function() todo_popup()                        
----        end)
----todowidget:add_signal("mouse::leave", function() remove_todo()                        
----        end)
----
----function todo_popup()
----         local todo = awful.util.pread("/usr/bin/lite2do list")
----         popuptodo = naughty.notify({
----           text = todo,
----           timeout = 10, hover_timeout = 1,
----           width = 500, position = "bottom_right", screen = mouse.screen
----         })
----end
----function remove_todo()
----   naughty.destroy(popuptodo)
----   popuptodo = nil
----end
--
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, '<span color="#60b48a">%a %d %b %R</span>', 61)

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

naughty_default_position = "top_right"
naughty_coverart_position = "bottom_left"

local coverart_nf
function coverart_show()
  local img = awful.util.pread("/home/raph/scripts/coverart.sh")
  local foo = awful.util.pread("mpc status")
  local ico = image(img)
  coverart_nf = naughty.notify({
           icon = ico,
           text = foo,
           icon_size = 150,
           timeout = 10, hover_timeout = 1,
           width = 500, position = "top_right", screen = mouse.screen
  })
end

-- Second wibox widgets
--wifiwidget = widget({ type = "textbox" })
--vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid} ${sign}", 67, "wlan0")
--
--function birthdays_popup()
--         local birthdays = awful.util.pread("/usr/bin/birthday -W45")
--         popupbirthdays = naughty.notify({
--           text = birthdays,
--           timeout = 10, hover_timeout = 1,
--           width = 400, position = "bottom_right", screen = mouse.screen
--         })
--end
--function remove_birthdays()
--   naughty.destroy(popupbirthdays)
--   popuptodo = nil
--end
--
--birthdayswidget = widget({ type = "textbox" })
--birthdayswidget.text=awful.util.pread("/usr/bin/birthday -W45 | head -n1 ")
----string.format('<span color="#8cd0d3">birthdays</span>')
--birthdayswidget:add_signal("mouse::enter", function() birthdays_popup() end)
--birthdayswidget:add_signal("mouse::leave", function() remove_birthdays() end)

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
--secwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
-- un clic-molette sur le nom d'une fenetre dans la barre des tâches et elle est
-- tuée
                     awful.button({ }, 2, function (c)
                                              c:kill()
                                          end),
-- permet à une fenetre d'être toujours sur le bureau courant                                          
                     awful.button({ modkey }, 2, function (c)
                                              if c.sticky == false then
                                                c.sticky = true
                                              else
                                                c.sticky = false
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
--    secwibox[s] = awful.wibox({ position = "bottom", screen = s })
--    secwibox[s].widgets = {
--        wifiwidget,spacesep,barsep,
--        spacesep,todowidget,spacesep,barsep,
--        spacesep,birthdayswidget,
--        layout = awful.widget.layout.horizontal.leftright
--    }
--    secwibox[s].visible = false
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mylayoutbox[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        datewidget,
        spacesep,batwidget,
        spacesep,batwidget2,
        spacesep,weatherwidget,
        spacesep,
        --barsep,
        --spacesep,
        generalvolwidget,spacesep,volwidget,
--        spacesep,vol,
        --spacesep,
        --barsep,
        spacesep,mailwidget0,
        spacesep,mailwidget1,
        spacesep,mailwidget2,
--        spacesep,barsep,
--        spacesep,
--        mpdwidget,
        musicwidget.widget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
val=nil
-- {{{ Key bindings
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
-- ||avec le toggle(true) ci-dessous, on permet la navigation avec le clavier dans le menu 
    awful.key({ modkey,           }, "z", function () mymainmenu:toggle(true)        end),

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
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal,false) end),
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
    awful.key({ modkey, "Shift"   }, "w", function () awful.util.spawn("uzbl-tabbed")       end),
--    awful.key({ modkey,           }, "c", function () awful.util.spawn("thunderbird")  end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("pcmanfm")       end),
-- || dmenu permet d'avoir une liste de toutes les applications dans le $PATH et de
-- les lancer en ne saisissant que les premieres lettres
--    awful.key({ modkey,           }, "<", function () awful.util.spawn("sh /home/raph/scripts/dmenu.sh")       end),
    awful.key({ modkey,           }, "<", function () awful.util.spawn("dmenu_run -i -b -f -p 'Run command:' -nb '" .. beautiful.border_focus .. "' -nf '" .. beautiful.bg_normal .. "' -sb '" .. beautiful.bg_normal .. "' -sf '" .. beautiful.fg_urgent .. "' -fn '-*-liberation mono-*-r-*-*-*-120-*-*-*-*-*-*'") end), 

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
--    awful.key({ modkey, "Shift"   }, "<", function () secwibox[mouse.screen].visible = not secwibox[mouse.screen].visible      end),
    awful.key({ modkey, "Shift" }, "<", function () awful.util.spawn("dnetcfg -i -b -nb '" .. "#506070" .. "' -nf '" .. beautiful.fg_normal .. "' -sb '" .. beautiful.border_focus .. "' -sf '" .. beautiful.border_normal .. "'")      end),
-- transset permet de modifier la transparence d'une fenêtre
    awful.key({ modkey,           }, "!", function () awful.util.spawn("transset-df -a --inc 0.1")  end),
    awful.key({ modkey, "Shift"   }, "!", function () awful.util.spawn("transset-df -a --dec 0.1") end),
-- permet d'afficher rapidement des infos
    awful.key({ modkey,           }, "t", function () todo_popup() end),
    awful.key({ modkey,           }, "y", function () birthdays_popup() end),
    awful.key({ modkey, "Shift"   }, "t", function () mpd_popup() end),
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
-- une calculatrice
    awful.key({ modkey }, "F6", function ()
          awful.prompt.run({  
            fg_cursor = "black",bg_cursor="red",
            prompt = "<span color='#00A5AB'>Calc:</span> " }, mypromptbox[mouse.screen].widget,
            function(expr)
                val = awful.util.pread("echo " .. expr .." | bc -l")
                naughty.notify({ text = expr .. ' = <span color="white">' .. val .. "</span>",
                                 timeout = 0,hover_timeout = 0.5,
                                 width = 380, position = "top_left", screen = mouse.screen
                               })
                end,
                nil, awful.util.getdir("cache") .. "/calc")
              end)
)

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
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey, "Shift"   }, "o",      function (c) c.sticky = not c.sticky    end),
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
--    awful.button({ modkey }, 4, function () awful.util.spawn("transset-df -a --inc 0.1")  end),
--    awful.button({ modkey }, 5, function () awful.util.spawn("transset-df -a --dec 0.1")  end)
    )

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     size_hints_honor = false,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
-- permet d'assigner à chaque aplication un tag -> firefox toujours sur le tag
-- 2, skype/msn sur le 4, les pdf sur le 6, gimp sur le 7, etc. -> d'ou les noms
-- donnés aux tags, cf début de ce fichier.
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Uzbl-tabbed" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Minefield" },
    properties = { tag = tags[1][2] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Pino" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Hotot" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Acroread" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "Epdfview" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "Zathura" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "Evince" },
      properties = { tag = tags[1][6] } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][7], floating = true } },
}
-- }}}

-- {{{ Signals
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

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not startup then
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- un script que je lance après le chargement du WM
--exec("urxvtc -e sh scripts/demarrage.sh")
--exec("xterm -e lite2do ls | less")
--exec("xterm -e birthday -W40 | less")
