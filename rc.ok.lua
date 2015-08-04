os.setlocale( os.getenv( 'LANG' ), 'time' )
-- Standard awesome library
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox     = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
--themedir = awful.util.getdir("config") .. "/themes/powerarrow-darker"
themedir = awful.util.getdir("config") .. "/themes/zenburn"
beautiful.init(themedir .. "/theme.lua")

-- Notification library
local naughty   = require("naughty")
require("naughtydefaults")
local menubar   = require("menubar")

local keydoc = require("keydoc")
require('awesompd/awesompd')
local vicious   = require("vicious")
local eminent   = require("eminent.eminent")
local ror       = require("runorraise.aweror")
local cal       = require("cal")
local dmenuhelpers = require("dmenu-helpers")
local unitconverter = require("unitconverter")

local lain = require("lain")
-- {{{ Wibox
markup = lain.util.markup
blue   = "#80CCE6"
space3 = markup.font("Tamsyn 3", " ")
space2 = markup.font("Tamsyn 2", " ")

dmenuhelpers.textexppath = "/home/raph/.textexp"
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fall back to
-- another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
  local fh = io.open(awful.util.getdir('config') .. '/awesomerror.log', 'w')
  naughty.notify({ preset = naughty.config.presets.critical,
                   title = "Oops, there were errors during startup!",
                   text = awful.util.linewrap(awesome.startup_errors) })
  fh:write(awesome.startup_errors..'\n')
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = awful.util.linewrap(err), screen = mouse.screen })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- {{ These are the power arrow dividers/separators }} --                          
arr1 = wibox.widget.imagebox()
arr1:set_image(beautiful.arr1)
arr2 = wibox.widget.imagebox()
arr2:set_image(beautiful.arr2)
arr3 = wibox.widget.imagebox()
arr3:set_image(beautiful.arr3)
arr4 = wibox.widget.imagebox()
arr4:set_image(beautiful.arr4)
arr5 = wibox.widget.imagebox()
arr5:set_image(beautiful.arr5)
arr6 = wibox.widget.imagebox()
arr6:set_image(beautiful.arr6)
arr7 = wibox.widget.imagebox()
arr7:set_image(beautiful.arr7)
arr8 = wibox.widget.imagebox()
arr8:set_image(beautiful.arr8)
arr9 = wibox.widget.imagebox()
arr9:set_image(beautiful.arr9)


arrl = wibox.widget.imagebox()                                                     
arrl:set_image(beautiful.arrl)                                                     
arrl_dl = wibox.widget.imagebox()                                                  
arrl_dl:set_image(beautiful.arrl_dl)                                               
arrl_ld = wibox.widget.imagebox()                                                  
arrl_ld:set_image(beautiful.arrl_ld)  


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

--
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.max.fullscreen,
    lain.layout.centerwork,
    lain.layout.termfair,
    --lain.layout.centerfair,
    awful.layout.suit.floating,
    lain.layout.rebrowse,
    awful.layout.suit.max,
    lain.layout.uselesstile,
    --awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    --lain.layout.cascadebrowse,
    --lain.layout.cascade,
    --lain.layout.cascadetile,
    --lain.layout.uselessfair,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.mirror,
}
lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1

lain.layout.centerfair.nmaster = 3
lain.layout.centerfair.ncol = 1

lain.layout.cascade.nmaster = 5
lain.layout.cascadetile.cascade_offset_x = 2
lain.layout.cascadetile.cascade_offset_y = 32
lain.layout.cascadetile.extra_padding = 5
lain.layout.cascadetile.nmaster = 5
lain.layout.ncol = 2
-- }}}

-- {{{ Wallpaper
--if beautiful.wallpaper then
    --for s = 1, screen.count() do
        --gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    --end
--end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({"work","web","mail","im","media","pdf","graph","root","term"}, s, { 
           layouts[11], 
           layouts[10], 
           layouts[10], 
           layouts[11], 
           layouts[11], 
           layouts[11], 
           layouts[1], 
           layouts[11], 
           layouts[11]})
  awful.tag.setproperty(tags[s][1], "mwfact", 0.62)
  awful.tag.setproperty(tags[s][2], "mwfact", 0.78)
  awful.tag.setproperty(tags[s][3], "mwfact", 0.67)
  awful.tag.setproperty(tags[s][4], "mwfact", 0.72)
  awful.tag.setproperty(tags[s][5], "mwfact", 0.67)
  awful.tag.setproperty(tags[s][7], "mwfact", 0.72)
  awful.tag.setproperty(tags[s][3], "mwfact", 0.70)

  awful.tag.setproperty(tags[s][1], "browsecol", 2)
  awful.tag.setproperty(tags[s][2], "browsecol", 2)
  awful.tag.setproperty(tags[s][3], "browsecol", 2)
  awful.tag.setproperty(tags[s][4], "browsecol", 2)
  awful.tag.setproperty(tags[s][5], "browsecol", 2)
  awful.tag.setproperty(tags[s][6], "browsecol", 2)
  awful.tag.setproperty(tags[s][7], "browsecol", 2)
  awful.tag.setproperty(tags[s][8], "browsecol", 2)
  awful.tag.setproperty(tags[s][9], "browsecol", 2)

     --awful.tag.seticon(themedir .. "/widgets/arch_10x10.png", tags[s][1])
     --awful.tag.seticon(themedir .. "/widgets/cat.png", tags[s][2])
     --awful.tag.seticon(themedir .. "/widgets/dish.png", tags[s][3])
     --awful.tag.seticon(themedir .. "/widgets/mail.png", tags[s][4])
     --awful.tag.seticon(themedir .. "/widgets/phones.png", tags[s][5])
     --awful.tag.seticon(themedir .. "/widgets/pacman.png", tags[s][6])
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mycomputermenu = {
   { "suspend", "sudo pm-suspend" },
   { "reboot", "sudo reboot" },
   { "shutdown", "sudo halt" }
}
myappsmenu = {
   { "firefox", function() awful.util.spawn("firefox") end},
   { "Firefox Marie", function() awful.util.spawn("firefox -P marie") end},
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
mythememenu = {}

function theme_load(theme)
   local cfg_path = awful.util.getdir("config")

   -- Create a symlink from the given theme to /home/user/.config/awesome/current_theme
   awful.util.spawn("ln -sfn " .. cfg_path .. "/themes/" .. theme .. " " .. cfg_path .. "/themes/current_theme")
   awesome.restart()
end

function theme_menu()
   -- List your theme files and feed the menu table
   local cmd = "ls -1 " .. awful.util.getdir("config") .. "/themes/"
   local f = io.popen(cmd)

   for l in f:lines() do
    local item = { l, function () theme_load(l) end }
    table.insert(mythememenu, item)
   end

   f:close()
end
-- Generate your table at startup or restart
theme_menu()

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/awesome.lua" },
   { "Theme", mythememenu },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}


mymainmenu = awful.menu.new({ items = { 
                                        { "Applications", myappsmenu },
                                        { "Terminal", terminal },
                                        { "Keyboard FR OSS", function() os.execute("setxkbmap fr oss") end},
                                        { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "Computer", mycomputermenu },
                                      }
                            })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

function manual_prompt()
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
end

function stickynote()
  awful.prompt.run({  
    bg_cursor = "yellow",
    prompt = "<span color='#FFFF00'>Note:</span> " }, mypromptbox[mouse.screen].widget,
    function(note)
        naughty.notify {
          bg            = "#FFFF00",
          fg            = "#000000",
          title         = "Note",
          text          = note,
          timeout       = 0, 
          hover_timeout = 1,
          --icon          = ico,
          --icon_size     = 150,
          width         = 700, 
          position      = "top_right", 
          screen        = mouse.screen
  }
    end,
    nil, awful.util.getdir("cache") .. "/note")
end

function menu_clients()
  awful.menu.menu_keys.down = { "Down", "Alt_L" }
  local cmenu = awful.menu.clients({width=230}, { keygrabber=true, coords={x=525, y=330} }) 
end

function coverart()
  naughty.config.presets.normal.position = naughty_coverart_position,
  coverart_show()
end

function lua_prompt()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
end


function calc_prompt()
  awful.prompt.run({  
    fg_cursor = "black",bg_cursor="red",
    prompt = "<span color='#00FF00'>Calc:</span> " }, mypromptbox[mouse.screen].widget, -- a green prompt
    function(expr)
        val = awful.util.pread("echo " .. expr .." | bc -l")
        naughty.notify({ screen = mouse.screen, text = expr .. ' = <span color="white">' .. val .. "</span>"--,
--                                 timeout = 10,hover_timeout = 0.5, width = 380, position = "bottom_right", screen = mouse.screen
                       })
        end,
        nil, awful.util.getdir("cache") .. "/calc")
end

function dict_prompt()
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
          naughty.notify({ text = fr, timeout = 0, width = 400, screen=mouse.screen })
    end,
    nil, awful.util.getdir("cache") .. "/dict") 
end

--
-- BEGIN OF AWESOMPD WIDGET DECLARATION

  musicwidget = awesompd:create() -- Create awesompd widget
  musicwidget.font = beautiful.font or "Liberation Mono" -- Set widget font 
--musicwidget.font_color = "#000000"	--Set widget font color
  --musicwidget.background = "#313131"	--Set widget background
  musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
  musicwidget.output_size = 25 -- Set the size of widget in symbols
  musicwidget.update_interval = 10 -- Set the update interval in seconds

  -- Set the folder where icons are located (change username to your login name)
  musicwidget.path_to_icons = "/home/raph/.config/awesome/awesompd/icons" 

  -- Set the default music format for Jamendo streams. You can change
  -- this option on the fly in awesompd itself.
  -- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
  musicwidget.jamendo_format = awesompd.FORMAT_MP3
  
  -- Specify the browser you use so awesompd can open links from
  -- Jamendo in it.
  musicwidget.browser = "firefox"

  -- If true, song notifications for Jamendo tracks and local tracks
  -- will also contain album cover image.
  musicwidget.show_album_cover = true

  -- Specify how big in pixels should an album cover be. Maximum value
  -- is 100.
  musicwidget.album_cover_size = 100
  
  -- This option is necessary if you want the album covers to be shown
  -- for your local tracks.
  musicwidget.mpd_config = "/home/raph/.mpd/mpd.conf"
  
  -- Specify decorators on the left and the right side of the
  -- widget. Or just leave empty strings if you decorate the widget
  -- from outside.
  musicwidget.ldecorator = " "
  musicwidget.rdecorator = " "

  -- Set all the servers to work with (here can be any servers you use)
  musicwidget.servers = {
     { server = "localhost",
          port = 6600 },
     { server = "192.168.0.72",
          port = 6600 }
  }

  -- Set the buttons of the widget. Keyboard keys are working in the
  -- entire Awesome environment. Also look at the line 352.
  musicwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, musicwidget:command_playpause() },
                  { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
               { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
               { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
               { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
               { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
                               { "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
                               { "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() },
                               { modkey, "Pause", musicwidget:command_playpause() } })

  musicwidget:run() -- After all configuration is done, run the widget

-- {{{ Wibox
space = wibox.widget.textbox()
space:set_text(' ')

-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %d %b %H:%M")
cal.register(mytextclock) --, '<span color='#FF0000'><b>%s</b></span>')
--clockicon = wibox.widget.imagebox()
--clockicon:set_image(beautiful.clock)

---{{---| Wifi Signal Widget |-------
neticon = wibox.widget.imagebox()
vicious.register(neticon, vicious.widgets.wifi, function(widget, args)
    local sigstrength = tonumber(args["{link}"])
    if sigstrength > 69 then
        neticon:set_image(beautiful.nethigh)
    elseif sigstrength > 40 and sigstrength < 70 then
        neticon:set_image(beautiful.netmedium)
    else
        neticon:set_image(beautiful.netlow)
    end
end, 120, 'wlp2s0')

--{{ Battery Widget }} --
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.baticon)

battwidget = wibox.widget.textbox()
vicious.register( battwidget, vicious.widgets.bat, '<span background="#92B0A0" font="Inconsolata 11"><span font="Inconsolata 11" color="#FFFFFF" background="#92B0A0">$1$2% </span></span>', 30, "BAT1" )

----{{--| Volume / volume icon |----------
volume = wibox.widget.textbox()

volumeicon = wibox.widget.imagebox()
vicious.register(volumeicon, vicious.widgets.volume, function(widget, args)
    local paraone = tonumber(args[1])

    if args[2] == "♩" or paraone == 0 then
        volumeicon:set_image(beautiful.mute)
    elseif paraone >= 67 and paraone <= 100 then
        volumeicon:set_image(beautiful.volhi)
    elseif paraone >= 33 and paraone <= 66 then
        volumeicon:set_image(beautiful.volmed)
    else
        volumeicon:set_image(beautiful.vollow)
    end

end, 0.3, "Master")

-- colours
coldef  = "</span>"
red  = "<span background='#ff0000'>"
white  = "<span color='#cdcdcd'>"
orange = "<span background='#ffa500' color='#000000'>"
green = "<span color='#87af5f'>"
--lightblue = "<span color='#7DC1CF'>"
--blue = "<span foreground='#1793d1'>"
--brown = "<span color='#db842f'>"
--fuchsia = "<span color='#800080'>"
--gold = "<span color='#e7b400'>"
--yellow = "<span color='#e0da37'>"
--lightpurple = "<span color='#eca4c4'>"
--azure = "<span color='#80d9d8'>"
--lightgreen = "<span color='#62b786'>"
--font = "<span font='Source Code Pro 10'>"

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat,
function(widget, args)
    if args[2]<=10 then
        return red .. args[1].. args[2] .."%" .. coldef 
    end
    if args[2]>10 and args[2]<24 then
        return orange .. args[1] .. args[2] .. "%" .. coldef 
    else
        return white .. args[1] .. args[2] .. "%" .. coldef
    end
end, 61, "BAT0")

--batwidget_text = wibox.widget.textbox()
--vicious.register(batwidget_text, vicious.widgets.bat, "$1$2%", 67, "BAT1")
--local batwidget = wibox.widget.background()
--batwidget:set_widget(batwidget_text)
--batwidget:set_bg("#df7401")

-- {{{ Volume
--volicon = wibox.widget.imagebox()
--volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, "$1%",2,"Master")
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q -c 1 sset Master toggle", false) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q -c 1 sset Master 2dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q -c 1 sset Master 2dB-", false) end),
    awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end) --,
))

--generalvolidget = wibox.widget.textbox() vicious.register(generalvolwidget, vicious.widgets.volume, "$1%",2,"PCM")
--generalvolwidget:buttons(awful.util.table.join( 
  --awful.button({ }, 1, function ()   awful.util.spawn("amixer -q sset Master toggle", false) end), 
  --awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
  --awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end), 
  --awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
--))
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
-- un clic-molette sur le nom d'une fenetre dans la barre des tâches et elle est
-- tuée
                     awful.button({  }, 2, function (c)
                                              c:kill()
                                          end),
                     awful.button({ modkey }, 1, function (c)
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

myscreennumber = wibox.widget.textbox()
if screen.count() == 1 then 
  text=""
else
  text=s.."/"..screen.count()
end
myscreennumber:set_text(text) 

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mylayoutbox[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    
    --right_layout:add(arrl_dl)
    --right_layout:add(musicwidget.widget)
    --right_layout:add(arrl_ld)
    ----right_layout:add(baticon)
    --right_layout:add(batwidget)
    --right_layout:add(arrl_dl)
    ----right_layout:add(volumeicon)
    --right_layout:add(volumewidget)
    --right_layout:add(arrl_ld)
    ----right_layout:add(clockicon)
    --right_layout:add(mytextclock)
    --right_layout:add(arrl_dl)
    --right_layout:add(myscreennumber)

    right_layout:add(space)
    right_layout:add(musicwidget.widget)
    right_layout:add(space)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(volumewidget)
    right_layout:add(space)
    right_layout:add(mytextclock)
    right_layout:add(space)
    right_layout:add(myscreennumber)

    if s == screen.count() then right_layout:add(wibox.widget.systray()) end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
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
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
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
    awful.key({ modkey,           }, "z", function () mymainmenu:toggle({keygrabber=true, coords={x=25, y=30} })        end),

    -- Layout manipulation
    keydoc.group("Layout manipulation"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end, "Swap with next window"),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end, "Swap with previous window"),
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

    awful.key({ modkey, }, "F1", keydoc.display),
    keydoc.group("Window manipulation"),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey,           }, "x", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn("urxvt -name \"slaveterm\"") end),
    awful.key({                   }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/marie/screenshots/ 2>/dev/null'") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    --awful.key({ modkey,           }, "a", revelation.revelation),
    awful.key({ modkey,           }, "<", function () dmenuhelpers.run()       end,"dmenu_run"), 
    awful.key({ modkey, "Control" }, "<", function () dmenuhelpers.netcfg()    end,"dmenu_netcfg"), 
    awful.key({ modkey, "Shift"   }, "<", function () menu_clients()           end,"open menu with applications"),
    awful.key({ modkey, "Control" }, "q", function () dmenuhelpers.mpd()       end), 
    awful.key({ modkey,           }, "q", function () dmenuhelpers.system()    end), 
    -- run or raise
    --awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox")       end),
    --awful.key({ modkey,           }, "s", function () awful.util.spawn("urxvt -name \"rootterm\" -e su root")       end),
    --
    awful.key({ modkey,           }, "c", function () awful.util.spawn("urxvt -e mutt") end),
    --awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn("urxvt -e newsbeuter") end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("nautilus")       end),

    awful.key({ modkey,           }, "v", function () awful.util.spawn("amixer -q -c 1 sset Master 2%+")    end),
    awful.key({ modkey, "Shift"   }, "v", function () awful.util.spawn("amixer -q -c 1 sset Master 1%-")    end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("amixer -q -c 1 sset Master toggle") end),
    awful.key({ modkey,           }, "n", function () awful.util.spawn("mpc next")                     end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.util.spawn("mpc prev")                     end),
    awful.key({ modkey,           }, ",", function () awful.util.spawn("mpc toggle")                   end),
    awful.key({ modkey,  "Shift"  }, ",", function () awful.util.spawn("mpc stop")                     end),
    awful.key({ modkey, "Shift"   }, "w", function () awful.util.spawn("urxvtc -e ncmpcpp")            end),
    --awful.key({ modkey, "Shift"   }, "s", function () awful.util.spawn("luakit http://ticktick.com")   end),
    awful.key({ modkey, "Control" }, "w", function () dmenuhelpers.switchapp()                         end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("xscreensaver-command -lock")   end),
    --awful.key({ modkey,           }, "d", awful.tag.history.restore),
    awful.key({ modkey, "Shift"   }, "d", function () coverart()                                       end),
---- transset permet de modifier la transparence d'une fenêtre
    awful.key({ modkey,           }, "!", function () awful.util.spawn("transset-df -a --inc 0.1")     end),
    awful.key({ modkey, "Shift"   }, "!", function () awful.util.spawn("transset-df -a --dec 0.1")     end),
-- Prompts
    awful.key({ modkey }, "Return", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "r",      function () lua_prompt()                    end),
    awful.key({ modkey }, "F3",     function () dmenuhelpers.expandtext()       end),
    awful.key({ modkey }, "F4",     function () unitconverter.manual_prompt()   end),
    awful.key({ modkey }, "F5",     function () dmenuhelpers.pwsafe()           end),
    awful.key({ modkey }, "F6",     function () calc_prompt()                   end),
    awful.key({ modkey }, "F7",     function () dict_prompt()                   end),
    awful.key({ modkey }, "F8",     function () unitconverter.prompt()          end),
    awful.key({ modkey }, "F9",     function () stickynote()                    end),
    awful.key({ modkey }, "Menu",   function () dmenuhelpers.run()              end),

    awful.key({  }, "XF86MonBrightnessUp", function ()  awful.util.spawn("xbacklight -inc 10")  end),
    awful.key({  }, "XF86MonBrightnessDown", function ()  awful.util.spawn("xbacklight -dec 10")  end),

    awful.key({  }, "XF86KbdBrightnessUp", function ()  awful.util.spawn("kbdlight up")  end),
    awful.key({  }, "XF86KbdBrightnessDown", function ()  awful.util.spawn("kbdlight down")  end),

    awful.key({  }, "XF86AudioPrev", function ()  awful.util.spawn("mpc prev")  end),
    awful.key({  }, "XF86AudioNext", function ()  awful.util.spawn("mpc next")  end),
    awful.key({      }, "XF86Mail", function ()  awful.util.spawn("urxvt -e mutt")  end)
    --awful.key({  }, "XF86HomePage", function ()  awful.util.spawn("firefox")    end),
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
    awful.key({ modkey, "Control" }, "Return", function (c) 
      c:swap(awful.client.getmaster())
      --naughty.notify({ text = awful.client.getmaster().name, timeout = 0, width = 400, screen=mouse.screen })
    end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

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
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- generate and add the 'run or raise' key bindings to the globalkeys table
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))
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
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons },
      --callback = awful.client.setslave
    },
   { rule = { name = "Matplotlib"}, properties = { }, callback = not awful.client.setslave },
-- permet d'assigner à chaque aplication un tag -> firefox toujours sur le tag
-- 2, skype/msn sur le 4, les pdf sur le 6, gimp sur le 7, etc. -> d'ou les noms
-- donnés aux tags, cf début de ce fichier.
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    --{ rule = { class = "mplayer" },
      --properties = { tag = tags[screen.count()][5], switchtotag = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[screen.count()][2] } },
    { rule = { name = "Redshiftgui" },
      properties = { floating = true               } },
    { rule = { name = "pomodairo" },
      properties = { floating = true, sticky =true } },
    { rule = { class = "Animate" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Hotot" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Instantbird" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Acroread" },
      properties = { tag = tags[screen.count()][6], switchtotag = true } },
    { rule = { class = "Epdfview" },
      properties = { tag = tags[screen.count()][6], switchtotag = true } },
    { rule = { class = "Zathura" },
      properties = { tag = tags[screen.count()][6], switchtotag = true } },
    { rule = { class = "dclock" },
      properties = { screen = 1 } },
    { rule = { class = "Conky" },
      properties = { screen = 1 } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "Wicd" },
      properties = { tag = tags[screen.count()][8], switchtotag = true } },
    { rule = { name = "mutt" },
      properties = { tag = tags[screen.count()][3], switchtotag = true } },
    { rule = { class = "Evince" },
      properties = { tag = tags[screen.count()][6], switchtotag = true } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[screen.count()][3] } },
    { rule = { class = "feh" },
      properties = { tag = tags[screen.count()][4],switchtotag = true  } },
    { rule = { class = "Chromium" }, except = { name = "crx_eempgbpnkjnacmilmobpbhbfpdjdcpgd"},
      properties = { tag = tags[screen.count()][5], switchtotag = true } },
    { rule = { role = "app" },
      properties = { tag = tags[screen.count()][9] } },
    { rule = { class = "Inkscape" },
      properties = { tag = tags[screen.count()][7] } },
    { rule = { name = "alsamixer" },
      properties = { tag = tags[screen.count()][8], switchtotag = true } },
    { rule = { name = "newsbeuter" },
      properties = { tag = tags[screen.count()][4], switchtotag = true } },
    { rule = { instance = "rootterm" },
      properties = { tag = tags[screen.count()][8], switchtotag = true } },
    { rule = { name = "ncmpcpp" },
      properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class = "Deluge" },
      properties = { tag = tags[screen.count()][5] } },
    { rule = { class = "Scribus" },
      properties = { tag = tags[screen.count()][7] } },
    { rule = { class = "LibreOffice" },
      properties = { tag = tags[screen.count()][6], floating = false, switchtotag = true, maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Gorilla" },
      properties = { tag = tags[screen.count()][7], switchtotag = true, floating = true } },
    { rule = { class = "Openshot" },
      properties = { tag = tags[screen.count()][7], floating = false } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[screen.count()][7], floating = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        if c.instance == "slaveterm" then
          awful.client.setslave(c)
        end

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
