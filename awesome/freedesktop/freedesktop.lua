-- This is an usage example
-- Modify according to your preferences

-- If you are a Debian user, you can also uncomment the two lines that insert
-- the Debian menu together with the rest of the items (11 and 33).

local awful     = require("awful")
local beautiful = require("beautiful")

require("freedesktop")
require("freedesktop.utils")
-- require("debian.menu")

freedesktop.utils.terminal   = terminal -- defined in rc.lua, otherwise define it here (default: "xterm")
freedesktop.utils.icon_theme = { 'gnome' }   -- choose your favourite from /usr/share/icons/ (default: nil)
--freedesktop.utils.icon_dir     = "~/.config/awesome/freedesktop/icon/"



menu_items = freedesktop.menu.new()

myawesomemenu = {
 { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
 { "restart awesome", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
 { "quit awesome", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}
mypowermenu = {
{ "Выключить",  "poweroff",  },
{ "Перезагрузить",  "reboot",  },
{ "Cпящий режим",  "systemctl  suspend" },
{ "Заблокировать", "slimlock" },
}

for s = 1, screen.count() do
    --freedesktop.desktop.add_application_icons({screen = s, showlabels = true})
    --freedesktop.desktop.add_dirs_and_file_icons({screen = s, showlabels = true})
    freedesktop.desktop.add_desktop_icons({screen = s, showlabels = true})
end

table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
--table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
 table.insert(menu_items, { "Power", mypowermenu, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) })

mymainmenu = awful.menu.new({ items = menu_items, theme = { width = 150 } })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
