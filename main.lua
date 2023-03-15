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
game[6][3] = game[6][3] + 1

buildingcosts = {math.floor(10 * (2^game[3][1]) + 0.5), math.floor(1000 * (5^game[3][2]) + 0.5)}
upgradecosts = {10, 500, 1000, 50000, 1e5, 5e6, 1e7, 5e8}

--then, execute any commands
if input[2] == "buy" then
    if input[3] == "upgrade" then
        if type(tonumber(input[4])) == "number" then
            id = tonumber(input[4])
            if game[4][id] == nil then
                print("That upgrade doesn't exist!")
            elseif game[4][id] then
                print("You already have that upgrade!")
            else
                if game[2] < upgradecosts[id] then
                    print("You can't afford that upgrade!")
                else
                    game[2] = game[2] - upgradecosts[id]
                    game[4][id] = true
                    print("Bought upgrade!")
                end
            end
        else
            print("Not sure which upgrade you want to buy...")
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

debug = tabletostring(game)
print(debug)
print(encode(debug))
