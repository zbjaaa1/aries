-- This configuration launches Phosh as a nested compositor inside Xorg
-- This lets Phosh run on downstream kernels that do not support DRM/KMS
-- Based on the stock AwesomeWM configuration, but stripped to the bare bones

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Notification library
local naughty = require("naughty")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max.fullscreen,
}
-- }}}

-- {{{ Menu
awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join())
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({}, "XF86PowerOff", function()
        awful.spawn("busctl --user set-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode i 0")
    end, {})
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {}
-- }}}

local n_managed = 0

local function set_keybinds(incr)
    local old = n_managed
    n_managed = n_managed + incr
    if old == 0 and n_managed > 0 then
        root.keys({})
    elseif old > 0 and n_managed == 0 then
        root.keys(globalkeys)
    end
end

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    set_keybinds(1)
end)

client.connect_signal("unmanage", function(c)
    set_keybinds(-1)
end)

client.connect_signal("request::titlebars", function(c)
    c.fullscreen = true
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
-- }}}

awful.spawn("env -u XDG_SESSION_TYPE WLR_BACKENDS=x11 phosh-session &")
