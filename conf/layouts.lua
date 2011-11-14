layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.mirror,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}

-- {{{ Tags
tags = {
names={"1","2","3","4","5","6","7","8"},
layout = { layouts[1], 
           layouts[2], 
           layouts[1], 
           layouts[1], 
           layouts[5], 
           layouts[12], 
           layouts[3], 
           layouts[5]}
}

for s = 1, screen.count() do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  awful.tag.setproperty(tags[s][2], "mwfact", 0.72)
  awful.tag.setproperty(tags[s][3], "mwfact", 0.54)
  awful.tag.setproperty(tags[s][4], "mwfact", 0.62)
  awful.tag.setproperty(tags[s][7], "mwfact", 0.72)
end

