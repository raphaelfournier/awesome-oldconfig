local naughty   = require("naughty")
local beautiful = require("beautiful")

naughty.config.defaults.screen           = screen.count()
naughty.config.defaults.timeout          = 10
naughty.config.defaults.hover_timeout    = 0.5
naughty.config.defaults.position         = "bottom_right"
naughty.config.defaults.height           = 60
naughty.config.defaults.margin           = 4
naughty.config.defaults.width            = 600
naughty.config.defaults.gap              = 10
naughty.config.defaults.ontop            = true
naughty.config.defaults.font             = beautiful.notifyfont or "Inconsolata Medium 14"
naughty.config.defaults.icon             = nil
naughty.config.defaults.icon_size        = 50
naughty.config.defaults.border_width     = 1

naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
naughty.config.presets.normal.bg     = beautiful.fg_focus or '#535d6c'
naughty.config.presets.normal.fg     = beautiful.bg_normal

naughty.config.presets.low.bg                  = '#506070'
naughty.config.presets.low.fg                  = '#f0dfaf'
naughty.config.presets.low.border_color        = beautiful.border_focus or '#535d6c'
naughty.config.presets.low.icon_size        = 90
naughty.config.presets.low.height           = 100

naughty.config.presets.critical.bg             = '#882222'
naughty.config.presets.critical.fg             = '#dcdccc'
naughty.config.presets.critical.width          = 600
naughty.config.presets.critical.height         = 150
naughty.config.presets.critical.border_color   = beautiful.border_focus or '#535d6c'


