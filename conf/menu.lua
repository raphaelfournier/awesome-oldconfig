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

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

