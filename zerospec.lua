local mouseX, mouseY, x, y, dx, dy, w, h = 0, 0, 25, 660, 0, 0, 300, 60;
local shouldDrag = false;
local font_title = draw.CreateFont("Smallest Pixel-7", 16, 5);
local font_spec = draw.CreateFont("Tahoma", 13, 1);
local topbarSize = 25;
local ittleszxd = gui.Reference("SETTINGS", "Miscellaneous")
local line1 = gui.Slider(ittleszxd , "halig", "Line Fade Speed", 1, 0.1, 5 )
local line2 = gui.Slider(ittleszxd , "halig", "Line Fade Speed", 1.1, 0.1, 5 )
local vonal_alt = gui.Combobox( ittleszxd, "miyu_ocsi_dd", "Line Options", "None", "Top", "Bottom", "Both" )
local thiccness = gui.Slider( ittleszxd, "haligvastag", "Vasstaggságg =D", 2, 0.1, 40)
local specszin = gui.ColorEntry( "dxhooker", "Spectators' name color ", 150, 200, 50, 255 )



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
    local bgr = getFadeRGB(line2:GetValue());
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
    draw.Color( rgb[1], rgb[2], rgb[3], 100 )
    draw.Text(x + ((w - tW) / 3.65), y + 2, spectext)

    drawRectFill(27, 24, 25, 255, x + 7, y + 30, w - 115, h2);

    drawOutline(41, 35, 36, 255, x + 7, y + 30, w - 115, h2 , 2);
	
    render.gradient( x , y + 18, w - 101, 2, { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );




    ----------------------------------------------------------------------------------------------------------
    if vonal_alt:GetValue() == 0 then
     --
    
    elseif vonal_alt:GetValue() == 1 then
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );
    
    elseif vonal_alt:GetValue() == 2 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );

    elseif vonal_alt:GetValue() == 3 then

    render.gradient( 0 , scriny - thiccness:GetValue(), scrinx, thiccness:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );
    render.gradient( 0 , 0, scrinx, thiccness:GetValue(), { rgb[1], rgb[2], rgb[3], 255 }, { bgr[1], bgr[2], bgr[3]}, false );
  
end
	--render.gradient( x + 133,  y + h - 7 , 180 / 2, 4, { 202, 70, 205, 255 }, { 201, 227, 58, 255 }, false );
	
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
local VERSION_NUMBER = "1.0"; --- This too

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

callbacks.Register("Draw", function()


	 local lp = entities.GetLocalPlayer();
    if lp == nil then
	return
	end
    local spectators = getSpectators();
    if (#spectators == 0) then
        drawWindow(#spectators);
    end
    drawWindow(#spectators);
    drawindicators(spectators);
    dragFeature();
end)