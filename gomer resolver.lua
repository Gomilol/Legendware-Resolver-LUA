-- made by gomi pasted from my old resolver for skeet and hitlogs (fatal and nl)

local angles = {
    [1] = -55,
    [2] = 55,
    [3] = 38,
    [4] = -38,
    [5] = -29,
    [6] = 29,
    [7] = -15,
    [8] = 15,
    [9] = 0
}

local last_angle = 0
local new_angle = 0
local switch1 = false
local switch2 = false
local i = 1
local username = globals.get_username()

menu.add_check_box("Enable Resolver lua")
menu.add_check_box("force all players down")
print("Welcome " ..username) -- welcome our user to the resolver. (i like fucking with this function lmao)




-- note from gomi, fix the last angle check bullshit for logs instead of it just saying it missed at 0...


local function resolve(shot_info)
	local result = shot_info.result
	local gpinf = engine.get_player_info
	local target = shot_info.target_index
	local target_name = gpinf(target).name
   
    
    menu.set_bool("player_list.player_settings[" .. target.. "].force_body_yaw", true) -- we only want to bruteforce our target. not everyone
    
    if last_angle == -new_angle and switch1 then
        new_angle = -angles[i]
        if switch2 == true then
            switch1 = not switch1
        end
    else
        if i < #angles then
            i = i + 1
        else
            i = 1
        end
        new_angle = angles[i]
    end
    if last_angle == 0 then
        last_angle = "LW RESOLVER"
    end


	if result == "Resolver" and menu.get_bool("Enable Resolver lua") then
	print("[DEBUG] missed player: " ..target_name .. ", at angle: " .. last_angle .. ", bruteforced to: " .. new_angle) -- last_angle is broken and always says "0"
    
	menu.set_int("player_list.player_settings["..target.."].body_yaw", new_angle) -- so we dont have to do a for check
    end

    if result == "Hit" and menu.get_bool("Enable Resolver lua") then
        print("[DEBUG] hit player " ..target_name.. ", at angle: " .. new_angle)
    end
end

local function set_all_down()
    local all = globals.get_maxclients()

    if menu.get_bool("force all players down") then
        for nigger=1,64 do
        menu.set_bool("player_list.player_settings[" ..nigger.. "].force_pitch", true)
        menu.set_int("player_list.player_settings[" ..nigger.. "].pitch", 89)
        end
    end
end

client.add_callback("on_shot", resolve)
client.add_callback("on_paint", set_all_down)

if username == "Gomi" then
    console.execute("sv_lan 1")
else
end


