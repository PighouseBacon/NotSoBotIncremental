print("Version 10")

if "{id}" ~= "221158868938522624" then
    oops(3)
end

input = split("{args} ", " ")

game = decode(input[1])
--now..simulate tick(s)
now = os.time()
if now < game[1] then
    oops(1, 48)
end
difference = now - game[1]
game[1] = now
moneytick = math.floor((game[3][1] * getFormerValue() * difference) + (game[3][2] * getMakerValue() * 0.5 * (difference^2 + difference)) + 0.5)
game[2] = game[2] + moneytick
game[6][2] = game[6][2] + moneytick 
game[3][1] = game[3][1] + (game[3][2] * getMakerValue() * difference)
game[2] = game[2] + getClickValue()
game[6][2] = game[6][2] + getClickValue()

buildingcosts = {math.floor(10 * (2^game[3][1]) + 0.5), math.floor(1000 * (5^game[3][2]) + 0.5)}
upgradecosts = {10, 500, 1000, 50000, 1e5, 5e6, 1e7, 5e8}
nextup = {1, 10}
for i = 1, #game[4] do
    if game[4][i] then
        nextup = {i + 1, upgradecosts[i + 1]}
    end
end

--then, execute any commands
if input[2] == "buy" then
    if input[3] == "upgrade" then
        if nextup[1] < 9 and game[2] >= nextup[2] then
            game[2] = game[2] - nextup[2]
            game[4][nextup[1]] = true
            print("Bought upgrade!")
        else
            print("You can't buy an upgrade!")
        end
    elseif type(tonumber(input[3])) == "number" then
        if input[4] == "former" or input[4] == "formers" then
            amount = 0
            for i = 1, tonumber(input[3]) do
                if game[2] >= buildingcosts[1] then
                    game[2] = game[2] - buildingcosts[1]
                    game[3][1] = game[3][1] + 1
                    buildingcosts[1] = math.floor(10 * (2^game[3][1]) + 0.5)
                    amount = i
                else
                    break
                end
            end
            print("Bought " .. tostring(amount) .. " formers!")
        elseif input[4] == "maker" or input[4] == "makers" then
            amount = 0
            for i = 1, tonumber(input[3]) do
                if game[2] >= buildingcosts[2] then
                    game[2] = game[2] - buildingcosts[2]
                    game[3][2] = game[3][2] + 1
                    buildingcosts[2] = math.floor(1000 * (5^game[3][2]) + 0.5)
                    amount = i
                else
                    break
                end
            end
            print("Bought " .. tostring(amount) .. " makers!")
        else
            print("Not sure which building you're trying to buy...")
        end
    else
        print("Not sure what you want to buy...")
    end
elseif input[2] == "coop" or input[2] == "co-op" then
    if input[3] == "add" then
        if type(tonumber(input[4])) == "number" then
            found = false
            for i = 1, #game[5] do
                if game[5][i] == tonumber(input[4]) then
                    found = true
                    break
                end
            end
            if found then
                print("That player is already in the co-op!")
            else
                table.insert(game[5], tonumber(input[4]))
                print("Added user to co-op!")
            end
        else
            print("Invalid ID!")
        end
    elseif input[3] == "remove" then
        if type(tonumber(input[4])) == "number" then
            found = {false}
            for i = 1, #game[5] do
                if game[5][i] == tonumber(input[4]) then
                    found = {true, i}
                    break
                end
            end
            if found[1] then
                if found[2] == 1 then
                    print("You cannot remove the player who created the save!")
                else
                    table.remove(game[5], found[2])
                    print("Removed user from co-op!")
                end
            else
                print("That user isn't in this co-op!")
            end
        else
            print("Invalid ID!")
        end
    elseif input[3] == "list" then
        for i = 1, #game[5] do
            print("Player " .. tostring(i) .. ": <@" .. tostring(game[5][i]) .. ">")
        end
    else
        print("Not sure which co-op setting you're trying to edit...")
    end
elseif input[2] ~= nil then
    print("Unknown command!")
end

--now generate the graphic
colors = {"0", "504"}
for i = 1, #game[4] do
    if game[4][i] then
        colors[1] = tostring((i * 64) - 8)
    end
    if game[2] >= upgradecosts[i] or game[4][i] then
        colors[2] = tostring(((8 - i) * 64) - 8)
    end
end

chars = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "e", ".", ":", "!", "H"}
locs = {}
for i = 1, #chars do
    locs[chars[i]] = tostring(-48 * (i - 1))
end

--game graphic
graphic = "{" .. "iscript: "
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/game%20background.png template"
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/numbers%20spritesheet.png spritesheet"
graphic = graphic .. "\ncreate cropped 40 40 0 0 0 255"
--money value
graphic = graphic .. makeText(sciformat(game[2]), 328, 384)
--money/sec
graphic = graphic .. makeText(sciformat(game[3][1] * getFormerValue()), 632, 384)
--money/click
graphic = graphic .. makeText(sciformat(getClickValue()), 936, 384)
--formers
graphic = graphic .. makeText(sciformat(game[3][1]), 328, 512)
--formers cost
graphic = graphic .. makeText(sciformat(buildingcosts[1]), 632, 512)
--formers making
graphic = graphic .. makeText(sciformat(getFormerValue()), 936, 512)
--makers
graphic = graphic .. makeText(sciformat(game[3][2] * getMakerValue()), 328, 640)
--makers cost
graphic = graphic .. makeText(sciformat(buildingcosts[2]), 632, 640)
--makers making
graphic = graphic .. makeText(sciformat(getMakerValue()), 936, 640)
--upgrades
if colors[1] ~= "0" then
    graphic = graphic .. "\ncreate green " .. colors[1] .. " 56 34 177 76 192"
    graphic = graphic .. "\noverlay template green 432 696"
end
if colors[2] ~= "-8" then
    graphic = graphic .. "\ncreate black " .. colors[2] .. " 56 0 0 0 128"
    graphic = graphic .. "\noverlay template black " .. tostring(936 - colors[2]) .. " 696"
end
--render
graphic = graphic .. "\nrender template}\n"

if #split(graphic, "\n") > 50 then
    print(sciformat(game[2]))
    print(sciformat(game[3][1] * getFormerValue()))
    print(sciformat(getClickValue()))
    print(sciformat(game[3][1]))
    print(sciformat(buildingcosts[1]))
    print(sciformat(getFormerValue()))
    print(sciformat(game[3][2] * getMakerValue()))
    print(sciformat(buildingcosts[2]))
    print(sciformat(getMakerValue()))
    graphic = ""
end

--stats graphic
graphic = graphic .. "{" .. "iscript: "
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/stats.png template"
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/numbers%20spritesheet.png spritesheet"
graphic = graphic .. "\ncreate cropped 40 40 0 0 0 255"
--prev
graphic = graphic .. makeText(maketime(difference), 424, 424)
--start
graphic = graphic .. makeText(maketime(now - game[6][1]), 824, 424)
--total
graphic = graphic .. makeText(sciformat(game[6][2]), 424, 552)
--co-op
if #game[5] > 1 then
    graphic = graphic .. "\ncreate cover 392 56 255 255 255 255"
    graphic = graphic .. "\noverlay template cover 432 544"
    graphic = graphic .. makeText(tostring(#game[5]), 824, 552)
end
--render
graphic = graphic .. "\nrender template}"



debug = tabletostring(game)
print(debug)
print(encode(debug))
print(graphic)
