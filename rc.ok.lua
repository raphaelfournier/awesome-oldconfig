-- Standard awesome library
os.setlocale( os.getenv( 'LANG' ), 'time' )
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox     = require("wibox")
require('awesompd/awesompd')
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty   = require("naughty")
local vicious   = require("vicious")
local menubar   = require("menubar")
local eminent   = require("eminent.eminent")
local ror       = require("runorraise.aweror")
local cal       = require("cal")

naughty.config.defaults.screen           = screen.count()
naughty.config.defaults.timeout          = 10
naughty.config.defaults.hover_timeout    = 0.5
naughty.config.defaults.position         = "bottom_right"
naughty.config.defaults.height           = 150
naughty.config.defaults.margin           = 4
naughty.config.defaults.width            = 800
naughty.config.defaults.gap              = 10
naughty.config.defaults.ontop            = true
naughty.config.defaults.font             = beautiful.notifyfont or "Inconsolata Medium 14"
naughty.config.defaults.icon             = nil
naughty.config.defaults.icon_size        = 16
naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
naughty.config.defaults.border_width     = 1
naughty.config.presets.low.bg                  = '#506070'
naughty.config.presets.low.fg                  = '#f0dfaf'
naughty.config.presets.low.border_color        = beautiful.border_focus or '#535d6c'
naughty.config.presets.critical.bg             = '#882222'
naughty.config.presets.critical.fg             = '#dcdccc'
naughty.config.presets.critical.width          = 400
naughty.config.presets.critical.height         = 100
naughty.config.presets.critical.border_color   = beautiful.border_focus or '#535d6c'

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
themedir = awful.util.getdir("config") .. "/themes/zenburn"
beautiful.init(themedir .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

dmenuopts = "-b -i -nf '"..beautiful.fg_normal.."' -nb '"..beautiful.bg_normal.."' -sf '"..beautiful.bg_urgent.."' -sb '"..beautiful.bg_focus.."' -fn '-*-dejavu sans mono-*-r-*-*-*-*-*-*-*-*-*-*'"
--dmenuopts= "-b -i -nf '"..beautiful.fg_normal.."' -nb '"..beautiful.bg_normal.."' -sf '"..beautiful.fg_urgent.."' -sb '"..beautiful.bg_focus.."' -fn '-*-liberation mono-*-r-*-*-*-120-*-*-*-*-*-*'"

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
    awful.layout.suit.floating,
    awful.layout.suit.max
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.mirror,
}
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
           layouts[8], 
           layouts[8], 
           layouts[8], 
           layouts[8], 
           layouts[8], 
           layouts[8], 
           layouts[1], 
           layouts[8], 
           layouts[1]})
  awful.tag.setproperty(tags[s][1], "mwfact", 0.72)
  awful.tag.setproperty(tags[s][2], "mwfact", 0.72)
  awful.tag.setproperty(tags[s][3], "mwfact", 0.54)
  awful.tag.setproperty(tags[s][4], "mwfact", 0.62)
  awful.tag.setproperty(tags[s][7], "mwfact", 0.72)

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

function rorapps()
    local f_reader = io.popen( "dmenu_run -b -nb '".. beautiful.bg_normal .."' -nf '".. beautiful.fg_normal .."' -sb '#955'")
    local command = assert(f_reader:read('*a'))
    f_reader:close()
    if command == "" then return end

    -- Check throught the clients if the class match the command
    local lower_command=string.lower(command)
    for k, c in pairs(client.get()) do
        local class=string.lower(c.class)
        naughty.notify {
          text          = class,
          width         = 700, 
          position      = "top_right", 
          screen        = mouse.screen
        }
        if string.match(class, lower_command) then
            for i, v in ipairs(c:tags()) do
                awful.tag.viewonly(v)
                c:raise()
                c.minimized = false
                return
            end
        end
    end
    awful.util.spawn(command)
end

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

function pomodorotask()
  awful.prompt.run({  
    bg_cursor = "#880000",
    prompt = "Todo : " }, mypromptbox[mouse.screen].widget,
    function(pomodotask)
        naughty.notify {
          bg            = "#880000",
          fg            = "#ffffff",
          title         = "Tâche",
          text          = pomodotask,
          timeout       = 0, 
          hover_timeout = 4,
          --icon          = ico,
          --icon_size     = 150,
          width         = 280, 
          position      = "top_right", 
          screen        = mouse.screen
  }
    end,
    nil, awful.util.getdir("cache") .. "/pomodotask")
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

pomodoro = {}
-- tweak these values in seconds to your liking
pomodoro.pause_duration = 60*5
pomodoro.work_duration = 60*25

pomodoro.pause_title = "Pause terminée."
pomodoro.pause_text = "On se remet au travail !"
pomodoro.work_title = "Pomodoro terminé."
pomodoro.work_text = "Une petite pause !"
pomodoro.working = true
pomodoro.left = pomodoro.work_duration
pomodoro.widget = wibox.widget.textbox()
pomodoro.timer = timer { timeout = 1 }

function pomodoro:settime(t)
  if t >= 3600 then -- more than one hour!
    t = os.date("%X", t-3600)
  else
    t = os.date("%M:%S", t)
  end
  self.widget.bg= "#880000"
  self.widget.text = string.format('<b>%s</b>', t)
  --self.widget.text = string.format('<span color="' .. beautiful.fg_normal .. '"><b>%s</b></span>', t)
end

function pomodoro:notify(title, text, duration, working)
  local ico = image(awful.util.getdir("config") .. "/pomodoro.png")
  naughty.notify {
    bg = "#880000",
    fg = "#ffffff",
    title = title,
    text = text,
    timeout = 10, hover_timeout = 1,
    icon = ico,
    icon_size = 150,
    width = 700, position = "bottom_left", screen = mouse.screen
  }

  pomodoro.left = duration
  pomodoro:settime(duration)
  pomodoro.working = working
end

pomodoro:settime(pomodoro.work_duration)

pomodoro.widget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function()
      pomodoro.last_time = os.time()
      pomodoro.timer:start()
    end),
    awful.button({ }, 2, function()
      pomodoro.timer:stop()
    end),
    awful.button({ }, 3, function()
      pomodoro.timer:stop()
      pomodoro.left = pomodoro.work_duration
      pomodoro:settime(pomodoro.work_duration)
    end)
))

pomodoro.timer:connect_signal("timeout", function()
  local now = os.time()
  pomodoro.left = pomodoro.left - (now - pomodoro.last_time)
  pomodoro.last_time = now

  if pomodoro.left > 0 then
    pomodoro:settime(pomodoro.left)
  else
    if pomodoro.working then
      pomodoro:notify(pomodoro.work_title, pomodoro.work_text,
        pomodoro.pause_duration, false)
    else
      pomodoro:notify(pomodoro.pause_title, pomodoro.pause_text,
        pomodoro.work_duration, true)
    end
    pomodoro.timer:stop()
  end
end)

function menu_clients()
  awful.menu.menu_keys.down = { "Down", "Alt_L" }
  local cmenu = awful.menu.clients({width=230}, { keygrabber=true, coords={x=525, y=330} }) 
end

function dmenu_command() 
  awful.util.spawn("dmenu_run -f -p 'Run command:' " .. dmenuopts) 
end

function dmenu_netcfg() 
  netcfgprofile = awful.util.pread("find /etc/network.d/ -type f | grep -v examples | cut -d \"/\" -f 4 | dmenu " .. dmenuopts)
  awful.util.spawn(netcfgprofile ~= "" and "sudo netcfg -r " .. netcfgprofile or nil) 
end 

function dmenu_mpd() 
  numsong = awful.util.pread("mpc playlist | nl -s ' ' | tr -s \" \" | dmenu -l 10 " .. dmenuopts .. "| cut -d \" \" -f2")
  awful.util.spawn(numsong ~= "" and "mpc play " .. numsong or nil) 
end 

function dmenu_system() 
  choice = awful.util.pread("echo -e ' \nlogout\nsuspend\nhalt\nreboot\nquitlab\nmorninglab' | dmenu -p 'System' -f " .. dmenuopts)
  if     choice == "logout\n"   then awesome.quit()
  elseif choice == "halt\n"     then awful.util.spawn("sudo halt")
  elseif choice == "reboot\n"   then awful.util.spawn("sudo reboot")
  elseif choice == "suspend\n"  then awful.util.spawn("sudo pm-suspend")
  elseif choice == "quitlab\n"  then awful.util.spawn("xrandr --output VGA1 --off && sudo pm-suspend")
  elseif choice == "morninglab\n"  then awful.util.spawn("sh /home/raph/scripts/ecran-dell24.sh")
  else   choice = ""
  end
end 

function coverart()
  naughty.config.presets.normal.position = naughty_coverart_position,
  coverart_show()
end

function raiseapp()
  local allclients = client.get(mouse.screen)
  clientsline = ""
  for _,c in ipairs(allclients) do
    clientsline = clientsline .. c.name .. "\n"
  end
  selected = awful.util.pread("echo '".. clientsline .."' | dmenu -l 10 " .. dmenuopts)
  for _,c in ipairs(allclients) do
    if c.name == selected:gsub("\n", "") then
      for i, v in ipairs(c:tags()) do
        awful.tag.viewonly(v)
        client.focus = c
        c:raise()
        c.minimized = false
        return
      end
    end
  end
end

function raise_all()
  local allclients = client.get(mouse.screen)
  for _,c in ipairs(allclients) do
      if c.minimized and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
          c.minimized = false
          client.focus = c
          c:raise()
          return
      end
  end
end

function lua_prompt()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
end

function textexp_prompt()
  textexpfile = "/home/raph/.textexp"
  service = awful.util.pread("cat "..textexpfile.." | grep -v ^# | cut -d: -f1 | dmenu -l 10 " .. dmenuopts)
  linetextexp = awful.util.pread("cat "..textexpfile.." | grep -i -m1 "..service):gsub("\n", "")
  --login = awful.util.pread("echo " .. linetextexp .. " | cut -d: -f2"):gsub("\n", "")
  textexp = awful.util.pread("echo " .. linetextexp .. " | cut -d: -f2"):gsub("\n", "")
  if textexp ~= "\n" and textexp ~= "" then
    naughty.notify({ text = "service : "..service, width = 400, screen = mouse.screen})
    selectcommand = "echo '" .. textexp .. "' | xsel -i"
    awful.util.spawn_with_shell(selectcommand,false)
  end
end

function pwd_prompt()
  pwdpath = "/home/raph/.pwd"
  pwdfile = awful.util.pread("cat "..pwdpath):gsub("\n", "")
  service = awful.util.pread("cat "..pwdfile.." | grep -v ^# | cut -d: -f1 | dmenu " .. dmenuopts)
  linepwd = awful.util.pread("cat "..pwdfile.." | grep -i -m1 "..service):gsub("\n", "")
  login = awful.util.pread("echo " .. linepwd .. " | cut -d: -f2"):gsub("\n", "")
  pwd = awful.util.pread("echo " .. linepwd .. " | cut -d: -f3"):gsub("\n", "")
  if login ~= "\n" and login ~= "" then
    naughty.notify({ text = "service : "..service.."login : "..login, width = 400, screen = mouse.screen})
    selectcommand = "echo '" .. pwd .. "' | xsel -i"
    awful.util.spawn_with_shell(selectcommand,false)
  end
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

function converter_prompt()
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
        elseif words[sep+1] == "m2" then
          answer = words[1].." sq ft ".. localequiv..words[1]*0.09290304 .." mètres carrés"
        elseif words[sep+1] == "sqft" then
          answer = words[1].." mètres carrés equals to ".. words[1]/0.09290304 .." sq ft"
        elseif words[sep+1] == "ml" then
          answer = words[1].." ounce ".. localequiv..words[1]*28.4130625 .." ml"
        elseif words[sep+1] == "ounce" then
          answer = words[1].." ml ".. localequiv..words[1]/28.4130625 .." ounces"
        elseif words[sep+1] == "eur" then
          answer = words[1].." usd ".. localequiv..words[1]/1.35870 .." euros"
        elseif words[sep+1] == "usd" then
          answer = words[1].." eur ".. localequiv..words[1]*1.35870 .." US dollars"
        elseif words[sep+1] == "cm" then
          cm = words[1]*30.48+words[3]*2.54
          answer = words[1].." ft ".. words[3].." inches ".. localequiv..cm .." centimètres"
        elseif words[sep+1] == "imperial" then
          ft = (words[1]-(words[1]%30.48))/30.48
          inch = (words[1]%30.48)/2.54
          answer = words[1] .. " cm equals to ".. ft .. " feet and "..inch.." inches"
        end
      else
          answer = "problem with your input. #words="..#words
      end
          naughty.notify({ text = answer, width = 400, screen=mouse.screen})
    end,
    nil, awful.util.getdir("cache") .. "/convert") 
end
--
-- BEGIN OF AWESOMPD WIDGET DECLARATION


  musicwidget = awesompd:create() -- Create awesompd widget
  musicwidget.font = beautiful.font or "Liberation Mono" -- Set widget font 
--musicwidget.font_color = "#000000"	--Set widget font color
--musicwidget.background = "#FFFFFF"	--Set widget background
  musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
  musicwidget.output_size = 30 -- Set the size of widget in symbols
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
  musicwidget.album_cover_size = 50
  
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
cal.register(mytextclock, "<span color='#FF0000'><b>%s</b></span>")

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 67, "BAT1")

-- {{{ Volume
--volicon = wibox.widget.imagebox()
--volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, "$1%",2,"Master")
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
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

myscreennumber = wibox.widget.textbox()
myscreennumber:set_text(s.."/"..screen.count()) 

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
    --awful.key({ modkey, "Shift"   }, "x", function () awful.util.spawn("urxvt -name \"rootterm\" -e su root") end),
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
    awful.key({ modkey,           }, "<", function () dmenu_command()                   end), 
    awful.key({ modkey, "Control" }, "<", function () dmenu_netcfg()                    end), 
    awful.key({ modkey, "Shift"   }, "<", function () menu_clients()                    end),
    awful.key({ modkey, "Shift"   }, "q", function () dmenu_mpd()                       end), 
    awful.key({ modkey,           }, "q", function () dmenu_system()                    end), 
    -- run or raise
    --awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox")       end),
    --awful.key({ modkey,           }, "s", function () awful.util.spawn("urxvt -name \"rootterm\" -e su root")       end),
    --
    awful.key({ modkey,           }, "c", function () awful.util.spawn("urxvt -e mutt") end),
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
    awful.key({ modkey, "Control" }, "w", function () raiseapp()                                        end),
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("xscreensaver-command -lock")   end),
    awful.key({ modkey,           }, "d", awful.tag.history.restore),
    awful.key({ modkey, "Shift"   }, "d", function () coverart()                                       end),
---- transset permet de modifier la transparence d'une fenêtre
    awful.key({ modkey,           }, "!", function () awful.util.spawn("transset-df -a --inc 0.1")     end),
    awful.key({ modkey, "Shift"   }, "!", function () awful.util.spawn("transset-df -a --dec 0.1")     end),
-- Prompts
    awful.key({ modkey }, "Return", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "r",      function () lua_prompt()                    end),
    awful.key({ modkey }, "F3",     function () textexp_prompt()                end),
    awful.key({ modkey }, "F4",     function () manual_prompt()                 end),
    awful.key({ modkey }, "F5",     function () pwd_prompt()                    end),
    awful.key({ modkey }, "F6",     function () calc_prompt()                   end),
    awful.key({ modkey }, "F7",     function () dict_prompt()                   end),
    awful.key({ modkey }, "F8",     function () converter_prompt()              end),
    awful.key({ modkey }, "F9",     function () stickynote()                    end),
    awful.key({ modkey }, "F10",     function () pomodorotask()                 end),
    --awful.key({  }, "XF86HomePage", function ()  awful.util.spawn("firefox")    end),
    awful.key({  }, "XF86Mail", function ()  awful.util.spawn("urxvt -e mutt")  end),
    awful.key({ modkey }, "Menu", function () dmenu_command()                   end),
    awful.key({  }, "XF86AudioPrev", function ()  awful.util.spawn("mpc prev")  end),
    awful.key({  }, "XF86AudioNext", function ()  awful.util.spawn("mpc next")  end)
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
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
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
                     buttons = clientbuttons } },
   { rule = { name = "Matplotlib"}, properties = { }, callback = not awful.client.setslave },
-- permet d'assigner à chaque aplication un tag -> firefox toujours sur le tag
-- 2, skype/msn sur le 4, les pdf sur le 6, gimp sur le 7, etc. -> d'ou les noms
-- donnés aux tags, cf début de ce fichier.
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "mplayer" },
      properties = { tag = tags[screen.count()][5], switchtotag = true } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[screen.count()][5] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[screen.count()][2] } },
    { rule = { name = "Redshiftgui" },
      properties = { floating = true               } },
    { rule = { name = "pomodairo" },
      properties = { floating = true, sticky =true } },
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
    { rule = { class = "Evince" },
      properties = { tag = tags[screen.count()][6], switchtotag = true } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[screen.count()][3] } },
    { rule = { name = "mutt" },
      properties = { tag = tags[screen.count()][3], switchtotag = true } },
    { rule = { class = "Inkscape" },
      properties = { tag = tags[screen.count()][7] } },
    { rule = { instance = "rootterm" },
      properties = { tag = tags[screen.count()][8], switchtotag = true } },
    { rule = { name = "ncmpcpp" },
      properties = { tag = tags[1][5], switchtotag = true } },
    { rule = { class = "Deluge" },
      properties = { tag = tags[screen.count()][5] } },
    { rule = { class = "Scribus" },
      properties = { tag = tags[screen.count()][7] } },
    { rule = { class = "LibreOffice" },
      properties = { tag = tags[screen.count()][6], floating = false,  switchtotag = true } },
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
        -- awful.client.setslave(c)

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
