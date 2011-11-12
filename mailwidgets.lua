---- {{{ Mail 
mailwidget0 = widget({ type = "textbox" })
--vicious.register(mailwidget0, vicious.widgets.mdir, '<span color="' .. beautiful.border_focus .. '">RF</span> $1', 61, {home ..  "/Mail/Rfnet/INBOX"})
--mailwidget0:buttons(awful.util.table.join(
--  awful.button({ }, 1, function () exec("urxvt -T Mutt -e mutt") end)
--))

mailwidget1 = widget({ type = "textbox" })
--vicious.register(mailwidget1, vicious.widgets.mdir, '<span color="' .. beautiful.border_focus .. '">LB</span> $1', 61, {home ..  "/Mail/Lavabit/Inbox"})

mailwidget2 = widget({ type = "textbox" })
--vicious.register(mailwidget2, vicious.widgets.mdir, '<span color="' .. beautiful.fg_urgent .. '">LIP6</span> $1', 61, {home ..  "/Mail/Lip6/INBOX"})


