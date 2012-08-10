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
          naughty.notify({ text = answer, width = 400})
    end,
    nil, awful.util.getdir("cache") .. "/convert") 
end
