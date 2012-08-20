musicwidget = awesompd:create() -- Create awesompd widget
musicwidget.font = beautiful.font -- Set widget font 
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 4 -- Set the update interval in seconds
musicwidget.notifications = false
musicwidget.textcolor_play = beautiful.colors.brightgreen
musicwidget.textcolor_pause = beautiful.colors.cyan
musicwidget.textcolor_stopped = beautiful.colors.red
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/raph/.config/awesome/awesompd/icons" 
musicwidget.mpd_config = "/home/raph/.mpd/mpd.conf"
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks will also contain
-- album cover image.
musicwidget.show_jamendo_album_covers = true
musicwidget.album_cover_size = 150
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = " "
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
   { server = "localhost",
        port = 6600 },
     { server = "192.168.1.20",
          port = 6600 } 
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

