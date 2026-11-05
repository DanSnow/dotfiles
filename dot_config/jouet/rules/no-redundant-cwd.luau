--!strict
-- Denies `cd <current dir>` and `VAR=<current dir>`: the shell already starts there.

local function normalize(word: string): string
	local w = word
	if #w > 1 then
		w = string.gsub(w, "/+$", "")
	end
	return w
end

local function is_cwd(word: string, cwd: string?): boolean
	local w = normalize(word)
	if w == "." or w == "$PWD" or w == "${PWD}" or w == "$(pwd)" or w == "`pwd`" then
		return true
	end
	if cwd ~= nil and w == normalize(cwd) then
		return true
	end
	return false
end

local rule: JouetRule = {
	check = function(call: JouetCall): JouetDecision?
		for _, command in call.commands do
			local argv = command.argv
			if command.program == "cd" and #argv == 2 and is_cwd(argv[2], call.cwd) then
				return jouet.deny(
					"`cd " .. argv[2] .. "` goes to the directory the shell is already in. Drop it and run the command directly."
				)
			end
			local assigns: { string } = {}
			for _, e in command.env do
				table.insert(assigns, e)
			end
			if command.program == "export" or command.program == "declare" or command.program == "local" then
				for i = 2, #argv do
					table.insert(assigns, argv[i])
				end
			end
			for _, a in assigns do
				local name, value = string.match(a, "^([%a_][%w_]*)=(.*)$")
				if name ~= nil and value ~= nil and value ~= "" and is_cwd(value, call.cwd) then
					return jouet.deny(
						"`"
							.. name
							.. "="
							.. value
							.. "` sets a variable to the current directory. Use relative paths instead of a variable for it."
					)
				end
			end
		end
		-- A bare assignment (`D=$PWD; ls`) is not a command: scan the statements.
		local text = call.command
		if call.tool == "Bash" and text ~= nil then
			for segment in string.gmatch(text, "[^;&|\n]+") do
				local name, value = string.match(segment, "^%s*([%a_][%w_]*)=(%S*)%s*$")
				if name ~= nil and value ~= nil then
					local v = string.gsub(string.gsub(value, '^"(.*)"$', "%1"), "^'(.*)'$", "%1")
					if v ~= "" and is_cwd(v, call.cwd) then
						return jouet.deny(
							"`"
								.. name
								.. "="
								.. value
								.. "` sets a variable to the current directory. Use relative paths instead of a variable for it."
						)
					end
				end
			end
		end
		return nil
	end,
}

return rule
