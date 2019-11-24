local mouseX, mouseY, x, y, dx, dy, w, h = 0, 0, 25, 660, 0, 0, 300, 60;
local shouldDrag = false;
local font_title = draw.CreateFont("Smallest Pixel-7", 16, 5);
local font_spec = draw.CreateFont("Tahoma", 13, 1);
local topbarSize = 25;
local ittleszxd = gui.Reference("SETTINGS", "Miscellaneous")
local line1 = gui.Slider(ittleszxd , "halig", "Line Fade Speed", 2.5, 0.1, 20 )
local vonal_alt = gui.Combobox( ittleszxd, "miyu_ocsi_dd", "Line Options", "None", "Top", "Bottom", "Both" )
local thiccness = gui.Slider( ittleszxd, "haligvastag", "Vasstaggságg =D", 2.5, 0.1, 300)
local specszin = gui.ColorEntry( "dxhooker", "Spectators' name color ", 150, 200, 50, 255 )
local fejszin = gui.ColorEntry( "dxhooker", "Spectator list Header text color ", 150, 150, 150, 255 )
local fejszincombo = gui.Combobox( ittleszxd, "miyu_ocsi_ddd", "Header text color", "Static", "RGB" )
local fejszin_alpha = gui.Slider( ittleszxd, "dxh", "RGB header alpha", "100", "0", "255" )


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
        draw.SetTexture(texture);
    else
        draw.SetTexture(r, g, b, a);
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

local function drawWindow(spectators)
    local h2 = h - 60 + (spectators * 11);
    local h = h + (spectators * 11);
    local rgb = getFadeRGB(line1:GetValue());
    local scrinx, scriny = draw.GetScreenSize()

    -- Draw small outline
    draw.Color(0, 0, 0, 255);
    draw.OutlinedRect(x - 6, y - 6, x + w - 94, y + h - 15);

    -- Draw big outline
    drawOutline(30, 30, 30, 255, x, y, w - 100, h - 20, 5);


    -- Draw the main bg
    drawRectFill(0, 0, 0, 255, x, y, w - 100, h - 20);

    
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
    draw.Text(x + ((w - tW) / 3.65), y + 2, spectext)

    drawRectFill(27, 24, 25, 255, x + 7, y + 30, w - 115, h2);

    drawOutline(41, 35, 36, 255, x + 7, y + 30, w - 115, h2 , 2);
	
    render.gradient( x , y + 18, w / 2 - 50, 2, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );

    render.gradient( x + ( w / 2 ) - 49, y + 18, w / 2 - 52, 2, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );


    ----------------------------------------------------------------------------------------------------------
    if vonal_alt:GetValue() == 0 then
     --
    
    elseif vonal_alt:GetValue() == 1 then
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    
    elseif vonal_alt:GetValue() == 2 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );

    elseif vonal_alt:GetValue() == 3 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
  
end
	--render.gradient( x + 133,  y + h - 7 , 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false );
	
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
local VERSION_NUMBER = "1.2"; --- This too

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

    local scrx, scry = draw.GetScreenSize()

    draw.Color( 255, 255, 255, 150 )
    draw.SetFont(font_spec)
    draw.Text( scrx - 61.5, scry - 12, "Version: " .. VERSION_NUMBER)
    
end






local abs_frame_time = globals.AbsoluteFrameTime;     local frame_rate = 0.0; local get_abs_fps = function()  frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * abs_frame_time(); return math.floor((1.0 / frame_rate) + 0.5);  end
frequency = 0 -- range: [0, oo) | lower is slower
intensity = 180 -- range: [0, 255] | lower is darker
saturation = 1 -- range: [0.00, 1.00] | lower is less saturated




local wmgroup = gui.Groupbox( ittleszxd, "Watermark", 1, 600, 213, 200 );
local enablewm = gui.Checkbox( wmgroup, "lua_wm_enable", "Enable", 1 );
local aw_text = gui.Checkbox( wmgroup, "lua_wm_awtext", "cheat name", 1);
local wmpos = gui.Combobox( wmgroup, "lua_wm_pos", "Position (WIP)", "Top left");
local show_fps = gui.Checkbox( wmgroup, "lua_wm_showfps", "Show fps", 1);
local show_ping = gui.Checkbox( wmgroup, "lua_wm_showping", "Show ping", 1);
local draw_line = gui.Checkbox( wmgroup, "lua_wm_drawline", "Draw line", 1);


local function use_Crayon()
if entities.GetLocalPlayer() == nil then
      return
end
local rgb = getFadeRGB(line1:GetValue());
local wmpos1 = wmpos:GetValue();
local text = aw_text:GetValue();
local fps = show_fps:GetValue();
local ping = show_ping:GetValue();
local ff = draw.CreateFont('Tahoma', 60)
local classicf = draw.CreateFont('Tahoma', 12)
local name = client.GetPlayerNameByIndex(client.GetLocalPlayerIndex())
local x, y = draw.GetScreenSize()
   local R = hsvToR((globals.RealTime() * frequency) % 1, saturation, 1)
    local G = hsvToG((globals.RealTime() * frequency) % 1, saturation, 1)
    local B = hsvToB((globals.RealTime() * frequency) % 1, saturation, 1)

	if enablewm:GetValue() then
	   if (wmpos1 == 0) then
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 20, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 15, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 16, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 21, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 19, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
		--   draw.FilledRect(8, 11, 15, 12)
		   end
		if aw_text:GetValue() then
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 90, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 85, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 86, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 91, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 89, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 38, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 48, 11, 36, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
		 --  draw.FilledRect(9, 11, 85, 12)
		   end
		end
		
	    if show_fps:GetValue() then
		   if aw_text:GetValue() then
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 130, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 125, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 126, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 131, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 129, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 60, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 70, 11, 54, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
		 --  draw.FilledRect(9, 11, 125, 12)
		   end
		   else 
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 60, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 55, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 56, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 61, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 59, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 20, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 30, 11, 24, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
		  -- draw.FilledRect(9, 11, 55, 12)
		   end
		   end
		end
		
		if show_ping:GetValue() then
		   if show_fps:GetValue() then
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 110, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 95, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 106, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 111, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 109, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 45, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 55, 11, 50, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
		   --draw.FilledRect(9, 11, 105, 12)
		   end
		   else
		   draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 60, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 55, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 56, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 61, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 59, 29)
		   if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 20, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 30, 11, 24, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
		   --draw.FilledRect(9, 11, 55, 12)
		   end
		   end
		end
		
		if show_ping:GetValue() then
		   if aw_text:GetValue() then
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 130, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 125, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 126, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 131, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 129, 29)
           if draw_line:GetValue() then
           draw.Color(255, 255, 255, 255)
           render.gradient( 9, 11, 55, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
           render.gradient( 65, 11, 59, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
           end
		   end
        end
		
		if show_ping:GetValue() then
		   if aw_text:GetValue() then
		     if show_fps:GetValue() then
           draw.Color(35, 35, 35, 255)
           draw.FilledRect(3, 5, 180, 30)
           draw.Color(15, 15, 15, 180)
           draw.FilledRect(8, 10, 175, 25)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(8, 10, 176, 26)
           draw.Color(0, 0, 0, 255)
           draw.OutlinedRect(2, 4, 181, 31)
           draw.Color(70, 70, 70, 180)
           draw.OutlinedRect(3, 5, 179, 29)
           if draw_line:GetValue() then
            render.gradient( 9, 11, 85, 1, { rgb[3], rgb[1], rgb[2], 255 }, { rgb[2], rgb[3], rgb[1]}, false );
            render.gradient( 95, 11, 79.5, 1, { rgb[2], rgb[3], rgb[1], 255 }, { rgb[1], rgb[2], rgb[3]}, false );
           draw.Color(255, 255, 255, 255)
           --draw.FilledRect(9, 11, 175, 12)
           end
		   end
		   end
        end
		
		-- fps
		   if show_fps:GetValue() then  
                if aw_text:GetValue() then			  
           draw.SetFont(classicf)
           draw.Color(255, 255, 255, 255)
           draw.Text(82, 12, "fps: ".. get_abs_fps())
		   draw.Color(235, 235, 235, 255)
           draw.Text(74, 12, "|") 
		   else
		   draw.SetFont(classicf)
           draw.Color(255, 255, 255, 255)
           draw.Text(13, 12, "fps: ".. get_abs_fps())
		   draw.Color(235, 235, 235, 255)
		   end
		    end
		--ping
	       if show_ping:GetValue() then
			   if aw_text:GetValue() then
			     if not show_fps:GetValue() then
		   draw.SetFont(classicf)
           local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
           draw.Color(255, 255, 255, 255)
           draw.Text(80, 12, "ms: ".. m_iPing)
           draw.Color(255, 255, 255, 255)
           draw.Text(73, 12, "|")  	   	
		      end
		  if show_fps:GetValue() then 
		    if aw_text:GetValue() then
		   draw.SetFont(classicf)
           local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
           draw.Color(255, 255, 255, 255)
           draw.Text(130, 12, "ms: ".. m_iPing)
           draw.Color(255, 255 , 255, 255)
           draw.Text(123, 12, "|")  
		   end
		   end
          end
		end
		if show_ping:GetValue() then
		  if not show_fps:GetValue() then
		    if not aw_text:GetValue() then
					   draw.SetFont(classicf)
           local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
           draw.Color(255, 255, 255, 255)
           draw.Text(15, 12, "ms: ".. m_iPing)
		  end
		end
	  end
	  	if show_ping:GetValue() then 
		    if not aw_text:GetValue() then
			 if show_fps:GetValue() then
		   draw.SetFont(classicf)
           local m_iPing = entities.GetPlayerResources():GetPropInt("m_iPing", client.GetLocalPlayerIndex())
           draw.Color(255, 255, 255, 255)
           draw.Text(60, 12, "ms: ".. m_iPing)
           draw.Color(255, 255 , 255,  255)
           draw.Text(53, 12, "|")  
		   end
		   end
		   end
	end
        -- text		   
	       if aw_text:GetValue() then
           draw.SetFont(classicf)
           draw.Color(214, 214, 214, 230)
           draw.Text(22, 12, "AIM")
           draw.Color(255, 0, 0, 230)
           draw.Text(40, 12, "WARE") 
           draw.Color(214, 214, 214, 230)
           draw.Text(53, 12, "")		   
	       end
    end

end

callbacks.Register('Draw', 'use_Crayon', use_Crayon)































callbacks.Register("Draw", function()


	 local lp = entities.GetLocalPlayer();
    if lp == nil then
	return
	end
    local spectators = getSpectators();
    if (#spectators == 0) then
        drawWindow(#spectators);
    end
    
    versionwm();
    drawWindow(#spectators);
    drawindicators(spectators);
    dragFeature();
end)