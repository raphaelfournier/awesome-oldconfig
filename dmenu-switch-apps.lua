-- In the rc.lua file there will be a "root.keys(globalkeys)" command that sets
-- your keys, you need to add the following lines just before that command:
--
-- local dmenuswitchapps = require("dmenuswitchapps")


local awful= require("awful")
local client=client
local pairs=pairs
local table=table
local print=print

local dmenuswitchapps = {}

--function aweror.run_or_raise(cmd, properties)
   --local clients = client.get()
   --local focused = awful.client.next(0)
   --local findex = 0
   --local matched_clients = {}
   --local n = 0

function dmenuswitchapps.raiseapp()
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

return dmenuswitchapps
