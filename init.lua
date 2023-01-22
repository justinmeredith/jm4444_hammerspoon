--Fill in topics with [40 words] 3x
--[[
    Currently, this uses the keybinding "option + 4 + 0" to launch/focus Typora then choose the 'Select All' option from Typora's Menu Bar
]]
hs.hotkey.bind({"alt"}, "4", function()
    hs.hotkey.bind({"alt"}, "0", function()
        hs.application.launchOrFocus("Typora")
    
        local typora = hs.appfinder.appFromName("Typora")
        local select_all = {"Edit", "Selection", "Select All"}

        typora:selectMenuItem(select_all)
    end)
end)

