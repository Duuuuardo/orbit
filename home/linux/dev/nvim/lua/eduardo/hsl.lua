local M = {}

local function clamp(n, lo, hi)
	n = n < lo and lo or n
	return n > hi and hi or n
end

function M.rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local l = (max + min) / 2
	if max == min then
		return 0, 0, l
	end
	local d = max - min
	local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
	local h
	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end
	return h / 6, s, l
end

function M.hex_to_hsl(hex)
	local r, g, b = M.hex_to_rgb(hex)
	return M.rgb_to_hsl(r * 255, g * 255, b * 255)
end

function M.hex_to_rgb(hex)
	hex = hex:gsub("^#", ""):lower()
	if #hex == 3 then
		hex = hex:gsub(".", "%1%1")
	end
	local r, g, b = hex:match("^(%x%x)(%x%x)(%x%x)$")
	assert(r and g and b, "Invalid hex color: " .. hex)
	return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255
end

local function to_hsl_string(hex)
	local h, s, l = M.hex_to_hsl(hex)
	h = clamp(math.floor(h * 360 + 0.5), 0, 360)
	s = clamp(math.floor(s * 100 + 0.5), 0, 100)
	l = clamp(math.floor(l * 100 + 0.5), 0, 100)
	return ("hsl(%d, %d%%, %d%%)"):format(h, s, l)
end

function M.replaceHexWithHSL()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local out, count = {}, 0
	for _, line in ipairs(lines) do
		local new, n = line:gsub("#%x%x%x%x%x%x", to_hsl_string)
		out[#out + 1] = new
		count = count + n
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
	vim.notify(("Converted %d hex colors to HSL"):format(count), vim.log.levels.INFO)
end

return M