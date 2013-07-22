local awful= require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local client=client
local pairs=pairs
local table=table
local print=print

local dmenuhelpers = {}

dmenuopts = "-b -i -nf '"..beautiful.fg_normal.."' -nb '"..beautiful.bg_normal.."' -sf '"..beautiful.bg_urgent.."' -sb '"..beautiful.bg_focus.."' -fn '-*-dejavu sans mono-*-r-*-*-*-*-*-*-*-*-*-*'"

function dmenuhelpers.switchapp()
  local allclients = client.get(mouse.screen)
  clientsline = ""
  for _,c in ipairs(allclients) do
    clientsline = clientsline .. c:tags()[1].name .. " - " .. c.name .. "\n"
  end
  selected = awful.util.pread("echo '".. clientsline .."' | dmenu -l 10 " .. dmenuopts)
  for _,c in ipairs(allclients) do
    a = c:tags()[1].name .. " - " .. c.name 
    if a == selected:gsub("\n", "") then
      for i, v in ipairs(c:tags()) do
        awful.tag.viewonly(v)
        --naughty.notify({ text = "service : "..v.name, width = 400, position = top_left, screen = mouse.screen})
        client.focus = c
        c:raise()
        c.minimized = false
        return
      end
    end
  end
end

function dmenuhelpers.run() 
  awful.util.spawn("dmenu_run -f -p 'Run command:' " .. dmenuopts) 
end

function dmenuhelpers.netcfg() 
  netcfgprofile = awful.util.pread("find /etc/network.d/ -type f | grep -v examples | cut -d \"/\" -f 4 | dmenu " .. dmenuopts)
  awful.util.spawn(netcfgprofile ~= "" and "sudo netcfg -r " .. netcfgprofile or nil) 
end 

function dmenuhelpers.mpd() 
  numsong = awful.util.pread("mpc playlist | nl -s ' ' | tr -s \" \" | dmenu -l 10 " .. dmenuopts .. "| cut -d \" \" -f2")
  awful.util.spawn(numsong ~= "" and "mpc play " .. numsong or nil) 
end 

function dmenuhelpers.system() 
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

function dmenuhelpers.expandtext()
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

function dmenuhelpers.pwd()
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

return dmenuhelpers
