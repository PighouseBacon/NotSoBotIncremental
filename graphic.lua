chars = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "E", "H", ".", ":", "!", "%"}
locs = {}
for i = 1, #chars do
    locs[chars[i]] = tostring(-6 * (i - 1))
end

--setup
graphic = "load https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/incremental.png\n"
graphic = graphic .. "load https://raw.githubusercontent.com/PighouseBacon/NotSoBotIncremental/main/pictures/spritesheet.png\n\n"
graphic = graphic .. "const fs = require('fs');\n"
graphic = graphic .. "const ImageScript = require('imagescript');\n"
graphic = graphic .. "(async () => {\n"
graphic = graphic .. "var back = await ImageScript.decode(fs.readFileSync(process.env.FILE_1));\n"
graphic = graphic .. "var spritesheet = await ImageScript.decode(fs.readFileSync(process.env.FILE_2));\n"
graphic = graphic .. "var cropped = new ImageScript.Image(5, 5);\n"

--resources
graphic = graphic .. makeText(sciformat(game[2]), 35, 13)
graphic = graphic .. makeText(sciformat(game[3][1] * getFormerValue()), 73, 13)
graphic = graphic .. makeText(sciformat(getClickValue()), 111, 13)
graphic = graphic .. makeText(sciformat(game[3][1]), 35, 29)
graphic = graphic .. makeText(sciformat(buildingcosts[1]), 73, 29)
graphic = graphic .. makeText(sciformat(getFormerValue()), 111, 29)
graphic = graphic .. makeText(sciformat(game[3][2]), 35, 45)
graphic = graphic .. makeText(sciformat(buildingcosts[2]), 73, 45)
graphic = graphic .. makeText(sciformat(getMakerValue()), 111, 45)

--upgrades
for i = 1, #game[4] do
    coords = tostring(122 + (38 * ((i - 1) % 2))) .. ", " .. tostring(26 * ((i - 1) // 2))
    if game[4][i] then
        graphic = graphic .. "var green = new ImageScript.Image(37, 21).fill(0x22B14C80);\n"
        graphic = graphic .. "back.composite(green, " .. coords .. ");\n"
    elseif game[2] < upgradecosts[i] then
        graphic = graphic .. "var black = new ImageScript.Image(37, 21).fill(0x00000080);\n"
        graphic = graphic .. "back.composite(black, " .. coords .. ");\n"
    end
end

--stats
graphic = graphic .. makeText(maketime(difference), 53, 65)
graphic = graphic .. makeText(maketime(now - game[6][1]), 53, 81)
if #game[5] > 1 then
    graphic = graphic .. "var cover = new ImageScript.Image(55, 7).fill(0xFFFFFFFF);\n"
    graphic = graphic .. "back.composite(cover, 4, 96);\n"
    graphic = graphic .. makeText(tostring(#game[5]), 53, 97)
end
graphic = graphic .. makeText(sciformat(game[6][2]), 111, 65)
graphic = graphic .. makeText(sciformat(game[6][3]), 111, 81)
--%done   graphic = graphic .. makeText(.. "%", 111, 97)


--finish
graphic = graphic .. "back.scale(10)\n"
graphic = graphic .. "const value = await back.encode();\n"
graphic = graphic .. "fs.writeFileSync('./output/file.png', value);\n"
graphic = graphic .. "})();"
print("{" .. "set:graphic|")
print(graphic)
print("}")
