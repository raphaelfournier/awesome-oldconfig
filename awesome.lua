require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
beautiful.init(awful.util.getdir("config") .. "/themes/current_theme/theme.lua")
require("conf.naughtydefaults")
require("conf.revelation")
require("vicious")
--require("vicious.contrib")
-- Mirror layout
--require("mirror")

require("conf.variables")
require("conf.layouts")
require("conf.menu")

require("conf.bat-vol-date")
require("conf.pomodoro")
require("conf.taskcoach")
require("awesompd.awesompd")
require("conf.awesompdconf")
require("conf.weather")
--require("secondwibox")
require("conf.systray-wibox")

require("conf.keybindings")
require("conf.clientkeys")
require("conf.rules")
require("conf.signals")
require("conf.runonce")
