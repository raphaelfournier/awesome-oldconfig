-- Standard awesome library
os.setlocale( os.getenv( 'LANG' ), 'time' )
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox     = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty   = require("naughty")
local vicious   = require("vicious")
local menubar   = require("menubar")
local eminent   = require("eminent.eminent")
local ror       = require("runorraise.aweror")
local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors,
                     screen = mouse.screen})
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
                         text = err })
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

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    lain.layout.uselesstile,
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
    tags[s] = awful.tag({"tag"}, s, { layouts[2], })
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
    naughty.notify({ text = "service : "..service, width = 400})
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
    naughty.notify({ text = "service : "..service.."login : "..login, width = 400})
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
        naughty.notify({ text = expr .. ' = <span color="white">' .. val .. "</span>"--,
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
          naughty.notify({ text = fr, timeout = 0, width = 400 })
    end,
    nil, awful.util.getdir("cache") .. "/dict") 
end

-- {{{ Wibox
space = wibox.widget.textbox()
space:set_text(' ')
-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %d %b %H:%M")
mytextclock:buttons(awful.util.table.join(
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
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    --left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(space)
    right_layout:add(batwidget)
    right_layout:add(space)
    right_layout:add(volumewidget)
    right_layout:add(space)
    right_layout:add(mylayoutbox[s])
    right_layout:add(space)
    right_layout:add(mytextclock)
    if s == 1 then right_layout:add(wibox.widget.systray()) end

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
    awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
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

    --awful.key({ modkey,           }, "a", revelation.revelation),
    awful.key({ modkey,           }, "<", function () dmenu_command()                   end), 
    awful.key({ modkey, "Control" }, "<", function () dmenu_netcfg()                    end), 
    awful.key({ modkey, "Shift"   }, "<", function () menu_clients()                    end),
    awful.key({ modkey, "Shift"   }, "q", function () dmenu_mpd()                       end), 
    awful.key({ modkey,           }, "q", function () dmenu_system()                    end), 
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    -- run or raise
    --awful.key({ modkey,           }, "w", function () awful.util.spawn("firefox")       end),
    --awful.key({ modkey,           }, "s", function () awful.util.spawn("urxvt -name \"rootterm\" -e su root")       end),
    --
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
    awful.key({ modkey, "Control" }, "a", function () awful.util.spawn("xscreensaver-command -lock")   end)
-- Prompts
)


clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    --awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    --awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    --awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    --awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
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

    local titlebars_enabled = true
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
