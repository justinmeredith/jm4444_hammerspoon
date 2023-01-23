--]*Global Functions*[--

--Activates the Typora app
function activate_typora()
    hs.application.launchOrFocus("Typora")
end

--Copy text in the Typora app as markdown text
function keystroke_copy_as_markdown_in_typora()
    activate_typora()
    hs.eventtap.keyStroke({"shift"}, "right") 
    hs.eventtap.keyStroke({"cmd", "shift"}, "c")
end

--Searches for a particular string in a larger string, then returns the number of occurrences of the particular string
function count_search_string_occurrences_in_large_string(search_string, large_string)
    return select(2, string.gsub(large_string, search_string, ""))
end

function store_frontmost_app()
    return hs.application.frontmostApplication()
end


--]*Hotkeys*[--

--Fill in topics with [40 words] 3x
--[[
    Currently, this uses the keybinding "option + 4 + 0" to launch/focus Typora then choose the 'Select All' option from Typora's Menu Bar
]]
hs.hotkey.bind({"alt"}, "4", function()
    hs.hotkey.bind({"alt"}, "0", function()
        activate_typora()
    
        local typora = hs.appfinder.appFromName("Typora")
        local select_all = {"Edit", "Selection", "Select All"}
        local copy_as_markdown = {"Edit", "Copy as Markdown"}

        typora:selectMenuItem(select_all)
        keystroke_copy_as_markdown_in_typora()
        local topic_x_occurrences = count_search_string_occurrences_in_large_string("Topic %d+ %- ", hs.pasteboard.getContents())
        print(topic_x_occurrences)
    end)
end)


--Show/Hide the Music app
hs.hotkey.bind({"fn"}, "f8", function()
    local music = hs.appfinder.appFromName("Music")

    if( music:isFrontmost() == false)
    then
        current_app_for_music_switching = store_frontmost_app()
        hs.application.launchOrFocus("Music")
    else
        music:hide()
        current_app_for_music_switching:activate()
    end
end)