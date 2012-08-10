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
pomodoro.widget = widget({ type = "textbox" })
pomodoro.timer = timer { timeout = 1 }

function pomodoro:settime(t)
  if t >= 3600 then -- more than one hour!
    t = os.date("%X", t-3600)
  else
    t = os.date("%M:%S", t)
  end
  self.widget.bg= "#880000"
  self.widget.text = t
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

pomodoro.timer:add_signal("timeout", function()
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

