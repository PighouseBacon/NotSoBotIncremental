print("Version 27")

if "{id}" ~= "221158868938522624" then
    oops(3)
end

input = split("{args} ", " ")
--[[
for key,value in pairs(input) do
    print(value)
end
print("\n")
--]]

game = decode(input[1])
--now..simulate tick(s)
multipliers = {1, 1, 1}
if game[4][1] then
    multipliers[1] = multipliers[1] * 2
end
if game[4][2] then
    multipliers[1] = multipliers[1] * 5
end
if game[4][3] then
    multipliers[2] = multipliers[2] * 2
end
if game[4][4] then
    multipliers[2] = multipliers[2] * 5
end
if game[4][5] then
    multipliers[3] = multipliers[3] * 2
end
if game[4][6] then
    multipliers[3] = multipliers[3] * 5
end
if game[4][7] then
    multipliers[1] = multipliers[1] * 2
    multipliers[2] = multipliers[2] * 2
    multipliers[3] = multipliers[3] * 2
end
if game[4][8] then
    multipliers[1] = multipliers[1] * 5
    multipliers[2] = multipliers[2] * 5
    multipliers[3] = multipliers[3] * 5
end
now = os.time()
difference = now - game[1]
game[1] = now
moneytick = math.floor((game[3][1] * multipliers[2] * difference) + (game[3][2] * multipliers[3] * 0.5 * (difference^2 + difference)) + 0.5)
game[2] = game[2] + moneytick
game[6][2] = game[6][2] + moneytick 
game[3][1] = game[3][1] + (game[3][2] * multipliers[3] * difference)
multipliers[1] = multipliers[1] * (game[3][1] + 1)
game[2] = game[2] + multipliers[1]
game[6][2] = game[6][2] + multipliers[1]

buildingcosts = {math.floor(10 * (2^game[3][1]) + 0.5), math.floor(1000 * (5^game[3][2]) + 0.5)}
upgradecosts = {10, 500, 1000, 50000, 1e5, 5e6, 1e7, 5e8}
affordable = {}
colors = {"0", "504"}
for i = 1, #upgradecosts do
    affordable[i] = game[2] >= upgradecosts[i]
    if game[4][i] then
        colors[1] = tostring((i * 64) - 8)
    end
    if affordable[i] then
        colors[2] = tostring(((8 - i) * 64) - 8)
    end
end

--then, execute any commands

--now generate the graphic
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
graphic = graphic .. makeText(sciformat(game[3][1] * multipliers[2]), 632, 384)
--money/click
graphic = graphic .. makeText(sciformat(multipliers[1]), 936, 384)
--formers
graphic = graphic .. makeText(sciformat(game[3][1]), 328, 512)
--formers cost
graphic = graphic .. makeText(sciformat(buildingcosts[1]), 632, 512)
--formers making
graphic = graphic .. makeText(sciformat(multipliers[2]), 936, 512)
--makers
graphic = graphic .. makeText(sciformat(game[3][2]), 328, 640)
--makers cost
graphic = graphic .. makeText(sciformat(buildingcosts[2]), 632, 640)
--makers making
graphic = graphic .. makeText(sciformat(multipliers[3]), 936, 640)
--upgrades
if colors[1] ~= "0" then
    graphic = graphic .. "\ncreate green " .. colors[1] .. " 56 0 128 0 128"
    graphic = graphic .. "\noverlay template green 432 696"
end
if colors[2] ~= "-8" then
    graphic = graphic .. "\ncreate black " .. colors[2] .. " 56 0 0 0 128"
    graphic = graphic .. "\noverlay template black " .. tostring(936 - colors[2]) .. " 696"
end
--render
graphic = graphic .. "\nrender template}\n"

--stats graphic
graphic = graphic .. "{" .. "iscript: "
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/stats.png stats"
graphic = graphic .. "\nload https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/numbers%20spritesheet.png spritesheet"
graphic = graphic .. "\ncreate cropped 40 40 0 0 0 255"
--start
graphic = graphic .. makeText(maketime(now - game[6][1]), 376, 424)
--prev
graphic = graphic .. makeText(maketime(difference), 776, 424)
--total
graphic = graphic .. makeText(scinotate(game[6][2]), 376, 552)
--coop
--graphic = graphic .. makeText(maketime(difference), 776, 552)
--render
graphic = graphic .. "\nrender stats}"



debug = tabletostring(game)
print(debug)
print(encode(debug))
print(graphic)
