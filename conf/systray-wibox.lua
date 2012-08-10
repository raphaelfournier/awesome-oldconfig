mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
--secwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
--                                              if not c:isvisible() then
--                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
-- un clic-molette sur le nom d'une fenetre dans la barre des tâches et elle est
-- tuée
                     awful.button({ }, 2, function (c)
                                              c:kill()
                                          end),
-- permet à une fenetre d'être toujours sur le bureau courant                                          
                     awful.button({ modkey }, 2, function (c)
                                              if c.sticky == false then
                                                c.sticky = true
                                              else
                                                c.sticky = false
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if menuinstance then
                                                  menuinstance:hide()
                                                  menuinstance = nil
                                              else
                                                  menuinstance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
--    secwibox[s] = awful.wibox({ position = "bottom", screen = s })
--    secwibox[s].widgets = {
--        wifiwidget,spacesep,barsep,
--        spacesep,todowidget,spacesep,barsep,
--        spacesep,birthdayswidget,
--        layout = awful.widget.layout.horizontal.leftright
--    }
--    secwibox[s].visible = false
    -- Add widgets to the wibox - order matters
testw = widget({ type = "textbox"})
testw.text = s .. "/" .. screen.count()

    mywibox[s].widgets = {
        {
            mylauncher,
            pomodoro.widget,spacesep,
            mytaglist[s],
            mylayoutbox[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        datewidget,
        spacesep,batwidget,
--        spacesep,batwidget2,
--        spacesep,mailwidget0,
--        spacesep,mailwidget1,
--        spacesep,mailwidget2,
        --spacesep, pomodoro.widget,
--        spacesep, kbdcfg.widget,
--        spacesep,
--        spacesep,testw,
        --barsep,
        spacesep,generalvolwidget,spacesep,volwidget,
--        spacesep, tb_todo,
--        spacesep,vol,
        --spacesep,
        --barsep,
        --spacesep,weatherwidget,
--        spacesep,weatherwidget,
--        spacesep,barsep,
--        spacesep,
--        mpdwidget,
        musicwidget.widget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

