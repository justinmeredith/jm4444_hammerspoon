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

--Searches for a particular string in a larger string and replaces that particular string with a new string
function search_and_replace_string(search_string, large_string, replacement_string)
    return string.gsub(large_string, search_string, replacement_string)
end

--Returns the frontmost app as an app object
function store_frontmost_app()
    return hs.application.frontmostApplication()
end

--Pastes the default pasteboard
function paste()
    hs.eventtap.keyStroke({"cmd"}, "v")
end

--Copies to the default pasteboard
function copy()
    hs.eventtap.keyStroke({"cmd"}, "c")
end

--Replaces the pasteboard with new content
function replace_pasteboard(replacement)
    hs.pasteboard.clearContents()
    hs.pasteboard.setContents(replacement)
end

--This function escapes magic characters in a string so that the string can be used with methods like string.gsub
function escape_magic_characters_in_string(string)
    return string:gsub('([%^%$%(%)%%%.%[%]%*%+%-%q?])', '%%%1')
end


--]*Hotkeys*[--

--Fill in topics with [40 words] 3x using the keybinding "option" + "4" + "0" in Typora
hs.hotkey.bind({"alt"}, "4", function()
    hs.hotkey.bind({"alt"}, "0", function()
        activate_typora()
    
        local typora = hs.appfinder.appFromName("Typora")
        local select_all = {"Edit", "Selection", "Select All"}
        local copy_as_markdown = {"Edit", "Copy as Markdown"}
        local placeholder = "\n\n[40 words]\n\n[40 words]\n\n[40 words]"
        local pasteboard = nil
        local topic_x = "%#+ Topic %d+ %- .-\n"

        hs.pasteboard.clearContents()
        typora:selectMenuItem(select_all)
        copy()
        pasteboard = hs.pasteboard.getContents()

        for heading in string.gmatch(hs.pasteboard.getContents(), topic_x) do
            local heading_without_topic_x = search_and_replace_string("%#+ Topic %d+ %- ", heading, "")
            local heading_with_placeholder = heading_without_topic_x .. placeholder
            pasteboard = string.gsub(pasteboard, escape_magic_characters_in_string(heading_without_topic_x), heading_with_placeholder)
        end

        pasteboard = search_and_replace_string("Topic %d+ %- ", pasteboard, "")
        hs.pasteboard.setContents(pasteboard)
        paste()

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
        current_app_for_music_switching:activate()
        music:hide()
    end
end)