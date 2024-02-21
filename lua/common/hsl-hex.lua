-- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
--
local M = {}

local hexChars = "0123456789abcdef"

local function hex_to_rgb(hex)
	hex = string.lower(hex)
  ---@type integer[]
	local ret = {}
	for i = 0, 2 do
		local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
		local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
		local digit1 = string.find(hexChars, char1) - 1
		local digit2 = string.find(hexChars, char2) - 1
		ret[i + 1] = (digit1 * 16 + digit2) / 255.0
	end
	return ret
end


--[[
  Converts an RGB color value to HSL. Conversion formula
  adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  Assumes r, g, and b are contained in the set [0, 255] and
  returns h, s, and l in the set [0, 1].
]]
---@param r number                          The red color value
---@param g number                          The green color value
---@param b number                          The blue color value
---@return  number, number, number          The HSL representation
local function rgbToHsl(r, g, b)
  ---@type number, number
	local max, min = math.max(r, g, b), math.min(r, g, b)
  ---@type number, number, number
	local h, s, l

	l = (max + min) / 2

	if max == min then
		h, s = 0, 0 -- achromatic
	else
    ---@type integer
		local d = max - min
		if l > 0.5 then
			s = d / (2 - max - min)
		else
			s = d / (max + min)
		end
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	return h * 360, s * 100, l * 100
end


--[[
  Converts an HSL color value to RGB. Conversion formula
  adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  Assumes h, s, and l are contained in the set [0, 1] and
  returns r, g, and b in the set [0, 255].
]]
---@param h number The hue
---@param s number The saturation
---@param l number The lightness
---@return number, number, number The RGB representation
function M.hslToRgb(h, s, l)
  ---@type number, number, number
	local r, g, b = 0, 0, 0

	if s == 0 then
		r, g, b = l, l, l -- achromatic
	else
    ---@param p number, 
    ---@param q number 
    ---@param t number
    ---@return number
		local function hue2rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * 6 * t
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end

    ---@type number
		local q = 0
		if l < 0.5 then
			q = l * (1 + s)
		else
			q = l + s - l * s
		end
		local p = 2 * l - q

		r = hue2rgb(p, q, h + 1 / 3)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 1 / 3)
	end

	return r * 255, g * 255, b * 255
end


function M.hexToHSL(hex)
	-- local hsluv = require("solarized-osaka.hsluv")
	local rgb = hex_to_rgb(hex)
	local h, s, l = rgbToHsl(rgb[1], rgb[2], rgb[3])

	return string.format("hsl(%d, %d, %d)", math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))
end

--[[
 * Converts an HSL color value to RGB in Hex representation.
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  String           The hex representation
]]
function M.hslToHex(h, s, l)
	local r, g, b = M.hslToRgb(h / 360, s / 100, l / 100)

	return string.format("#%02x%02x%02x", r, g, b)
end


function M.replaceHexWithHSL()
	-- Get the current line number
	local line_number = vim.api.nvim_win_get_cursor(0)[1]

	-- Get the line content
	local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

	-- Find hex code patterns and replace them
	for hex in line_content:gmatch("#[0-9a-fA-F]+") do
		local hsl = M.hexToHSL(hex)
		line_content = line_content:gsub(hex, hsl)
	end

	-- Set the line content back
	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end

return M
