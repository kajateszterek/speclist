local mouseX, mouseY, x, y, dx, dy, w, h = 0, 0, 25, 660, 0, 0, 300, 60;
local shouldDrag = false;
local font_title = draw.CreateFont("Bahnschrift SemiBold SemiCondensed", 16, 20);
local font_spec = draw.CreateFont("Tahoma", 13, 1);
local topbarSize = 25;
local windowmade = 0
local windowactive = 0
local window = gui.Window(window, "zero speclist & utilities", 200, 200, 500, 500)
local iconfont = draw.CreateFont("Wifi Icons", 25, 1 )
--local ittleszxd = gui.Reference("SETTINGS", "Miscellaneous")
--group1
local grp1 = gui.Groupbox(window, "Main", 10,10,235,450)
local enablespec = gui.Checkbox( grp1, "en_spec", "Enable Spectator List", 1 )
local hidespec = gui.Checkbox( grp1, "hidespec", "Hide Idle Spectator List", 0 )
local rgbmode = gui.Combobox( grp1, "rgbmode", "RGB Mode", "Animated", "Static" )
local line1 = gui.Slider(grp1 , "halig", "Line Fade Speed", 2.5, 0.1, 10 )
local vonal_alt = gui.Combobox( grp1, "miyu_ocsi_dd", "Line Options", "None", "Top", "Bottom" )
local thiccness = gui.Slider( grp1, "haligvastag", "Line Width", 2.5, 1, 5)
local fejszincombo = gui.Combobox( grp1, "miyu_ocsi_ddd", "Header text color", "Static", "RGB" )
local fejszin_alpha = gui.Slider( grp1, "dxh", "RGB header alpha", "100", "0", "255" )
local specline_thic = gui.Slider( grp1, "line_thic", "Spectator List Line Thickness", 2, 1, 3)
--group1 end
--group2
local grp2 = gui.Groupbox(window, "Anti-Aim", 255,10,235,450)
local aamode1 = gui.Combobox( grp2, "aamode", "Anti-Aim Mode", "Swing", "Jitter", "Offset" )
local aaspeed = gui.Slider( grp2, "aaspeed", "Anti-Aim Speed", 0.27, 0.1, 1 )
--[[local aamode = gui.Combobox( grp2, "aamode", "Anti-Aim Mode", "Offset", "Jitter", "Swing" )]]
--group2 end
--colors
local specszin = gui.ColorEntry( "dxhooker", "Spectators' name color ", 150, 200, 50, 255 )
local fejszin = gui.ColorEntry( "dxhooker", "Spectator list Header text color ", 150, 150, 150, 255 )
local outlinecol = gui.ColorEntry( "outlinecol", "Outline Color", 0, 0, 0, 255 )
local innneroutlinecol = gui.ColorEntry( "innneroutlinecol", "Inner Otline Color", 40, 40, 40, 255 )
local innercol = gui.ColorEntry( "innercol", "Inner Color", 0, 0, 0, 255)
--colors end


local render = {};

render.outline = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.OutlinedRect( x, y, x + w, y + h );
end

render.rect = function( x, y, w, h, col )
	draw.Color( col[1], col[2], col[3], col[4] );
	draw.FilledRect( x, y, x + w, y + h );
end

render.rect2 = function( x, y, w, h )
	draw.FilledRect( x, y, x + w, y + h );
end

render.gradient = function( x, y, w, h, col1, col2, is_vertical )
	render.rect( x, y, w, h, col1 );

	local r, g, b = col2[1], col2[2], col2[3];

	if is_vertical then
		for i = 1, h do
			local a = i / h * 255;
			render.rect( x, y + i, w, 1, { r, g, b, a } );
		end
	else
		for i = 1, w do
			local a = i / w * 255;
			render.rect( x + i, y, 1, h, { r, g, b, a } );
		end
	end
end





local function getSpectators()
    local spectators = {};
    local lp = entities.GetLocalPlayer();
    if lp ~= nil then
        local players = entities.FindByClass("CCSPlayer");
        local specI = 1;
        for i = 1, #players do
            local player = players[i];
            if player ~= lp and player:GetHealth() <= 0 then
                local name = player:GetName();
                if player:GetPropEntity("m_hObserverTarget") ~= nil then
                    local playerindex = player:GetIndex();
                    if name ~= "GOTV" and playerindex ~= 1 then
                        local target = player:GetPropEntity("m_hObserverTarget");
                        if target:IsPlayer() then
                            local targetindex = target:GetIndex();
                            local myindex = client.GetLocalPlayerIndex();
                            if lp:IsAlive() then
                                if targetindex == myindex then
                                    spectators[specI] = player;
                                    specI = specI + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return spectators;
end

local function drawRectFill(r, g, b, a, x, y, w, h, texture)
    if (texture ~= nil) then
        --draw.SetTexture(texture);
    else
        --draw.SetTexture(r, g, b, a);
    end
    draw.Color(r, g, b, a);
    draw.FilledRect(x, y, x + w, y + h);
end

local function drawGradientRectFill(col1, col2, x, y, w, h)
    drawRectFill(col1[1], col1[2], col1[3], col1[4], x, y, w, h);
    local r, g, b = col2[1], col2[2], col2[3];
    for i = 1, h do
        local a = i / h * col2[4];
        drawRectFill(r, g, b, a, x + 2, y + i, w - 2, 1);
    end
end

local function dragFeature()
    if input.IsButtonDown(1) then
        mouseX, mouseY = input.GetMousePos();
        if shouldDrag then
            x = mouseX - dx;
            y = mouseY - dy;
        end
        if mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + 40 then
            shouldDrag = true;
            dx = mouseX - x;
            dy = mouseY - y;
        end
    else
        shouldDrag = false;
    end
end

local function drawOutline(r, g, b, a, x, y, w, h, howMany)
    for i = 1, howMany do
        draw.Color(r, g, b, a);
        draw.OutlinedRect(x - i, y - i, x + w + i, y + h + i);
    end
end

function getFadeRGB(speed)
    local r = math.floor(math.sin(globals.RealTime() * speed) * 127 + 128)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)
    return {r, g, b};
end


local function openwindow()
	if gui.Reference("MENU"):IsActive() and windowactive == 0 then
		window:SetActive(1)
		windowactive = 1
	elseif not gui.Reference("MENU"):IsActive() and windowactive == 1 then
		window:SetActive(0)
	    windowactive = 0
    end
end

local function drawWindow(spectators)
    local h2 = h - 60 + (spectators * 11);
    local h = h + (spectators * 11);
    local rgb = getFadeRGB(line1:GetValue());
    local scrinx, scriny = draw.GetScreenSize()
    local gr, gg, gb, ga = innneroutlinecol:GetValue()
    local rr, rg, rb, ra = innercol:GetValue()
    
    -- Draw small outline
    draw.Color(outlinecol:GetValue());
    draw.OutlinedRect(x - 6, y - 6, x + w - 94, y + h - 15);

    -- Draw big outline
    drawOutline(gr, gg, gb, ga, x, y, w - 100, h - 20, 5);


    -- Draw the main bg
    drawRectFill(rr, rg, rb, ra, x, y, w - 100, h - 20);

    --[[local resetcol = gui.Button(ittleszxd, "Reset Colors", function()
		
        gr, gg, gb, ga = 0, 0, 0, 255 
        rr, rg, rb, ra = 40, 40, 40, 255 
        --outlinecol:SetValue( 0, 0, 0, 255 )
    end)]]
    -- Draw the text
    draw.Color(255, 255, 255);
    draw.SetFont(font_title);
    local spectext = spectators .. ' Spectators';
    local tW, _ = draw.GetTextSize(spectext);
    if fejszincombo:GetValue() == 0 then
        draw.Color( fejszin:GetValue())
    elseif fejszincombo:GetValue() == 1 then
        draw.Color( rgb[1], rgb[2], rgb[3], fejszin_alpha:GetValue() )
    end
    draw.Text(x + ((w - tW) / 3.4), y + 1, spectext)

    drawRectFill(27, 24, 25, 255, x + 7, y + 30, w - 115, h2);

    drawOutline(41, 35, 36, 255, x + 7, y + 30, w - 115, h2 , 2);

    if rgbmode:GetValue() == 0 then
	
    render.gradient( x , y + 18, w / 2 - 50, specline_thic:GetValue(), { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );

    render.gradient( x + ( w / 2 ) - 49, y + 18, w / 2 - 52, specline_thic:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );

    elseif rgbmode:GetValue() == 1 then

    render.gradient( x , y + 18, w / 2 - 50, specline_thic:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );

    render.gradient( x + ( w / 2 ) - 49, y + 18, w / 2 - 52, specline_thic:GetValue(), { 243, 0, 255, 200 }, { 224, 255, 0}, false );


    end

if rgbmode:GetValue() == 0 then
    ----------------------------------------------------------------------------------------------------------
    if vonal_alt:GetValue() == 0 then
     --
    
    elseif vonal_alt:GetValue() == 1 then
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    
    elseif vonal_alt:GetValue() == 2 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );

    --[[elseif vonal_alt:GetValue() == 3 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    render.gradient( 0 , thiccness:GetValue(), thiccness:GetValue(), scriny / 0.2 , { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, true);
    render.gradient( 0 , scriny / 1, thiccness:GetValue(), scriny , { rgb[3], rgb[2], rgb[1], 255 }, { rgb[2], rgb[3], rgb[1]}, true);
    render.gradient( scrinx - thiccness:GetValue() , thiccness:GetValue(), thiccness:GetValue(), scriny / 0.2 , {  rgb[1], rgb[2], rgb[3], 255 }, {rgb[2], rgb[3], rgb[1]}, true);
    render.gradient( scrinx - thiccness:GetValue() , scriny / 1, thiccness:GetValue(), scriny , { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, true);
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    
    --render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, true );
  ]]
end
elseif rgbmode:GetValue() == 1 then
    if vonal_alt:GetValue() == 0 then
        --
       
       elseif vonal_alt:GetValue() == 1 then
       render.gradient( 0 , 0, scrinx , thiccness:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );
       elseif vonal_alt:GetValue() == 2 then
   
       render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );
   
       --[[elseif vonal_alt:GetValue() == 3 then
   
       render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(),  { 30, 87, 153, 255 }, { 243, 0, 255}, false );
       render.gradient( 0 , 0, scrinx, thiccness:GetValue(),  { 30, 87, 153, 255 }, { 243, 0, 255}, false );
	--render.gradient( x + 133,  y + h - 7 , 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false );]]
       end
    end

end

local function watermark()


function hsvToR(h, s, v)
 local r, g, b

 local i = math.floor(h * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);

 i = i % 6

 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end

 return r * intensity
end

function hsvToG(h, s, v)
 local r, g, b

 local i = math.floor(s * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);

 i = i % 6

 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end

 return g * intensity
end

function hsvToB(h, s, v)
 local r, g, b

 local i = math.floor(v * 6);
 local f = h * 6 - i;
 local p = v * (1 - s);
 local q = v * (1 - f * s);
 local t = v * (1 - (1 - f) * s);

 i = i % 6

 if i == 0 then r, g, b = v, t, p
 elseif i == 1 then r, g, b = q, v, p
 elseif i == 2 then r, g, b = p, v, t
 elseif i == 3 then r, g, b = p, q, v
 elseif i == 4 then r, g, b = t, p, v
 elseif i == 5 then r, g, b = v, p, q
 end

 return b * intensity
end

-- credits to @Brotgeschmack#5901
function drawGradient(x,y,w,h,dir,colors)
    local size,clength = 0, 0;
    local red, green, blue,alpha = 0,0,0,0;
    local mr, mg, mb, ma= 0,0,0,0;
    
    for i = 1, #colors, 1 do
        size = size + 1;
    end
    
    if(dir == "up" or dir == "down") then
        clength = h / (size-1);
    else
        clength = w / (size-1);
    end
    
    for i,color in ipairs(colors) do
        local x1,y1 = x, y;
        local x2,y2 = x1+w, y1+h;
        if(colors[i+1] ~= nil) then
            red = color[1];
            mr = (color[1] - colors[i+1][1]) / clength;

            green = color[2];
            mg = (color[2] - colors[i+1][2]) / clength;
            
            blue = color[3];
            mb = (color[3] - colors[i+1][3]) / clength;

            alpha = color[4];
            ma = (color[4] - colors[i+1][4]) / clength;
            
            for j=0, clength, 1 do
                red = red - mr;
                green = green - mg;
                blue = blue - mb;
                alpha = alpha - ma;
                draw.Color(red,green,blue,alpha);
                if(dir == "right") then
                    draw.FilledRect(x1+j,y1,j+x1+1,y2+1);
                elseif(dir == "left") then
                    draw.FilledRect(x2-j,y1,x2-j+1,y2+1);    
                elseif(dir == "up") then
                    draw.FilledRect(x2+1,y2-j+1,x1,y2-j);                    
                else
                    draw.FilledRect(x1,y1+j,x2+1,y1+j+1);                                
                end
            end
            
            if(dir == "right") then
                x = x + clength;    
            elseif(dir == "left") then
                x = x - clength;    
            elseif(dir == "up") then
                y = y - clength;
            else
                y = y + clength;
            end
        end
    end
end

end


local function drawindicators(spectators)
    for index, player in pairs(spectators) do
        draw.SetFont(font_spec);
        draw.Color(specszin:GetValue());
        draw.Text(x + 10, (y + 20) + (index * 9.5), player:GetName())
    end 
end


local SCRIPT_FILE_NAME = GetScriptName();
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/kajateszterek/speclist/master/zerospec.lua";
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/kajateszterek/speclist/master/version.txt"; --- in case of update i need to update this. (Note by superyu'#7167 "so i don't forget it.")
local VERSION_NUMBER = "1.4"; --- This too

local version_check_done = false;
local update_downloaded = false;
local update_available = false;

--- Actual code

local function updateEventHandler()
    if (update_available and not update_downloaded) then
        if (gui.GetValue("lua_allow_cfg") == false) then
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[ZEROSPEC] An update is available, please enable Lua Allow Config and Lua Editing in the settings tab.");
        else
            local new_version_content = http.Get(SCRIPT_FILE_ADDR);
            local old_script = file.Open(SCRIPT_FILE_NAME, "w");
            old_script:Write(new_version_content);
            old_script:Close();
            update_available = false;
            update_downloaded = true;
        end
    end

    if (update_downloaded) then
        draw.Color(255, 0, 0, 255);
        draw.Text(0, 0, "[ZEROSPEC] An update has automatically been downloaded, please reload the script.");
        return;
    end

    if (not version_check_done) then
        if (gui.GetValue("lua_allow_http") == false) then
            draw.Color(255, 0, 0, 255);
            draw.Text(0, 0, "[ZEROSPEC] Please enable Lua HTTP Connections in your settings tab to use this script.");
            return;
        end

        version_check_done = true;
        local version = http.Get(VERSION_FILE_ADDR);
        if (version ~= VERSION_NUMBER) then
            update_available = true;
        end
    end
end



callbacks.Register("Draw", updateEventHandler);

local function versionwm()
    local xax = 120
    local rgb = getFadeRGB(line1:GetValue());
    local scrx, scry = draw.GetScreenSize()
    draw.Color( rgb[1], rgb[2], rgb[3], 200 )
    draw.SetFont(font_spec)
    draw.Text( xax, scry - 12, "Version: " .. VERSION_NUMBER)
    
end





callbacks.Register("Draw", function()


	 local lp = entities.GetLocalPlayer();
    --[[if lp == nil then
	return
    end]]
    
    local spectators = getSpectators();
    
    
    openwindow();
    versionwm();
    if enablespec:GetValue() then
        gui.SetValue( "msc_showspec", 0 )
      if hidespec:GetValue() then
        if (#spectators == 0) then
            return
        end
            drawWindow(#spectators);

      else
        drawWindow(#spectators);
      end
   
    else

    end
    
    drawindicators(spectators);
    dragFeature();
end)



local delay = aaspeed:GetValue()
local timer = timer or {}
local timers = {}


function timer.Create(name, delay, times, func)

    table.insert(timers, {["name"] = name, ["delay"] = delay, ["times"] = times, ["func"] = func, ["lastTime"] = globals.RealTime()})

end

function timer.Remove(name)

    for k,v in pairs(timers or {}) do
 
        if (name == v["name"]) then table.remove(timers, k) end
 
    end

end

function timer.Tick()

    for k,v in pairs(timers or {}) do
 
        if (v["times"] <= 0) then table.remove(timers, k) end
     
        if (v["lastTime"] + v["delay"] <= globals.RealTime()) then
            timers[k]["lastTime"] = globals.RealTime()
            timers[k]["times"] = timers[k]["times"] - 111
            v["func"]()
        end
 
    end

end

callbacks.Register( "Draw", "timerTick", timer.Tick);


timer.Create("Gay", 1, 2, function() Gay1() end)


function Gay1()
   
timer.Create("Gay1", aaspeed:GetValue(), aaspeed:GetValue(), function()
    if aamode1:GetValue() == 0 then
    gui.SetValue( "rbot_antiaim_stand_desync", 2 )
gui.SetValue( "rbot_antiaim_move_desync", 3 )
Gay2()
    elseif aamode1:GetValue() == 1 then
        gui.SetValue( "rbot_antiaim_stand_desync", 1 )
    gui.SetValue( "rbot_antiaim_move_desync", 3 )
    Gay2()
elseif aamode1:GetValue() == 2 then
    gui.SetValue( "rbot_antiaim_stand_desync", 1 )
gui.SetValue( "rbot_antiaim_move_desync", 3 )
    Gay2()
end
end)
end


function Gay2()
   
    timer.Create("Gay2", aaspeed:GetValue(), aaspeed:GetValue(), function()
        if aamode1:GetValue() == 0 then
        gui.SetValue( "rbot_antiaim_stand_desync", 3  )
gui.SetValue( "rbot_antiaim_move_desync", 2 )
        Gay1()
        elseif aamode1:GetValue() == 1 then
            gui.SetValue( "rbot_antiaim_stand_desync", 4 )
    gui.SetValue( "rbot_antiaim_move_desync", 4 )
            Gay1()
        elseif aamode1:GetValue() == 2 then
            gui.SetValue( "rbot_antiaim_stand_desync", 3 )
    gui.SetValue( "rbot_antiaim_move_desync", 2 )
            Gay1()
        end
    end)
end

--AA




--AA






local isActive = gui.Checkbox(grp2, "zero_flick_onshot", "Pitch Flick", 0)
local flickmode = gui.Combobox(grp2, "zero_flick_mode", "Flick Mode", "Up (Don't use Up Pitch)", "Down (Don't use Down/Emotion Pitch)", "Zero (Don't use Zero Pitch)" )
local flickTime = gui.Slider(grp2, "zero_msc_flick_time", "Flick Time (in ms)", 250, 1, 1000)
local shotTime = globals.CurTime();
local shooting = false;
local configRecover = true;
local oldBool = 0;
local oldMode = 0;
client.AllowListener("weapon_fire")

callbacks.Register( "Draw", function()

    if isActive:GetValue() then

 
        if not shooting then

            
            oldBool = gui.GetValue("rbot_antiaim_stand_pitch_real")
            oldMode = gui.GetValue("rbot_antiaim_move_pitch_real")
        end

        
        if shotTime + flickTime:GetValue() / 1000 < globals.CurTime() then
            gui.SetValue("rbot_antiaim_stand_pitch_real", oldBool)
            gui.SetValue("rbot_antiaim_move_pitch_real", oldMode)
            shooting = false
        end
    end
end)

callbacks.Register("FireGameEvent", function(event)

    if isActive:GetValue() then

        if event:GetName() == "weapon_fire" then 
           
            EventUserId = event:GetInt("userid") 
            pLocalInfo = client.GetPlayerInfo(client.GetLocalPlayerIndex()) 

            if pLocalInfo["UserID"] == EventUserId then 
           
                shooting = true 

               if flickmode:GetValue() == 0 then
                gui.SetValue("rbot_antiaim_stand_pitch_real", 3)
                gui.SetValue("rbot_antiaim_move_pitch_real", 3)
                configRecover = true
               elseif flickmode:GetValue() == 1 then
                gui.SetValue("rbot_antiaim_stand_pitch_real", 2)
                gui.SetValue("rbot_antiaim_move_pitch_real", 2)
                configRecover = true
            elseif flickmode:GetValue() == 2 then
                gui.SetValue("rbot_antiaim_stand_pitch_real", 4)
                gui.SetValue("rbot_antiaim_move_pitch_real", 4)
                configRecover = true
            end
                shotTime = globals.CurTime()
            end
        end
    end
end)








--onshot desync

local isActive1 = gui.Checkbox(grp2, "zero_desync_onshot", "On-shot desync", 0)
local shotTime1 = globals.CurTime();
local shooting1 = false;
local configRecover1 = true;
local oldBool1 = 0;
local oldMode1 = 0;
local oldBool11 = 0;
local oldMode11 = 0;
local oldBool21 = 0;
local oldMode21 = 0;
client.AllowListener("weapon_fire")

callbacks.Register( "Draw", function()

    if isActive1:GetValue() then

        -- Save Original Values if we aren't on the shooting fakelag.
        if not shooting1 then

            -- Actually save the values.
            oldBool1 = gui.GetValue("rbot_antiaim_stand_desync")
            oldMode1 = gui.GetValue("rbot_antiaim_move_desync")
            oldBool11 = gui.GetValue("rbot_antiaim_stand_real")
            oldMode11 = gui.GetValue("rbot_antiaim_move_real")
            oldBool21 = gui.GetValue("rbot_antiaim_stand_pitch_real")
            oldMode21 = gui.GetValue("rbot_antiaim_move_pitch_real")
        end

        -- Set Original values after the user defined time after the shot.
        if shotTime1 + 250 / 1000 < globals.CurTime() then
            gui.SetValue("rbot_antiaim_stand_desync", oldBool1)
            gui.SetValue("rbot_antiaim_move_desync", oldMode1)
            gui.SetValue("rbot_antiaim_stand_real", oldBool11)
            gui.SetValue("rbot_antiaim_move_real", oldMode11)
            gui.SetValue("rbot_antiaim_stand_pitch_real", oldBool21)
            gui.SetValue("rbot_antiaim_move_pitch_real", oldMode21)
            shooting1 = false
        end
    end
end)

callbacks.Register("FireGameEvent", function(event)

    if isActive1:GetValue() then

        if event:GetName() == "weapon_fire" then -- Check if the event is the weapon_fire event.
           
            EventUserId = event:GetInt("userid") -- Get the event userId (userId of the person that triggered the event/that shot)
            pLocalInfo = client.GetPlayerInfo(client.GetLocalPlayerIndex()) -- Get a table of information about our localplayer

            if pLocalInfo["UserID"] == EventUserId then -- Compare the eventUserId and the table entry with the local userId.
           
                shooting1 = true --- Set bool to true to make the settings recovering work.

                -- Set our wanted values.
                gui.SetValue("rbot_antiaim_stand_pitch_real", 0)
                gui.SetValue("rbot_antiaim_move_pitch_real", 0)
                gui.SetValue("rbot_antiaim_stand_real", 0)
                gui.SetValue("rbot_antiaim_move_real", 0)
                gui.SetValue("rbot_antiaim_stand_desync", 2)
                gui.SetValue("rbot_antiaim_move_desync", 2)
                configRecover1 = true

                -- Set our shot time so the settings recover can use it.
                shotTime1 = globals.CurTime()
            end
        end
    end
end)