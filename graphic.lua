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

--setup
graphic = "load https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/incremental.png\n"
graphic = graphic .. "load https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/numbers%20spritesheet.png\n\n"
graphic = graphic .. "const fs = require('fs');\n"
graphic = graphic .. "const ImageScript = require('imagescript');\n"
graphic = graphic .. "(async () => {\n"
graphic = graphic .. "const back = await ImageScript.decode(fs.readFileSync(process.env.FILE_1));\n"
graphic = graphic .. "const spritesheet = await ImageScript.decode(fs.readFileSync(process.env.FILE_2));\n"

--actual graphic
graphic = graphic .. "back.drawBox(10, 10, 10, 10, 0xFF0000FF)\n"

--finish
graphic = graphic .. "const value = await back.encode();\n"
graphic = graphic .. "fs.writeFileSync('./output/file.png', value);\n"
graphic = graphic .. "})();"
print(graphic)

--[[
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

--]]
