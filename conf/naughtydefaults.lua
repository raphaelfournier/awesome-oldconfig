require("naughty")
naughty.config.default_preset.timeout          = 10
naughty.config.default_preset.hover_timeout    = 0.5
--naughty.config.default_preset.screen           = 1
naughty.config.default_preset.position         = "bottom_right"
--naughty.config.default_preset.margin           = 4
--naughty.config.default_preset.height           = 48
naughty.config.default_preset.width            = 400
naughty.config.default_preset.gap              = 1
naughty.config.default_preset.ontop            = true
naughty.config.default_preset.font             = beautiful.font or "Verdana 12"
naughty.config.default_preset.icon             = nil
naughty.config.default_preset.icon_size        = 16
--naughty.config.default_preset.fg               = beautiful.fg_focus or '#ffffff'
--naughty.config.default_preset.bg               = beautiful.bg_focus or '#535d6c'
naughty.config.presets.normal.border_color     = beautiful.border_focus or '#535d6c'
naughty.config.default_preset.border_width     = 1
