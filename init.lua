-- ]*Global Functions*[--
-- Activates the Typora app
function activate_typora()
    hs.application.launchOrFocus("Typora")
end

-- Copy text in the Typora app as markdown text
function keystroke_copy_as_markdown_in_typora()
    activate_typora()
    hs.eventtap.keyStroke({"shift"}, "right")
    hs.eventtap.keyStroke({"cmd", "shift"}, "c")
end

-- Searches for a particular string in a larger string, then returns the number of occurrences of the particular string
function count_search_string_occurrences_in_large_string(search_string, large_string)
    return select(2, string.gsub(large_string, search_string, ""))
end

-- Searches for a particular string in a larger string and replaces that particular string with a new string
function search_and_replace_string(search_string, large_string, replacement_string)
    return string.gsub(large_string, search_string, replacement_string)
end

-- Returns the frontmost app as an app object
function store_frontmost_app()
    return hs.application.frontmostApplication()
end

-- Pastes the default pasteboard
function paste()
    hs.eventtap.keyStroke({"cmd"}, "v")
end

-- Copies to the default pasteboard
function copy()
    hs.eventtap.keyStroke({"cmd"}, "c")
end

-- Replaces the pasteboard with new content
function replace_pasteboard(replacement)
    hs.pasteboard.clearContents()
    hs.pasteboard.setContents(replacement)
end

-- This function escapes magic characters in a string so that the string can be used with methods like string.gsub
function escape_magic_characters_in_string(string)
    return string:gsub('([%^%$%(%)%%%.%[%]%*%+%-%q?])', '%%%1')
end

-- ]*Hotkeys*[--

-- Fill in topics with [40 words] 3x using the keybinding "option" + "4" + "0" in Typora
hs.hotkey.bind({"alt"}, "4", function()
    hs.hotkey.bind({"alt"}, "0", function()
        activate_typora()

        -- Sets the local variables for the hotkey function
        local typora = hs.appfinder.appFromName("Typora")
        local select_all = {"Edit", "Selection", "Select All"}
        local copy_as_markdown = {"Edit", "Copy as Markdown"}
        local placeholder = "\n\n[40 words]\n\n[40 words]\n\n[40 words]"
        local pasteboard = nil
        local topic_x = "%#+ Topic %d+ %- .-\n"

        -- Clears the pasteboard, selects all of the text in Typora, then copies that text to the pasteboard
        hs.pasteboard.clearContents()
        typora:selectMenuItem(select_all)
        copy()
        pasteboard = hs.pasteboard.getContents()

        for heading in string.gmatch(hs.pasteboard.getContents(), topic_x) do
            local heading_without_topic_x = search_and_replace_string("%#+ Topic %d+ %- ", heading, "")
            local heading_with_placeholder = heading_without_topic_x .. placeholder
            pasteboard = string.gsub(pasteboard, escape_magic_characters_in_string(heading_without_topic_x),
                heading_with_placeholder)
        end

        pasteboard = search_and_replace_string("Topic %d+ %- ", pasteboard, "")
        hs.pasteboard.setContents(pasteboard)
        paste()

    end)
end)

-- Fill in topics with custom placeholders 3x per topic using the keybinding "command" + "shift" + "i" in Typora
hs.hotkey.bind({"cmd", "shift"}, "I", function()
    activate_typora()

    -- Sets the local variables for the hotkey function
    local typora = hs.appfinder.appFromName("Typora")
    local select_all = {"Edit", "Selection", "Select All"}
    local copy_as_markdown = {"Edit", "Copy as Markdown"}
    local pasteboard = nil

    -- Clears the pasteboard, selects all of the text in Typora, then copies that text to the pasteboard
    hs.pasteboard.clearContents()
    typora:selectMenuItem(select_all)
    copy()
    pasteboard = hs.pasteboard.getContents()

    -- Find the word count in the copied text
    local word_count_str = string.match(pasteboard, "%*%*Length:%*%*%s+(%d[%d,]*)%s+words")
    if not word_count_str then
        print("Length not found")
        return
    end
    word_count_str = word_count_str:gsub(",", "")
    local word_count = tonumber(word_count_str)

    -- Count occurrences of # Topic x - 
    local topic_count = 0
    for _ in string.gmatch(pasteboard, "#+ Topic %d+ %- .-\n") do
        topic_count = topic_count + 1
    end
    print("Number of occurrences of # Topic x - :", topic_count)

    -- Calculate the number of words per placeholder
    if word_count and topic_count > 0 then
        local words_per_placeholder = math.floor(tonumber(word_count) / topic_count / 3)
        print("Words per placeholder: " .. words_per_placeholder)

        -- Create the placeholders string
        local placeholders = string.format("[%d words]\n[%d words]\n[%d words]\n", words_per_placeholder, words_per_placeholder, words_per_placeholder)
        print("Placeholders: " .. placeholders)
    else
        print("Cannot calculate words per placeholder")
    end

end)

-- Show/Hide the Music app
hs.hotkey.bind({"fn"}, "f8", function()
    local music = hs.appfinder.appFromName("Music")

    if (music:isFrontmost() == false) then
        current_app_for_music_switching = store_frontmost_app()
        hs.application.launchOrFocus("Music")
    else
        current_app_for_music_switching:activate()
        music:hide()
    end
end)
