local home   = os.getenv("HOME")
dmenuopts= "-b -i -nf '"..beautiful.fg_normal.."' -nb '"..beautiful.bg_normal.."' -sf '"..beautiful.fg_urgent.."' -sb '"..beautiful.bg_focus.."' -fn '-*-dejavu sans mono-*-r-*-*-*-*-*-*-*-*-*-*'"
--dmenuopts= "-b -i -nf '"..beautiful.fg_normal.."' -nb '"..beautiful.bg_normal.."' -sf '"..beautiful.fg_urgent.."' -sb '"..beautiful.bg_focus.."' -fn '-*-liberation mono-*-r-*-*-*-120-*-*-*-*-*-*'"

terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

os.setlocale( os.getenv( 'LANG' ), 'time' )
local exec = awful.util.spawn
modkey = "Mod4"
altkey = "Mod1"

spacesep = widget({ type = "textbox"})
barsep = widget({ type = "textbox"})
spacesep.text = " "
barsep.text = "|"

