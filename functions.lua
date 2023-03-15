function oops (id, other)
    if id == 0 then
        --help message
        if input[2] == "upgrade" or input[2] == "upgrades" then
            print("There are a few upgrades that you can purchase in this game.")
            print("Green upgrades boost click value,")
            print("Blue upgrades boost formers,")
            print("Purple upgrades boost makers,")
            print("And orange upgrades boost all three!")
            print("The plus upgrades give a 2x boost, and the star upgrades give a 5x boost (for a total of x10).")
            print("When you buy an upgrade, it will be tinted green. If you cannot afford an upgrade, it will be tinted black.")
            print("Upgrades without a tint indicate that you have enough resources to buy it.")
        elseif input[2] == "command" or input[2] == "commands" then
            print("The full list of commands you can use is as follows:")
            print("buy [val] [building]:   buys up to [val] units of [building]")
            print("buy upgrade:   buys the next available upgrade, if it is affordable")
            print("coop add [id]:   allows another user to play this savefile")
            print("coop remove [id]:   removes a user from playing this savefile")
            print("coop list:   lists the current users who can play this savefile")
        else
            print("This is an incremental game using NotSoBot tag scripting.")
            print("To play, each time you use the tag, you will get a code.")
            print("You must then add the code to the next use of the tag.")
            print("There are some commands you can use by appending them after the code as well.")
            print("For example, using the tag correctly would look something like this: ``{prefix}t incremental fe12be [command]``")
            print("You can also do ``{prefix}t incremental help [subject]`` for a description of a part in the game.")
            print("Each use of the tag calculates production equal to the time between the previous use of the tag and now,")
            print("as well as adding additional resources equal to your \"click\" value.\n")
            print("To start playing, use the following code:")
            print(genCode())
        end
    elseif id == 1 then
        --malformed input
        print("Malformed Input")
        print(other)
    elseif id == 2 then
        print("You're not in this savefile's co-op!")
    elseif id == 3 then
        print("Under maintenance! Please try again later.")
    end
    os.exit()
end

function genCode ()
    time = tostring(os.time())
    id = "{id}"
    message = time .. ",0,{0,0},{false,false,false,false,false,false,false,false},{" .. id .. "},{" .. time .. ",0,0},"
    return encode(message)
end

function getClickValue ()
    value = game[3][1] + 1
    if game[4][1] then
        value = value * 2
    end
    if game[4][2] then
        value = value * 5
    end
    if game[4][7] then
        value = value * 2
    end
    if game[4][8] then
        value = value * 5
    end
    return value
end

function getFormerValue ()
    value = 1
    if game[4][3] then
        value = value * 2
    end
    if game[4][4] then
        value = value * 5
    end
    if game[4][7] then
        value = value * 2
    end
    if game[4][8] then
        value = value * 5
    end
    return value
end

function getMakerValue ()
    value = 1
    if game[4][5] then
        value = value * 2
    end
    if game[4][6] then
        value = value * 5
    end
    if game[4][7] then
        value = value * 2
    end
    if game[4][8] then
        value = value * 5
    end
    return value
end

function split (str, splitter, maxDepth)
    result = {}
    depth = 0
    cur = ""
    for i = 1, #str do
        char = str:sub(i, i)
        if char == splitter and (maxDepth == nil or depth <= maxDepth) then
            table.insert(result, cur)
            cur = ""
        else
            if char == "{" then
                depth = depth + 1
            elseif char == "}" then
                depth = depth - 1
            end
            cur = cur .. char
        end
    end
    return result
end

function tabletostring (table)
    message = ""
    for i = 1, #table do
        if type(table[i]) == "table" then
            message = message .. "{"
            for k = 1, #table[i] do
                message = message .. tostring(table[i][k]) .. ","
            end
            message = message:sub(1, #message - 1) .. "}"
        else
            message = message .. tostring(table[i])
        end
        message = message .. ","
    end
    return message
end

function sciformat (val)
    if val == math.huge then
        return "!"
    end
    exponent = math.floor(math.log(val, 10))
    if exponent >= 4 then
        mantissa = math.floor(val / (10^(exponent - 2)))
        mantissa = tostring(mantissa / 100)
        return (mantissa .. "E" .. tostring(exponent))
    end
    return tostring(val)
end

--[[ made this sciformat for smaller string widths, not necessary anymore
function sciformat (val)
    exponent = math.floor(math.log(val, 10))
    if exponent >= 100 then
        return "!"
    elseif exponent >= 3 then
        if exponent >= 10 then
            mantissa = ""
        else
            mantissa = math.floor(val / (10^exponent))
        end
        return (mantissa .. "e" .. tostring(exponent))
    end
    return tostring(val)
end
--]]

function maketime (val)
    hours = (val // 3600)
    if hours < 1000 then
        seconds = ("0" .. (val % 60)):sub(-2)
        minutes = ("0" .. ((val // 60) % 60)):sub(-2)
        hours = ("0" .. hours):sub(-2)
        timeformat = (hours .. ":" .. minutes .. ":" .. seconds)
    else
        timeformat = hours .. "H"
    end
    return timeformat
end

function makeText (val, x, y)
    text = ""
    for i = 1, #val do
        char = (#val - i) + 1
        char = val:sub(char, char)
        text = text .. "cropped.composite(spritesheet, " .. locs[char] .. ", 0)\n"
        text = text .. "back.composite(cropped, " .. tostring(x - (6 * (i - 1))) .. ", " .. tostring(y) .. ")\n"
    end
    return text
end

function encode (message)
    encoded = ""
    for i = 1, #message do
        val = ("0" .. string.format("%x", (message:byte(i) + i) % 256)):sub(-2)
        encoded = encoded .. val
    end
    return encoded
end

function decode (message)
    if message == "" or message == "help" then
        oops(0)
    end

    --decode hex into text
    decoded = ""
    for i = 1, #message, 2 do
        val = tonumber(message:sub(i, i + 1), 16)
        if val == nil then
            oops(1, 71)
        end
        val = string.char((val - ((i + 1) / 2)) % 256)
        decoded = decoded .. val
    end
    
    --split outermost layer by commas
    state = split(decoded, ",", 0)
    if #state ~= 6 then
        oops(1, 80)
    end

    --check each element in state for correct type
    state[1] = tonumber(state[1])
    state[2] = tonumber(state[2])
    if state[1] == nil or state[2] == nil then
        oops(1, 87)
    end

    if state[4]:sub(1, 1) ~= "{" or state[4]:sub(#state[4], #state[4]) ~= "}" then
        oops(1, 91)
    end
    ups = split(state[4]:sub(2, #state[4] - 1) .. ",", ",")
    for i = 1, #ups do
        if ups[i] == "true" then
            ups[i] = true
        elseif ups[i] == "false" then
            ups[i] = false
        else
            oops(1, 100)
        end
    end
    state[4] = ups

    for i = 1, 3 do
        index = {3, 5, 6}
        index = index[i]
        if state[index]:sub(1, 1) ~= "{" or state[index]:sub(#state[index], #state[index]) ~= "}" then
            oops(1, 109)
        end
        vals = split(state[index]:sub(2, #state[index] - 1) .. ",", ",")
        for k = 1, #vals do
            vals[k] = tonumber(vals[k])
            if vals[k] == nil then
                oops(1, 115)
            end
        end
        state[index] = vals
    end

    user = tonumber("{id}")
    found = false
    for i = 1, #state[5] do
        if user == state[5][i] then
            found = true
            break
        end
    end
    if not found then
        oops(2)
    end

    return state
end
