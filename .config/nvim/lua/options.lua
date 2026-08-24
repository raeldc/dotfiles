require "nvchad.options"

if not (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY) then
	local function osc52_copy(lines)
		local payload = vim.base64.encode(table.concat(lines, "\n"))
		io.write("\27]52;c;" .. payload .. "\7")
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52_copy,
			["*"] = osc52_copy,
		},
		paste = {
			["+"] = function()
				return { "" }
			end,
			["*"] = function()
				return { "" }
			end,
		},
		cache_enabled = 0,
	}
end

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
