--awful.rules.rules = {
--    -- All clients will match this rule.
--    { rule = { },
--      properties = { border_width = beautiful.border_width,
--                     border_color = beautiful.border_normal,
--                     size_hints_honor = false,
--                     focus = true,
--                     keys = clientkeys,
--                     buttons = clientbuttons }, 
-- -- Start windows as slave
--      callback = awful.client.setslave },
--   { rule = { name = "Matplotlib"}, properties = { }, callback = not awful.client.setslave },
---- permet d'assigner à chaque aplication un tag -> firefox toujours sur le tag
---- 2, skype/msn sur le 4, les pdf sur le 6, gimp sur le 7, etc. -> d'ou les noms
---- donnés aux tags, cf début de ce fichier.
--    --{ rule = { class = "MPlayer" },
--    --  properties = { floating = true } },
--    -- Set Firefox to always map on tags number 2 of screen 1.
--    { rule = { class = "Firefox" },
--      properties = { tag = tags[1][2] } },
--    { rule = { class = "MPlayer" },
--      properties = { tag = tags[1][8] } },
--    { rule = { class = "Hotot" },
--      properties = { tag = tags[1][4] } },
--    { rule = { class = "Pidgin" },
--      properties = { tag = tags[1][4] } },
--    { rule = { class = "Skype" },
--      properties = { tag = tags[1][4] } },
--    { rule = { class = "Acroread" },
--      properties = { tag = tags[1][6] } },
--    { rule = { class = "Epdfview" },
--      properties = { tag = tags[1][6] } },
--    { rule = { class = "Sonata" },
--      properties = { tag = tags[1][5] } },
--    { rule = { instance = "ncmpcpp" },
--      properties = { tag = tags[1][5] } },
--    { rule = { class = "Zathura" },
--      properties = { tag = tags[1][6] } },
--    { rule = { class = "dclock" },
--      properties = { screen = screen.count() } },
--    { rule = { class = "Conky" },
--      properties = { screen = screen.count() } },
--    { rule = { class = "Evince" },
--      properties = { tag = tags[1][6] } },
--    { rule = { class = "Thunderbird" },
--      properties = { tag = tags[1][5] } },
--    { rule = { class = "Inkscape" },
--      properties = { tag = tags[1][7] } },
--    { rule = { class = "Scribus" },
--      properties = { tag = tags[1][7] } },
--    { rule = { class = "libreoffice-*" },
--      properties = { tag = tags[1][6], floating = false } },
--    { rule = { class = "Gimp" },
--      properties = { tag = tags[1][7], floating = false } },
--}

