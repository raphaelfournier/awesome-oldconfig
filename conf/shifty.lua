-- Shifty configured tags.
shifty.config.tags = {
    term = {
        layout    = awful.layout.suit.max,
        mwfact    = 0.60,
        exclusive = false,
        position  = 1,
        init      = true,
--        screen    = 1,
        slave     = true,
    honorsizehints = false,
    },
    web = {
        layout      = awful.layout.suit.tile.bottom,
        init      = true,
        mwfact      = 0.72,
        exclusive   = true,
--        max_clients = 1,
        position    = 2,
        spawn       = browser,
    },
    mail = {
        layout    = awful.layout.suit.tile,
        mwfact    = 0.54,
        exclusive = false,
        init      = true,
        position  = 3,
        spawn     = mail,
        slave     = true
    },
    im = {
        layout    = awful.layout.suit.tile,
        mwfact    = 0.62,
        position  = 4,
    },
    media = {
        layout    = awful.layout.suit.float,
        position  = 5,
    },
    pdf = {
        layout    = awful.layout.suit.max,
        position  = 6,
    },
    graph = {
        layout    = awful.layout.suit.tile,
        position  = 7,
        mwfact    = 0.72,
    },
    root = {
        layout   = awful.layout.suit.tile,
        position = 9,
    }
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
        },
        tag = "web",
    },
    {
        match = {
            "Shredder.*",
            "Thunderbird",
            "mutt",
        },
        tag = "mail",
    },
    {
        match = {
            "pcmanfm",
        },
        slave = true
    },
    {
        match = {
            "OpenOffice.*",
            "Abiword",
            "Gnumeric",
        },
        tag = "office",
    },
    {
        match = {
            "Mplayer.*",
            "Mirage",
            "gtkpod",
            "ncmpcpp",
            "Ufraw",
            "easytag",
        },
        tag = "media",
        nopopup = true,
    },
    {
        match = {
            terminal,
        },
        slave = true,
        tag = "term",
    },
    {
     match  = {
       class= "URxvt", 
       name="root. "   --Notice the dot         
       },
     tag    = "root",
     screen = 1,
   },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
    honorsizehints = false,
}

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
--shifty.taglist = mytaglist
shifty.init()

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey
