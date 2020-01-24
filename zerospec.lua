
local SCRIPT_FILE_NAME = GetScriptName();
local SCRIPT_FILE_ADDR = "https://raw.githubusercontent.com/kajateszterek/speclist/master/zerospec.lua";
local VERSION_FILE_ADDR = "https://raw.githubusercontent.com/kajateszterek/speclist/master/version.txt"; 
local VERSION_NUMBER = "3.0"; --- This too
local divider = " | "

local version_check_done = false;
local update_downloaded = false;
local update_available = false;

--- Actual code


local mouseX, mouseY, x, y, dx, dy, w, h = 0, 0, 25, 660, 0, 0, 300, 60;
local shouldDrag = false;
local font_title = draw.CreateFont("Bahnschrift SemiBold SemiCondensed", 16, 20);
local font_spec = draw.CreateFont("Tahoma", 13, 1);
local font_dot = draw.CreateFont("Tahoma", 22, 1000);
local topbarSize = 25;
local windowmade = 0
local windowactive = 0
local perspectiveref = gui.Reference("SETTINGS", "Miscellaneous")
local perspective_en = gui.Checkbox(perspectiveref, "show_perspective", "Perspective Menu", false);
local window = gui.Window(window, "Perspective.LUA", 250, 250, 990, 560)
local grpinfo = gui.Groupbox( window, "Client Info", 10, 470, 480, 50)
local updateinfo = gui.Text(grpinfo, "Perspective is up to date!")
--------------------------------------
local grpinfo2 = gui.Groupbox( window, "Version Info", 500, 470, 480, 50)
local build_date = gui.Text(grpinfo2, "Version: " .. VERSION_NUMBER .. divider .. "Build Date: " .. datumakurvaanyad )
-------------------------------------
--local ittleszxd = gui.Reference("SETTINGS", "Miscellaneous")
--group1
local grp1 = gui.Groupbox(window, "Main", 10,10,235,220)
local enablespec = gui.Checkbox( grp1, "en_spec", "Enable Spectator List", 1 )
local hidespec = gui.Checkbox( grp1, "hidespec", "Hide Idle Spectator List", 0 )
local rgbmode = gui.Combobox( grp1, "rgbmode", "RGB Mode", "Animated", "Animated(old)", "Gamesense", "Fatality" )
local line1 = gui.Slider(grp1 , "halig", "Line Fade Speed", 2.5, 0.1, 10 )
local specline_thic = gui.Slider( grp1, "line_thic", "Spectator List Line Thickness", 2, 1, 3)
local fejszincombo = gui.Combobox( grp1, "miyu_ocsi_ddd", "Header text color", "Static", "RGB" )
local fejszin_alpha = gui.Slider( grp1, "dxh", "RGB header alpha", "100", "0", "255" )
--local line2 = gui.Slider(grp1 , "halig", "Right Side Fade Speed", 1.1, 0.1, 10 )
local vonal_alt = gui.Combobox( grp1, "miyu_ocsi_dd", "Line Options", "None", "Top", "Bottom" )
local thiccness = gui.Slider( grp1, "haligvastag", "Line Width", 2.5, 1, 5)



--group1 end
--group2
local grp2 = gui.Groupbox(window, "Anti-Aim", 255,10,235,220)
local aamode1 = gui.Combobox( grp2, "aamode", "Anti-Aim Mode", "Off", "Swing", "Jitter", "Offset" )
local randomspeed = gui.Checkbox( grp2, "random_speed", "Randomize Speed", 0)
local aaspeed = gui.Slider( grp2, "aaspeed", "Anti-Aim Speed", 0.27, 0.1, 2 )
--[[local aamode = gui.Combobox( grp2, "aamode", "Anti-Aim Mode", "Offset", "Jitter", "Swing" )]]
--group2 end





local fourthgroup = gui.Groupbox(window, "Other", 255, 240, 235, 220);

local jompscoot = gui.Checkbox(fourthgroup, "jumpscoutfix", "Disable Auto-Strafer when standing", 0)

--------------------------
local grp5 = gui.Groupbox(window, "Player Visuals", 500,10,235,450)
local box_esp = gui.Checkbox(grp5, "vis_box", "Box", 1)
local healthbar = gui.Checkbox(grp5, "vis_hbar", "Health Bar", 1)
local name_esp = gui.Checkbox(grp5, "vis_name", "Name", 1)
local info_esp = gui.Checkbox(grp5, "vis_info", "Info", 1)
local weapon_esp = gui.Checkbox(grp5, "vis_weapon", "Weapon", 1)
local hit_log = gui.Checkbox(grp5, "vis_dmgmarker", "Damage Marker", 1)

------------------------------
local grp6 = gui.Groupbox(window, "Misc Visuals", 745,10,235,450)
local ComboCrosshair = gui.Combobox(grp6, "vis_sniper_crosshair", "Sniper Crosshair", "Off", "Engine Crosshair", "Engine Crosshair (+scoped)", "Aimware Crosshair", "Draw Crosshair")
local cross = gui.Checkbox(grp6, "crosshair", "Crosshair Dot", 0)
local x88 = gui.Checkbox(grp6, "x88", "x88cheats UI", 0 )
local x88posx = gui.Slider(grp6, "x88posx", "x88cheats X axis", 800, 800, 3000)
local impactmulti = gui.Multibox(grp6, 'Circle Bullet Impacts')
local BulletImpacts_Local = gui.Checkbox(impactmulti, "localimpact", "Local", false)
local BulletImpacts_Enemy = gui.Checkbox(impactmulti, "enemyimpact", "Enemy", false)
local BulletImpacts_Team = gui.Checkbox(impactmulti, "teamimpact", "Team", false)
local BulletImpacts_color_Local = gui.ColorEntry('clr_localimpact', 'Local Bullet Impacts', 255,255,255,255)
local BulletImpacts_color_Enemy = gui.ColorEntry('clr_enemyimpact', 'Enemy Bullet Impacts', 255,140,140,255)
local BulletImpacts_color_Team = gui.ColorEntry('clr_teamimpact', 'Team Bullet Impacts', 140,140,255,255)
local BulletImpacts_Time = gui.Slider(grp6, 'vis_bullet_impact_time', 'Bullet Impact Time', 4, 0, 10)
local hitmarker = gui.Checkbox(grp6,"Hitmarker", "Hitmarker", 0 )

------------------------------
--colors
local specszin = gui.ColorEntry( "dxhooker", "{Perspective}Spectators' name color ", 150, 200, 50, 255 )
local fejszin = gui.ColorEntry( "dxhooker", "{Perspective}Spectator list Header text color ", 150, 150, 150, 255 )
local outlinecol = gui.ColorEntry( "outlinecol", "{Perspective}Outline Color", 0, 0, 0, 255 )
local innneroutlinecol = gui.ColorEntry( "innneroutlinecol", "{Perspective}Inner Otline Color", 40, 40, 40, 255 )
local innercol = gui.ColorEntry( "innercol", "{Perspective}Inner Color", 0, 0, 0, 255)
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


local function crosshair()
    local lp = entities.GetLocalPlayer();
    local screenW, screenH = draw.GetScreenSize()
    if cross:GetValue() and lp ~= nil then
        draw.Color( 255, 0, 0, 255)
        draw.SetFont(font_dot)
        draw.Text( screenW / 2 - 2.175, screenH / 2 - 16.5, ".")
    end
        
end


local function velocityStuff()
    local switch = false;
    local del = globals.CurTime() + 0.100
    local lp = entities.GetLocalPlayer();
    if not lp then
        return
    end

    local vel = math.sqrt(lp:GetPropFloat( "localdata", "m_vecVelocity[0]" )^2 + lp:GetPropFloat( "localdata", "m_vecVelocity[1]" )^2)

    if jompscoot:GetValue() then
        if vel > 5 then
            gui.SetValue("msc_autostrafer_enable", 1)
        else
            gui.SetValue("msc_autostrafer_enable", 0)
        end
    end

    if del < globals.CurTime() then
        switch = not switch
        del = globals.CurTime() + 0.050
    end

    if vel > 3 then
        del = globals.CurTime() + 0.050
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
    local r = math.floor(math.sin(globals.RealTime() * speed) * 110 + 145)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 110 + 145)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 110 + 145)
    return {r, g, b};
end

function getFadefatylity(speed)
    local r = math.floor(math.sin(globals.RealTime() * speed) * 70)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 50)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 240)
    return {r, g, b};
end

function getFadefatylity1(speed)
    local r = math.floor(math.sin(globals.RealTime() * speed) * 235)
    local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 5)
    local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 90)
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
    if perspective_en:GetValue() and gui.Reference("MENU"):IsActive() then
        window:SetActive(1)
        windowactive = 1
    else
        window:SetActive(0)
        windowactive = 0
    end
end

local function drawWindow(spectators)
    local h2 = h - 60 + (spectators * 11);
    local h = h + (spectators * 11);
    local rgb = getFadeRGB(line1:GetValue());
    local bgr = getFadeRGB(line1:GetValue() + 1.6);
    local fatylity = getFadefatylity(1)
    local fatylity1 = getFadefatylity1(1)
    local scrinx, scriny = draw.GetScreenSize()
    local gr, gg, gb, ga = innneroutlinecol:GetValue()
    local rr, rg, rb, ra = innercol:GetValue()
    
    -- Draw small outline
    draw.Color(outlinecol:GetValue());
    draw.OutlinedRect(x - 6, y - 6, x + w - 94, y + h - 14);

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
	
        render.gradient( x , y + 18 , w / 2 - 50, specline_thic:GetValue(), { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );

        render.gradient( x + ( w / 2 ) - 49, y + 18, w / 2 - 52, specline_thic:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );

    elseif rgbmode:GetValue() == 1 then

        render.gradient( x , y + 18, w - 101, specline_thic:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );

    elseif rgbmode:GetValue() == 2 then

        render.gradient( x , y + 18, w / 2 - 50, specline_thic:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );

        render.gradient( x + ( w / 2 ) - 49, y + 18, w / 2 - 52, specline_thic:GetValue(), { 243, 0, 255, 200 }, { 224, 255, 0}, false );


    elseif rgbmode:GetValue() == 3 then

        render.gradient( x , y + 18, w - 101, specline_thic:GetValue(), { 70, 50, 240, 255}, { 235, 5, 90}, false );


    end


end



local function nagyvonal(w)

    local rgb = getFadeRGB(line1:GetValue());
    local bgr = getFadeRGB(line1:GetValue() + 1.6);
    local scrinx, scriny = draw.GetScreenSize()
    local gr, gg, gb, ga = innneroutlinecol:GetValue()
    local rr, rg, rb, ra = innercol:GetValue()
    local rgb = getFadeRGB(line1:GetValue());
if rgbmode:GetValue() == 0 then
    ----------------------------------------------------------------------------------------------------------
    if vonal_alt:GetValue() == 0 then
     --
    
    elseif vonal_alt:GetValue() == 1 then
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    
    elseif vonal_alt:GetValue() == 2 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );


end
elseif rgbmode:GetValue() == 1 then
    if vonal_alt:GetValue() == 0 then
        --
       
       elseif vonal_alt:GetValue() == 1 then
       render.gradient( 0 , 0, scrinx , thiccness:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );
       elseif vonal_alt:GetValue() == 2 then
   
       render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), {rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );
   
       
    --[[ render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(),  { 30, 87, 153, 255 }, { 243, 0, 255}, false );
        render.gradient( 0 , 0, scrinx, thiccness:GetValue(),  { 30, 87, 153, 255 }, { 243, 0, 255}, false );
	    render.gradient( x + 133,  y + h - 7 , 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false ); ]]
       end
    
elseif rgbmode:GetValue() == 2 then
    if vonal_alt:GetValue() == 0 then
        --
       
       elseif vonal_alt:GetValue() == 1 then
       render.gradient( 0 , 0, scrinx , thiccness:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );
       elseif vonal_alt:GetValue() == 2 then
   
       render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { 30, 87, 153, 255 }, { 243, 0, 255}, false );
   
       

       end
    elseif rgbmode:GetValue() == 3 then
        if vonal_alt:GetValue() == 0 then
            --
           
           elseif vonal_alt:GetValue() == 1 then
           render.gradient( 0 , 0, scrinx , thiccness:GetValue(), { 70, 50, 240, 255}, { 235, 5, 90}, false );
           elseif vonal_alt:GetValue() == 2 then
       
           render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { 70, 50, 240, 255}, { 235, 5, 90}, false );
       
           
    
           end
        end
end


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


local function drawindicators(spectators)
    for index, player in pairs(spectators) do
        draw.SetFont(font_spec);
        draw.Color(specszin:GetValue());
        draw.Text(x + 10, (y + 20) + (index * 9.5), player:GetName())
    end 
end



local function updateEventHandler()
    if (update_available and not update_downloaded) then
        if (gui.GetValue("lua_allow_cfg") == false) then
            draw.Color(255, 0, 0, 255);
            updateinfo:SetText("An update is available, please enable Lua Allow Config and Lua Editing in the settings tab.")
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
        updateinfo:SetText("An update has automatically been downloaded, please reload the script.")
        return;
    end

    if (not version_check_done) then
        if (gui.GetValue("lua_allow_http") == false) then
            updateinfo:SetText("Please enable Lua HTTP Connections in your settings tab to use this script.")
            return
        end

        version_check_done = true;
        local version = http.Get(VERSION_FILE_ADDR);
        if (version ~= VERSION_NUMBER) then
            update_available = true;
            updateinfo:SetText("Your Client Needs to Update")
        end
    end
end 





callbacks.Register("Draw", updateEventHandler);









callbacks.Register("Draw", function()
    

	 local lp = entities.GetLocalPlayer();
    --[[if lp == nil then
	return
    end]]
    
    local spectators = getSpectators();
    velocityStuff();
    openwindow();
    nagyvonal();
    crosshair();

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
    oldyaw3 = 0
    oldyaw4 = 0
    oldyaw3 = gui.GetValue("rbot_antiaim_stand_desync")
    oldyaw4 = gui.GetValue("rbot_antiaim_move_desync")
    if randomspeed:GetValue() then
    --aaspeed:SetValue(math.floor(math.sin((globals.RealTime()) * 2) * 1.45 + 1.55));
    aaspeed:SetValue(math.floor(math.sin((globals.RealTime() / 10) * 40) * 4) / 6)
    else

end


    timer.Create("Gay1", aaspeed:GetValue(), aaspeed:GetValue(), function()
        if aamode1:GetValue() == 0 then
            gui.SetValue( "rbot_antiaim_stand_desync", oldyaw3 )
            gui.SetValue( "rbot_antiaim_move_desync", oldyaw4 )
            Gay2()
        elseif aamode1:GetValue() == 1 then
    gui.SetValue( "rbot_antiaim_stand_desync", 2 )
    gui.SetValue( "rbot_antiaim_move_desync", 3 )
    Gay2()
    elseif aamode1:GetValue() == 2 then
        gui.SetValue( "rbot_antiaim_stand_desync", 1 )
    gui.SetValue( "rbot_antiaim_move_desync", 3 )
    Gay2()
    elseif aamode1:GetValue() == 3 then
    gui.SetValue( "rbot_antiaim_stand_desync", 1 )
    gui.SetValue( "rbot_antiaim_move_desync", 3 )
    Gay2()
end
end)
end


function Gay2()
    if randomspeed:GetValue() then
        
        aaspeed:SetValue(math.floor(math.sin((globals.RealTime() / 10) * 35) * 8) / 3)
        else
        end
    oldyaw1 = 0
    oldyaw2 = 0
    oldyaw1 = gui.GetValue("rbot_antiaim_stand_desync")
    oldyaw2 = gui.GetValue("rbot_antiaim_move_desync")
 
    timer.Create("Gay2", aaspeed:GetValue(), aaspeed:GetValue(), function()
        
        if aamode1:GetValue() == 0 then
            gui.SetValue( "rbot_antiaim_stand_desync", oldyaw1  )
            gui.SetValue( "rbot_antiaim_move_desync", oldyaw2 )
            Gay1()
        elseif aamode1:GetValue() == 1 then
        gui.SetValue( "rbot_antiaim_stand_desync", 3  )
gui.SetValue( "rbot_antiaim_move_desync", 2 )
        Gay1()
        elseif aamode1:GetValue() == 2 then
            gui.SetValue( "rbot_antiaim_stand_desync", 4 )
    gui.SetValue( "rbot_antiaim_move_desync", 4 )
            Gay1()
        elseif aamode1:GetValue() == 3 then
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
        if shotTime1 + 50 / 1000 < globals.CurTime() then
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



local primaryWeapons = {
    {"None", nil};
    { "SCAR 20 | G3SG1", "scar20" };
    { "SSG 008", "ssg08" };
    { "AWP", "awp" };
    { "G3 SG1 | AUG", "sg556" };
    { "AK 47 | M4A1", "ak47" };
};
local secondaryWeapons = {
    {"None", nil};
    { "Dual Elites", "elite" };
    { "Desert Eagle | R8 Revolver", "deagle" };
    { "Five Seven | Tec 9", "tec9" };
    { "P250", "p250" };
};
local armors = {
    { "None", nil, nil };
    { "Kevlar Vest", "vest", nil };
    { "Kevlar Vest + Helmet", "vest", "vesthelm" };
};
local granades = {
    { "None", nil, nil };
    { "Grenade", "hegrenade", nil };
    { "Flashbang", "flashbang", nil };
    { "Smoke Grenade", "smokegrenade", nil };
    { "Decoy Grenade", "decoy", nil };
    { "Molotov | Incindiary Grenade", "molotov", "incgrenade" };
};

local autoBuyGroup = gui.Groupbox(window, "Auto Buy", 10, 240, 235, 220);
local enabled = gui.Checkbox(autoBuyGroup, "zero_autobuy_masterswitch", "Enabled Auto Buy", false);
local printLogs = gui.Checkbox(autoBuyGroup, "zero_autobuy_printlogs", "Print Logs To Aimware Console", false);
local concatCommand = gui.Checkbox(autoBuyGroup, "zero_autobuy_concat", "Concact Buy Command", false);
concatCommand:SetValue(true);
local primaryWeaponSelection = gui.Combobox(autoBuyGroup, "zero_autobuy_primary_weapon", "Primary Weapon", primaryWeapons[1][1], primaryWeapons[2][1], primaryWeapons[3][1], primaryWeapons[4][1], primaryWeapons[5][1], primaryWeapons[6][1]);
local secondaryWeaponSelection = gui.Combobox(autoBuyGroup, "zero_autobuy_secondary_weapon", "Secondary Weapon", secondaryWeapons[1][1], secondaryWeapons[2][1], secondaryWeapons[3][1], secondaryWeapons[4][1], secondaryWeapons[5][1]);
local armorSelection = gui.Combobox(autoBuyGroup, "zero_autobuy_armor", "Armor", armors[1][1], armors[2][1], armors[3][1]);
armorSelection:SetValue(2);
local granadeSlot1 = gui.Combobox(autoBuyGroup, "zero_autobuy_grenade_slot_1", "Grenade Slot #1", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
granadeSlot1:SetValue(1);
local granadeSlot2 = gui.Combobox(autoBuyGroup, "zero_autobuy_grenade_slot_2", "Grenade Slot #2", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
granadeSlot2:SetValue(3);
local granadeSlot3 = gui.Combobox(autoBuyGroup, "zero_autobuy_grenade_slot_3", "Grenade Slot #3", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
granadeSlot3:SetValue(5);
local granadeSlot4 = gui.Combobox(autoBuyGroup, "zero_autobuy_grenade_slot_4", "Grenade Slot #4", granades[1][1], granades[2][1], granades[3][1], granades[4][1], granades[5][1], granades[6][1]);
granadeSlot4:SetValue(2);
local taser = gui.Checkbox(autoBuyGroup, "zero_autobuy_taser", "Buy Taser", false);
local defuseKit = gui.Checkbox(autoBuyGroup, "zero_autobuy_defusekit", "Buy Defuse Kit", false);

local function getSingleTableItem(selection, table)
    return table[selection:GetValue() + 1][2];
end

local function getMultiTableItems(seletion, table)
    local table = table[seletion:GetValue() + 1];
    return { table[2], table[3] };
end

local function insertToTableNonNull(tableToInsertTo, table1)
    for i = 1, #table1 do
        local item = table1[i];
        if (item ~= nil) then
            table.insert(tableToInsertTo, item);
        end
    end
end

local function inserToTableBool(tableToInserTo, bool, itemToInsert)
    if (bool:GetValue()) then
        table.insert(tableToInserTo, itemToInsert);
    end
end

local function buy(items, concat)
    local buyCommand = '';
    for i = 1, #items do
        local item = items[i];
        if (concat) then
            buyCommand = buyCommand .. 'buy "' .. item .. '"; ';
        else
            if (printLogs:GetValue()) then
                print('Bought x1 ' .. item);
            end;
            client.Command('buy "' .. item .. '";', true);
        end;
    end;
    if (buyCommand ~= '') then
        if (printLogs:GetValue()) then
            print('Bought x' .. #items .. ' items');
        end;
        client.Command(buyCommand);
    end;
end

callbacks.Register('FireGameEvent', function(e)
    local lp, en, ui = entities.GetLocalPlayer(), e:GetName(), client.GetPlayerIndexByUserID(e:GetInt('userid'));
    if (enabled:GetValue() ~= true or lp == nil or en ~= "player_spawn" or ui ~= lp:GetIndex()) then return
    end;
    local stuffToBuy = {};
    table.insert(stuffToBuy, getSingleTableItem(primaryWeaponSelection, primaryWeapons))
    table.insert(stuffToBuy, getSingleTableItem(secondaryWeaponSelection, secondaryWeapons));
    insertToTableNonNull(stuffToBuy, getMultiTableItems(armorSelection, armors));
    inserToTableBool(stuffToBuy, defuseKit, 'defuser');
    insertToTableNonNull(stuffToBuy, getMultiTableItems(granadeSlot1, granades));
    insertToTableNonNull(stuffToBuy, getMultiTableItems(granadeSlot2, granades));
    insertToTableNonNull(stuffToBuy, getMultiTableItems(granadeSlot3, granades));
    insertToTableNonNull(stuffToBuy, getMultiTableItems(granadeSlot4, granades));
    inserToTableBool(stuffToBuy, taser, 'taser');
    buy(stuffToBuy, concatCommand:GetValue());
end);




client.AllowListener("player_spawn");




local c_reg = callbacks.Register 
local b_toggle = input.IsButtonDown
local abs_frame_time = globals.AbsoluteFrameTime;
local draw_Line, draw_TextShadow, draw_Color, draw_Text, draw_FilledRect, client_WorldToScreen, draw_GetScreenSize, client_GetConVar, client_SetConVar, client_exec, PlayerNameByUserID, PlayerIndexByUserID, GetLocalPlayer, gui_SetValue, gui_GetValue, LocalPlayerIndex, c_AllowListener, cb_Register, g_tickcount, g_realtime, g_curtime, math_floor, math_sqrt, GetPlayerResources, entities_FindByClass, GetPlayerResources = draw.Line, draw.TextShadow, draw.Color, draw.Text, draw.FilledRect, client.WorldToScreen, draw.GetScreenSize, client.GetConVar, client.SetConVar, client.Command, client.GetPlayerNameByUserID, client.GetPlayerIndexByUserID, entities.GetLocalPlayer, gui.SetValue, gui.GetValue, client.GetLocalPlayerIndex, client.AllowListener, callbacks.Register, globals.TickCount, globals.RealTime, globals.CurTime, math.floor, math.sqrt, entities.GetPlayerResources, entities.FindByClass, entities.GetPlayerResources
local local_ref = gui.Reference("VISUALS", "YOURSELF", "Filter", "Enable" );
local boxcolor = gui.ColorEntry( "clr_box_esp", "{Perspective}Box Color", 255, 255, 255, 255 )
local namecolor = gui.ColorEntry( "clr_name_esp", "{Perspective}Name Color", 255, 255, 255, 255 )
local weaponcolor = gui.ColorEntry( "clr_weapon_esp", "{Perspective}Weapon Color", 255, 255, 255, 255 )
local hitcolor = gui.ColorEntry( "clr_dmg_esp", "{Perspective}Damage Color", 255, 0, 0, 125 )
local esp_font = draw.CreateFont("Visitor TT2 -BRK-", 10, 0)
local flag_font = draw.CreateFont("Visitor TT2 -BRK-", 10, 10)
--local headshot_font = draw.CreateFont("Visitor TT2 -BRK-", 16, 100)
local hit_font = draw.CreateFont("Visitor TT2 -BRK-", 16, 100)

local kill_logs = {}




function get_player_boundaries(player)
    local min_x, min_y, min_z = player:GetMins()
    local max_x, max_y, max_z = player:GetMaxs()
 
    return {min_x, min_y, min_z}, {max_x, max_y, max_z}
end
 
function get_player_position(player)
if (player ~= nil) then
    local x1, y1, z1 = player:GetAbsOrigin()
    return {x1, y1, z1}
	end
end
 
function w2s(pos)
    local x1, y1 = client.WorldToScreen(pos[1], pos[2], pos[3])
    if x1 == nil or y == nil then
        return nil
    end
    return {x1, y1}
end

function get_bounding_box(player)
    local mins, maxs = get_player_boundaries(player)
    local screen_pos, pos_3d, screen_top, top_3d
 
    pos_3d = get_player_position(player)
    pos_3d[3] = pos_3d[3] - 3
 
    top_3d = get_player_position(player)
	
	local duck_amt = player:GetPropFloat("m_flDuckAmount")

	local angels = player:GetPropFloat("m_angEyeAngles[0]")

	top_3d[3] = top_3d[3] + 79 - 14 * duck_amt - angels / 89 * 3
 
    screen_pos = w2s(pos_3d)
    screen_top = w2s(top_3d)
 
    if (screen_pos ~= nil and screen_top ~= nil) then
        local height = screen_pos[2] - screen_top[2]
 
        local width = height / 2.2
 
        local left = screen_pos[1] - width / 2
        local right = (screen_pos[1] - width / 2) + width
        local top = screen_top[2] + width / 5
        local bottom = screen_top[2] + height
 
        local box = {left = left, right = right, top = top, bottom = bottom}
 		--CODED BY L3D451R7 POSHEL NAHUI NN
        return box
    end
 
    return nil
end

function is_me(player)
    return (player:GetIndex() == client.GetLocalPlayerIndex())
end
 
function is_enemy(player)
    return (entities.GetLocalPlayer():GetTeamNumber() ~= player:GetTeamNumber())
end

function draw_text(text, pos, centered, shadow, font, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.SetFont(font)

    if pos ~= nil then

    local _x, _y = pos[1], pos[2]
    if (centered) then
        local w1, h1 = draw.GetTextSize(text)
        _x = _x - w1 / 2
    end
    if (shadow) then
        draw.TextShadow(_x, _y, text)
    else--CODED BY L3D451R7 POSHEL NAHUI NN
        draw.Text(_x, _y, text)
    end
end
end

function rect_outline(pos1, pos2, color, outline_color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.OutlinedRect(pos1[1], pos1[2], pos2[1], pos2[2])
 
    draw.Color(outline_color[1], outline_color[2], outline_color[3], outline_color[4])
    draw.OutlinedRect(pos1[1] - 1, pos1[2] - 1, pos2[1] + 1, pos2[2] + 1)
    draw.OutlinedRect(pos1[1] + 1, pos1[2] + 1, pos2[1] - 1, pos2[2] - 1)
end
 
function rect_fill(pos1, pos2, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.FilledRect(pos1[1], pos1[2], pos2[1], pos2[2])
end
 
function get_text_size(text, font)
    draw.SetFont(font)
    local w1, h1 = draw.GetTextSize(text)
    return {w1, h1}
end
 
function get_screen_size()
    local w1, h1 = draw.GetScreenSize()
    return {w1, h1}
end
 
function draw_line(pos1, pos2, color)
    draw.Color(color[1], color[2], color[3], color[4])
    draw.Line(pos1[1], pos1[2], pos2[1], pos2[2])
end

local function KuSloEb_DrAwInG(e)
    w1, h1 = draw.GetScreenSize()
    w1 = w1/2
    h1 = h1/2 + 10
--CODED BY L3D451R7 POSHEL NAHUI NN
    local local_player = entities.GetLocalPlayer()
    local screen_size = get_screen_size()
 
    if (local_player ~= nil) then
        -- esp
        local players = entities.FindByClass("CCSPlayer")
        for i = 1, #players do
            local player = players[i]
            if (is_enemy(player) and player:IsAlive() or is_me(player) and player:IsAlive() and local_ref:GetValue() ~= false) then
                -- get bounding box
                local aye = 0
                local bbox = get_bounding_box(player)
                if (bbox ~= nil) then
                    -- box
					if box_esp:GetValue() ~= false then
                        rect_outline({bbox.left, bbox.top}, {bbox.right, bbox.bottom}, {boxcolor:GetValue()}, {0, 0, 0, 200})
                        gui.SetValue( "esp_enemy_box", 0 )
					end
                    -- health
                    if healthbar:GetValue() ~= false then
                    gui.SetValue( "esp_enemy_health", 0 )
                    rect_fill({bbox.left - 6, bbox.top - 1}, {bbox.left - 2, bbox.bottom + 1}, {0, 0, 0, 130})
                    local hp = math.min(player:GetHealth(), 100)
                    local height = bbox.bottom - bbox.top - 1
                    local healthbar_height = (hp / 100) * height

					local hp_percent = h1 - ((h1 * hp) / 100);

					local width = (w1 * (hp / 100.0));

					local red = 255 - (hp*2.55);
					local green = hp * 2.55;

                    rect_fill(
                        {bbox.left - 5, bbox.bottom - healthbar_height - 1},
                        {bbox.left - 3, bbox.bottom},
                        {red, green, 0, 200}
                    )
                    if (hp < 95) then
                    	draw_text(
                        	hp,
                        	{bbox.left - 4, bbox.bottom - healthbar_height - 6},
                        	true,
                        	true,
                        	flag_font,
                        	{255, 255, 255, 200})
                	end
					end
                    -- name
                    local name = player:GetName()
                    if name_esp:GetValue() ~= false then
                    gui.SetValue( "esp_enemy_name", 0 )
                    draw_text(
                        name,
                        {bbox.left + (bbox.right - bbox.left) / 2, bbox.top - 13},
                        true,
                        true,
                        esp_font,
                        {namecolor:GetValue()}
                    )
					end
					--CODED BY L3D451R7 POSHEL NAHUI NN
                    if info_esp:GetValue() ~= false then
                    gui.SetValue( "esp_enemy_hasc4", 0 )
                    gui.SetValue( "esp_enemy_hasdefuser", 0 )
                    gui.SetValue( "esp_enemy_defusing", 0 )
                    gui.SetValue( "esp_enemy_flashed", 0 )
                    gui.SetValue( "esp_enemy_scoped", 0 )
                    gui.SetValue( "esp_enemy_reloading", 0 )
                    local flags = ""

 					local latency = math.min(entities.GetPlayerResources():GetPropInt("m_iPing", player:GetIndex()), 1000)

					local red_l = latency*0.255;
					local green_l = 255 - latency * 0.255;

 					if (player:GetPropInt("m_bIsScoped") == 1) then
                        draw_text("ZOOM", {bbox.right + 2, bbox.top - 2 + aye * 9}, false, true, flag_font, {0, 185, 255, 200})
                        aye = aye + 1
                     elseif (player:GetPropInt("m_bIsScoped") == 0) then
                     
                    end

                    if (latency > 70) then
                        draw_text(latency, {bbox.right + 2, bbox.top - 2 + aye * 9}, false, true, flag_font, {red_l, green_l, 0, 200})
                        aye = aye + 1
                    end

                    if (player:GetPropInt("m_bHasHelmet") == 1) then
                        flags = flags .. "H"
                    end
 
                    if (player:GetPropInt("m_ArmorValue") ~= 0) then
                        flags = flags .. "K"
                    end
 
                    if (flags ~= "") then
                        draw_text(flags, {bbox.right + 2, bbox.top - 2 + aye * 9}, false, true, flag_font, {info, 200})
                        aye = aye + 1
                    end
					end
                    -- weapon
                    local weapon = player:GetPropEntity("m_hActiveWeapon")
                    if (weapon ~= nil and weapon_esp:GetValue() ~= false) then
                        gui.SetValue( "esp_enemy_weapon", 0 )
                        local weapon_name = weapon:GetClass()
                        weapon_name = weapon_name:gsub("CWeapon", "")
                        weapon_name = weapon_name:gsub("CKnife", "knife")
                        weapon_name = weapon_name:lower()
 
                        if (weapon_name:sub(1, 1) == "c") then
                            weapon_name = weapon_name:sub(2)--CODED BY L3D451R7 POSHEL NAHUI NN
                        end
 
                        draw_text(
                            weapon_name,
                            {bbox.left + (bbox.right - bbox.left) / 2, bbox.bottom + 1},
                            true,
                            true,
                            esp_font,
                            {weaponcolor:GetValue()}
                        )
                    end
                end
            end
        end
    end

    if hit_log:GetValue() == true then
        step = 255 / 0.3 * globals.FrameTime()
        gui.SetValue( "esp_enemy_damage", 0 )
		for index = 1, 10, 1 do

			local data = kill_logs[index]

			if data ~= nil then
				local alpha = 0

				if data.time > globals.RealTime() then alpha = 255 else
		       		alpha = alpha - (255 / 0.3 * globals.FrameTime())
		    	end

			    if alpha > 0 and data.position ~= nil then

                    data.position[3] = data.position[3] + 0.15
                    --alpha = alpha - (255 / 0.3 * globals.FrameTime())
			    	local lul = data.position[3] + 75

			    	local pos_2d = w2s({data.position[1], data.position[2], lul})
			    	--CODED BY L3D451R7 POSHEL NAHUI NN
			    	draw_text(data.text,pos_2d,true,true,hit_font,{hitcolor:GetValue()})
		    	end
		    end
		end
	end
end

local function KuSloEb_GaMeEvEnT( event , e)
    
	local local_player = client.GetLocalPlayerIndex()

	if event:GetName() == "player_hurt" then
		local userid = client.GetPlayerIndexByUserID(event:GetInt("userid"))
        local attacker = client.GetPlayerIndexByUserID(event:GetInt("attacker"))
        local hitgroup = event:GetInt("hitgroup")
        local damageDone = event:GetInt("dmg_health")
        
        if attacker == local_player and userid ~= local_player then

        	for i = 10, 2, -1 do 
            	kill_logs[i] = kill_logs[i-1]
        	end

        	local text = "-" .. damageDone

        	if hitgroup == 1 then
        		text = "-" .. damageDone
        	end


        	kill_logs[1] =
        	{ 
            ["position"] = get_player_position(entities.GetByIndex(userid)), 
            ["time"] = globals.RealTime() + 2,
          	["text"] = text
        	}
        end
	end
end

c_reg( "Draw", KuSloEb_DrAwInG)
c_reg( "FireGameEvent", KuSloEb_GaMeEvEnT)
client.AllowListener("player_hurt")
--CODED BY L3D451R7 POSHEL NAHUI NN





















function ifCrosshair()
    if GetLocalPlayer() == nil then return; end
    local Weapon = GetLocalPlayer():GetPropEntity("m_hActiveWeapon");
    local Scoped = GetLocalPlayer():GetProp("m_bIsScoped") == 1 or GetLocalPlayer():GetProp("m_bIsScoped") == 257
    if Weapon == nil then return; end
    local cWep = Weapon:GetClass();
    if cWep == "CWeaponAWP" or cWep == "CWeaponSSG08" or cWep == "CWeaponSCAR20" or cWep == "CWeaponG3SG1" then drawCrosshair = true; 
    else drawCrosshair = false; end 
    local screenCenterX, screenY = draw_GetScreenSize(); local scX, scY = screenCenterX / 2, screenY / 2;
    if drawCrosshair == true and ComboCrosshair:GetValue() == 0 then client_SetConVar("weapon_debug_spread_show", 0, true)
    elseif drawCrosshair == true and ComboCrosshair:GetValue() == 1 then gui_SetValue('esp_crosshair', false); if Scoped then client_SetConVar("weapon_debug_spread_show", 0, true); else client_SetConVar("weapon_debug_spread_show", 3, true) end
    elseif drawCrosshair == true and ComboCrosshair:GetValue() == 2 then gui_SetValue('esp_crosshair', false); client_SetConVar("weapon_debug_spread_show", 3, true)
    elseif drawCrosshair == true and ComboCrosshair:GetValue() == 3 then if Scoped then gui_SetValue('esp_crosshair', false); else client_SetConVar("weapon_debug_spread_show", 0, true); gui_SetValue('esp_crosshair', true); end 
    elseif drawCrosshair == false and ComboCrosshair:GetValue() == 3 then gui_SetValue('esp_crosshair', false)
    elseif drawCrosshair == true and ComboCrosshair:GetValue() == 4 then client_SetConVar("weapon_debug_spread_show", 0, true); gui_SetValue('esp_crosshair', false); draw.SetFont(font);
    draw.Color(255,255,255,255); draw.Line(scX, scY - 8, scX, scY + 8); --[[ line down ]] draw.Line(scX - 8, scY, scX + 8, scY); --[[ line across ]] end end
    callbacks.Register("Draw", "sniper crosshairs", ifCrosshair);
    





    local hitsound = gui.Checkbox( grp6, "hitsound", "Hit Sound", 1 )


function Sounds( Event, Entity )
if hitmarker:GetValue() then
    gui.SetValue( "msc_hitmarker_enable", 0 )
if ( Event:GetName() == 'player_hurt' ) then

    local HITGROUP = Event:GetInt("hitgroup");
    local ENTITY_LOCAL_PLAYER = client.GetLocalPlayerIndex();

    local INT_UID = Event:GetInt( 'userid' );
    local INT_ATTACKER = Event:GetInt( 'attacker' );

    local NAME_Victim = client.GetPlayerNameByUserID( INT_UID );
    local INDEX_Victim = client.GetPlayerIndexByUserID( INT_UID );

    local NAME_Attacker = client.GetPlayerNameByUserID( INT_ATTACKER );
    local INDEX_Attacker = client.GetPlayerIndexByUserID( INT_ATTACKER );
    -----
if hitsound:GetValue() then 
    if (INDEX_Attacker == ENTITY_LOCAL_PLAYER and HITGROUP == 1) then
        client.Command("play rust_hs.wav", true);
    end

    if (INDEX_Attacker == ENTITY_LOCAL_PLAYER and HITGROUP ~= 1) then
        client.Command("play buttons/arena_switch_press_02.wav", true);
    end

else

end
-----
end
else
    
end

end




local hmred = gui.Slider(grp6, "hmred", "Hitmarker red", 255, 0, 255 )
local hmgreen = gui.Slider(grp6, "hmgreen", "Hitmarker green", 0, 0, 255 )
local hmblue = gui.Slider(grp6, "hmblue", "Hitmarker blue", 0, 0, 255 )
local fogtext = gui.Text(grp6, "-------------------Fog Utilities-----------------" )


alpha = 0


function hittermark() 
    if hitmarker:GetValue() then
local screencenterX, screencenterY = draw.GetScreenSize() --getting the full screensize
screencenterX = screencenterX / 2; screencenterY = screencenterY / 2 --dividing the screensize by 2 will place it perfectly in the center no matter what resolution
draw.Color( hmred:GetValue(),hmgreen:GetValue(),hmblue:GetValue(), alpha)

draw.Line(screencenterX - 7, screencenterY + 7, screencenterX - 3, screencenterY + 3)
draw.Line(screencenterX - 7, screencenterY - 7, screencenterX - 3, screencenterY - 3)
draw.Line(screencenterX + 7, screencenterY + 7, screencenterX + 3, screencenterY + 3)
draw.Line(screencenterX + 7, screencenterY - 7, screencenterX + 3, screencenterY - 3)
draw.Line(screencenterX - 8, screencenterY + 8, screencenterX - 3, screencenterY + 3)
draw.Line(screencenterX - 8, screencenterY - 8, screencenterX - 3, screencenterY - 3)
draw.Line(screencenterX + 8, screencenterY + 8, screencenterX + 3, screencenterY + 3)
draw.Line(screencenterX + 8, screencenterY - 8, screencenterX + 3, screencenterY - 3)
draw.Line(screencenterX - 9, screencenterY + 9, screencenterX - 3, screencenterY + 3)
draw.Line(screencenterX - 9, screencenterY - 9, screencenterX - 3, screencenterY - 3)
draw.Line(screencenterX + 9, screencenterY + 9, screencenterX + 3, screencenterY + 3)
draw.Line(screencenterX + 9, screencenterY - 9, screencenterX + 3, screencenterY - 3)
draw.Line(screencenterX - 8, screencenterY + 8, screencenterX - 3, screencenterY + 3)
draw.Line(screencenterX - 8, screencenterY - 8, screencenterX - 3, screencenterY - 3)
draw.Line(screencenterX + 8, screencenterY + 8, screencenterX + 3, screencenterY + 3)
draw.Line(screencenterX + 8, screencenterY - 8, screencenterX + 3, screencenterY - 3)
draw.Line(screencenterX - 10, screencenterY + 10, screencenterX - 3, screencenterY + 3)
draw.Line(screencenterX - 10, screencenterY - 10, screencenterX - 3, screencenterY - 3)
draw.Line(screencenterX + 10, screencenterY + 10, screencenterX + 3, screencenterY + 3)
draw.Line(screencenterX + 10, screencenterY - 10, screencenterX + 3, screencenterY - 3)

if(alpha > 0) then
    alpha = alpha / 1.08
    end

else
end
end


function enemyhit(event)
    if hitmarker:GetValue() then
    if(event:GetName() == "player_hurt") then --if the game event "player_hurt" gets called then
        local attacker = event:GetInt("attacker") --getting the attacker 
        local attackerindex = client.GetPlayerIndexByUserID(attacker) --retrieves the attackers entity index by using the GetPlayerIndexByUserID function aimwares api provides us
        if(attackerindex == client.GetLocalPlayerIndex()) then --if the attackers index for the player who got hurt matches the localplayer index, it means we're the attacker
        alpha = 255
        end
    end
else
end
end

callbacks.Register( "FireGameEvent", "enemyhitfunction", enemyhit)
callbacks.Register( "Draw", "hittermark", hittermark)
callbacks.Register( 'FireGameEvent', 'Hitsound', Sounds );





---------------------------------
--name: x88 lua te aut mit gondoltal :ddd
--author: zero
--romanok ellen kft copyright 2019
---------------------------------









local font = draw.CreateFont('Stratum2-Bold', 17);
local frame_rate = 0.0
local get_abs_fps = function()
    frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
    return math.floor((1.0 / frame_rate) + 0.5)
end


local kills  = {}
local deaths = {}


local function KillDeathCount(event)

	local local_player = client.GetLocalPlayerIndex( );
	local INDEX_Attacker = client.GetPlayerIndexByUserID( event:GetInt( 'attacker' ) );
	local INDEX_Victim = client.GetPlayerIndexByUserID( event:GetInt( 'userid' ) );

	if (event:GetName( ) == "client_disconnect") or (event:GetName( ) == "begin_new_match") then
		kills = {}
		deaths = {}
	end

	if event:GetName( ) == "player_death" then
		if INDEX_Attacker == local_player then
			kills[#kills + 1] = {};
		end
		
		if (INDEX_Victim == local_player) then
			deaths[#deaths + 1] = {};
		end

	end
end

function RandomVariable(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function paint_traverse()
    local x, y = draw.GetScreenSize()
    local centerX = x / 2
    local centerx = y / 2

    --the bar idk lol
if entities.GetLocalPlayer() ~= nil then

         PING = entities.GetPlayerResources():GetPropInt( "m_iPing", client.GetLocalPlayerIndex() );
        ip = engine.GetServerIP();
        if (engine.GetServerIP() ~= "loopback") then
            ip = engine.GetServerIP()
        else
            ip = "Local Session"
        end


end
    function DrawPingColor()
        
        if ( PING <= 50 ) then
            draw.Color(0, 255, 0, 255); -- keto
        elseif ( PING <= 70 ) then
            draw.Color( 50, 255, 0, 255 );
        elseif ( PING <= 90 ) then
            draw.Color( 100, 255, 0, 255 );
        elseif ( PING <= 120 ) then
            draw.Color( 150, 255, 0, 255 );
        elseif ( PING <= 150 ) then
            draw.Color( 200, 255, 0, 255 );
        elseif ( PING <= 170 ) then
            draw.Color( 255, 255, 0, 255 ); -- haroomm
        elseif ( PING <= 190 ) then
            draw.Color( 255, 200, 0, 255 ); 
        else
            draw.Color( 255, 0, 0, 255 ); 
        end
end


    function DrawFpsColor()

    if ( get_abs_fps() <= 60 ) then
        draw.Color(255, 0, 0, 255); -- piros xd
    elseif ( get_abs_fps() <= 120 ) then
        draw.Color( 50, 255, 0, 255 );
    elseif ( get_abs_fps() >= 120 ) then
        draw.Color( 0, 255, 0, 255 ); -- piros zold kek akor serintem ez zod lesy :)
    end

end



local tp_dist = gui.GetValue("vis_thirdperson_dist")
local fagnam = client.GetPlayerNameByIndex(client.GetLocalPlayerIndex())

local anyd = math.random(10000)
local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' -- eleg jo paszta elso helyrol amit lattam pasta 8-) igaz hekermen
local length = 9
local randomString = ''

math.randomseed(anyd)

charTable = {}
for c in chars:gmatch"." do
    table.insert(charTable, c)
end

for i = 1, length do
    randomString = randomString .. charTable[math.random(1, #charTable)]
end


    if entities.GetLocalPlayer() == nil and x88:GetValue() then
        draw.SetFont(font);
        draw.Color(255, 255, 0, 255)
        draw.Text(x88posx:GetValue() - 550, y - 1040, "Hello zero :)")
        draw.Text(x88posx:GetValue() - 550, y - 1020, "Hello " .. fagnam .. ":)")
        draw.Text(x88posx:GetValue() - 470, y - 1040, "ANTI-UT:")
        if gui.GetValue("msc_restrict") == 0 then
            draw.Color(255, 0, 0, 255)
            draw.Text(x88posx:GetValue() - 415, y - 1040, "OFF")
            elseif gui.GetValue("msc_restrict") == 1 then
                draw.Color(0, 0, 255, 255)
            draw.Text(x88posx:GetValue() - 415, y - 1040, "SMAC")
            else 
                draw.Color(0, 255, 0, 255)
            draw.Text(x88posx:GetValue() - 415, y - 1040, "ON")
            end
             draw.Color(255, 255, 255, 255)
        elseif entities.GetLocalPlayer() ~= nil and x88:GetValue() then
    draw.SetFont(font);
    draw.Color(255, 255, 0, 255)
    draw.Text(x88posx:GetValue() - 550, y - 1040, "Hello zero :)")
    draw.Text(x88posx:GetValue() - 460, y - 1020, "Server: " .. ip)
    draw.Text(x88posx:GetValue() - 550, y - 1020, "Hello " .. fagnam .. " :)")
    draw.Text(x88posx:GetValue() - 470, y - 1040, "ANTI-UT:")
    if gui.GetValue("msc_restrict") == 0 then
        draw.Color(255, 0, 0, 255)
        draw.Text(x88posx:GetValue() - 415, y - 1040, "OFF")
        elseif gui.GetValue("msc_restrict") == 1 then
            draw.Color(0, 0, 255, 255)
        draw.Text(x88posx:GetValue() - 415, y - 1040, "SMAC")
        else 
            draw.Color(0, 255, 0, 255)
        draw.Text(x88posx:GetValue() - 415, y - 1040, "ON")
        end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 1000, "Ragebot:")
        if gui.GetValue("rbot_active") then
            draw.Color( 255, 0, 0, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 1000,  "WARNING: ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 1000,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 980, "Resolver:")
        if gui.GetValue("rbot_resolver") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 980,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 980,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 960, "Double Fire:")
        if gui.GetValue("rbot_doublefire") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 960,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 960,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 940, "AntiAim:")
        if gui.GetValue("rbot_antiaim_enable") then
            draw.Color( 255, 0, 0, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 940,  "WARNING: ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 940,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 920, "AA Mode:")
        if gui.GetValue("rbot_antiaim_enable") then
            draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 920,  "Normal" ); 
        elseif gui.GetValue("lbot_antiaim") > 0 then
            draw.Text(x88posx:GetValue() - 460, y - 920,  "Legit-trolling" ); 
        else 
            draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 920,  "OFF" );
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 900, "EnemyESP:")
        if gui.GetValue("esp_filter_enemy") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 900,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 900,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 880, "NameESP:")
        if gui.GetValue("esp_enemy_name") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 880,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 880,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 860, "Chams:")
        if gui.GetValue("esp_enemy_chams") == 0 then
            draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "OFF" ); 
        elseif gui.GetValue("esp_enemy_chams") == 1 then
        draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "CLR" ); 
        elseif gui.GetValue("esp_enemy_chams") == 2 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "MAT" ); 
        elseif gui.GetValue("esp_enemy_chams") == 3 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "CLR WRF" ); 
        elseif gui.GetValue("esp_enemy_chams") == 4 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "MAT WRF" ); 
        elseif gui.GetValue("esp_enemy_chams") == 5 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "INVIS" ); 
        elseif gui.GetValue("esp_enemy_chams") == 6 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "METAL" ); 
        elseif gui.GetValue("esp_enemy_chams") == 7 then
            draw.Color( 0, 0, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 860,  "FLAT" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 840, "WeaponESP:")
        if gui.GetValue("esp_filter_weapon") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 840,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 840,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 820, "SpectatorList:")
        if gui.GetValue("msc_showspec") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 820,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 820,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 800, "Radar:")
        if gui.GetValue("esp_radar") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 800,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 800,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 550, y - 780, "NoSky:")
        if gui.GetValue("vis_nosky") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 780,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 460, y - 780,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 1000, "Auto-Accept:")
        if gui.GetValue("msc_autoaccept") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 1000,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 1000,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 980, "AutoStrafer:")
    draw.Color(150, 201, 140, 255)
        if gui.GetValue("msc_autostrafer_mode") == 1 then
                draw.Color( 0, 0, 255, 255 );
                draw.Text(x88posx:GetValue() - 370, y - 940,  "SILENT" ); 
            elseif gui.GetValue("msc_autostrafer_mode") == 2 then
                draw.Color( 0, 0, 255, 255 );
                draw.Text(x88posx:GetValue() - 370, y - 940,  "NORMAL" ); 
            elseif gui.GetValue("msc_autostrafer_mode") == 3 then
                draw.Color( 0, 0, 255, 255 );
                draw.Text(x88posx:GetValue() - 370, y - 940,  "SIDE" ); 
            elseif gui.GetValue("msc_autostrafer_mode") == 4 then
                draw.Color( 0, 0, 255, 255 );
                draw.Text(x88posx:GetValue() - 370, y - 940,  "W-ONLY" ); 
            elseif gui.GetValue("msc_autostrafer_mode") == 5 then
                draw.Color( 0, 0, 255, 255 );
                draw.Text(x88posx:GetValue() - 370, y - 940,  "MOUSE" ); 
        end
        draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 960, "Ranks:")
        if gui.GetValue("msc_revealranks") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 960,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 960,  "OFF" ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 920, "TP dist:")
        if gui.GetValue("vis_thirdperson_dist") then
            draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 920,  tp_dist ); 
    end
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 940, "Preserve:")
        if gui.GetValue("vis_preservekillfeed") then
            draw.Color( 137, 207, 240, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 940,  "ON" ); 
        else
        draw.Color( 255, 255, 255, 255 );
            draw.Text(x88posx:GetValue() - 280, y - 940,  "OFF" ); 
    end
    -- jobb also resz
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 880, "FPS:")
    draw.Color(DrawFpsColor())
    draw.Text(x88posx:GetValue() - 280, y - 880, get_abs_fps() )
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 860, "Ping:")
    draw.Color(DrawPingColor())
    draw.Text(x88posx:GetValue() - 280, y - 860, PING)
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 840, "Kills:")
    draw.Text(x88posx:GetValue() - 280, y - 840, #kills)
    draw.Text(x88posx:GetValue() - 370, y - 820, "Deaths:")
    draw.Text(x88posx:GetValue() - 280, y - 820, #deaths)
    draw.Color(255, 255, 255, 255)
    draw.Text(x88posx:GetValue() - 370, y - 800, "KD:")
    draw.Color(255, 255, 255, 255)
    if (#kills == 0 and #deaths == 0) then
    draw.Text(x88posx:GetValue() - 280, y - 800, string.format("%.2f", 0) ); 
    elseif (#kills >= 1 and #deaths == 0) then
            draw.Text(x88posx:GetValue() - 280, y - 800, string.format("%.2f", #kills) ); 
        else
            draw.Text(x88posx:GetValue() - 280, y - 800, string.format("%.2f",  #kills  / #deaths  ) )
    end
    draw.Color(255, 255, 255, 255)
    
    --jobb also resz vege
    --idk valami copyright akar leni ami viziblé
    draw.Color(255, 0, 255, 255)
    draw.Text(15, y - 1010, "Author: zero. :)")
    draw.Color(137, 207, 240, 255)
    --vége a idk-s copyrightnak
end
end





client.AllowListener( "player_death" );
client.AllowListener( "client_disconnect" );
client.AllowListener( "begin_new_match" );
callbacks.Register( "FireGameEvent", "KillDeathCount", KillDeathCount);
callbacks.Register("Draw", "paint_traverse", paint_traverse);




--impacts
local string_format, vector_Distance, draw_RoundedRect = string.format, vector.Distance, draw.RoundedRect
local is_enemy = function(index) if entities_GetByIndex(index) == nil then return end return entities_GetByIndex(index):GetTeamNumber() ~= GetLocalPlayer():GetTeamNumber() end
local distance3D = function(a, b) distance = vector_Distance(a, b) return {['normal']=distance, ['u']=string_format('%.0fu', distance), ['ft']=string_format('%.0fft', distance*0.083333), ['m']=string_format('%.1fm', distance/39.370)} end
local bulletimpacts = {}
function bulletimpact(e)
if e:GetName() ~= "bullet_impact" or (not BulletImpacts_Local:GetValue() and not BulletImpacts_Enemy:GetValue() and not BulletImpacts_Team:GetValue()) then return end local x = e:GetFloat("x") local y = e:GetFloat("y") local z = e:GetFloat("z") local player_index = PlayerIndexByUserID(e:GetInt("userid")) local n_bulletimpacts = #bulletimpacts
if BulletImpacts_Local:GetValue() then if player_index == LocalPlayerIndex() then bulletimpacts[n_bulletimpacts + 1] = {g_curtime(), x, y, z, BulletImpacts_color_Local:GetValue()} end end
if BulletImpacts_Enemy:GetValue() then if is_enemy(player_index) then bulletimpacts[n_bulletimpacts + 1] = {g_curtime(), x, y, z, BulletImpacts_color_Enemy:GetValue()} end end
if BulletImpacts_Team:GetValue() then if not is_enemy(player_index) and player_index ~= LocalPlayerIndex() then bulletimpacts[n_bulletimpacts + 1] = {g_curtime(), x, y, z, BulletImpacts_color_Team:GetValue()} end end end
function showimpacts() if GetLocalPlayer() == nil or (not BulletImpacts_Local:GetValue() and not BulletImpacts_Enemy:GetValue() and not BulletImpacts_Team:GetValue()) then return end for k, v in pairs(bulletimpacts) do if g_curtime() - v[1] > BulletImpacts_Time:GetValue() or distance3D({GetLocalPlayer():GetAbsOrigin()}, {v[2], v[3], v[4]}).normal >= 2000 then bulletimpacts[k] = nil else local X, Y = client_WorldToScreen(v[2], v[3], v[4]) if X ~= nil and Y ~= nil then draw_Color(v[5], v[6], v[7], v[8]) draw_RoundedRect(X-3, Y-3, X+3, Y+3) end end end end
cb_Register("Draw", showimpacts) cb_Register("FireGameEvent", bulletimpact)





----------------------------
local bloom = gui.Slider(grp6, "Bloom", "Bloom", 20, 1, 100);
local bloom_value = gui.Slider(grp6, "Value", "Value", 1, 1, 100);
local fogstart = gui.Slider(grp6, "Fogstart", "FogStart", 100, 1, 1000);
local fogend = gui.Slider(grp6, "FogEnd", "FogEnd", 1000, 1, 1000);
local maxdensity = gui.Slider(grp6, "MaxDensity", "MaxDensity", 1, 1, 100);
local ZoomScale = gui.Slider(grp6, "ZoomScale", "ZoomScale", 1, 1, 100);

callbacks.Register("Draw", "bloom", function()
        local CEnvTonemapController = entities.FindByClass("CEnvTonemapController")[1];
        local CFogController = entities.FindByClass("CFogController")[1];

        if(CFogController) then
            CFogController:SetProp("m_fog.enable", 1);
            CFogController:SetProp("m_fog.start", fogstart:GetValue()/1);
            CFogController:SetProp("m_fog.end", fogend:GetValue()/1);
            CFogController:SetProp("m_fog.maxdensity", maxdensity:GetValue()/100);
            CFogController:SetProp("m_fog.ZoomFogScale", ZoomScale:GetValue()/100);
        end
        if(CEnvTonemapController) then

            CEnvTonemapController:SetProp("m_flCustomBloomScale", bloom:GetValue()/50);
            client.SetConVar("r_modelAmbientMin", bloom_value:GetValue()/1, true);
            client.SetConVar("fog_override", 1, true);
            client.SetConVar("fog_enableskybox", 1, true);
            client.SetConVar("fog_startskybox", fogstart:GetValue()/1, true);
            client.SetConVar("fog_endskybox", fogend:GetValue()/1, true);
            client.SetConVar("fog_maxdensityskybox", maxdensity:GetValue()/100, true );
        end
   
end);
