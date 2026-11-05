--!strict
-- Denies writing or editing files through a throwaway interpreter script:
-- a heredoc fed to python/perl/ruby/node/bun/deno whose body writes files,
-- or an inline `-c` / `-e` script that does.

-- Lua patterns for "this script writes or edits a file".
local WRITE_PATTERNS: { string } = {
	"%.write%s*%(",
	"%.write_text%s*%(",
	"%.write_bytes%s*%(",
	"%.writelines%s*%(",
	"open%s*%([^)]*['\"][rwax]*[wax+][bt+]*['\"]",
	"json%.dump%s*%(",
	"shutil%.[%w_]+%s*%(",
	"os%.rename%s*%(",
	"os%.replace%s*%(",
	"os%.remove%s*%(",
	"os%.unlink%s*%(",
	"%.rename%s*%(",
	"%.unlink%s*%(",
	"%.touch%s*%(",
	"fileinput",
	"File%.write",
	"File%.open",
	"File%.rename",
	"File%.delete",
	"IO%.write",
	"writeFileSync",
	"writeFile",
	"appendFileSync",
	"appendFile",
	"renameSync",
	"unlinkSync",
	"Bun%.write",
	"Deno%.writeTextFile",
	"open%s*%(?%s*[%w_]+%s*,%s*['\"]?%s*%+?>",
	"[^%w_]unlink%s*%(",
	"[^%w_]rename%s*%(",
}

local function writes_files(text: string): boolean
	for _, p in WRITE_PATTERNS do
		if string.find(text, p) ~= nil then
			return true
		end
	end
	return false
end

local function is_interpreter(program: string): boolean
	if string.match(program, "^python[%d%.]*$") ~= nil then
		return true
	end
	return program == "perl" or program == "ruby" or program == "node" or program == "bun" or program == "deno"
end

-- `python -c`, `perl -e/-pe/-i`, `ruby -e`, `node -e/-p/--eval`.
local function is_inline(program: string, argv: { string }): boolean
	for i = 2, #argv do
		local a = argv[i]
		if string.sub(a, 1, 1) ~= "-" then
			if (program == "deno" or program == "bun" or program == "node") and a == "eval" then
				return true
			end
			-- A script path or other positional ends the options.
			return false
		end
		if string.match(program, "^python") ~= nil and a == "-c" then
			return true
		end
		if program == "perl" and string.match(a, "^%-%a*[ei]%a*$") ~= nil then
			return true
		end
		if program == "ruby" and a == "-e" then
			return true
		end
		if (program == "node" or program == "bun" or program == "deno") and (a == "-e" or a == "-p" or a == "--eval") then
			return true
		end
	end
	return false
end

local HINT = " Use the Write/Edit tools for a single-file change; for batch updates use `ast-grep run -p OLD -r NEW -l LANG -U` or `jouet edit replace`."

local rule: JouetRule = {
	check = function(call: JouetCall): JouetDecision?
		for _, command in call.commands do
			local program = command.program
			if program ~= nil and is_interpreter(program) then
				-- 1. A heredoc script that writes files, or whose stdout goes to a file.
				for _, body in command.heredocs do
					if writes_files(body) or command.stdout_to ~= nil then
						return jouet.deny("Writing/editing a file via an interpreter + heredoc script is blocked." .. HINT)
					end
				end
				-- 2. An inline script that writes files, or whose stdout goes to a file.
				if is_inline(program, command.argv) then
					if program == "perl" then
						for i = 2, #command.argv do
							if string.match(command.argv[i], "^%-%a*i%a*$") ~= nil then
								return jouet.deny("In-place editing with `perl -i` is blocked." .. HINT)
							end
						end
					end
					if writes_files(command.line) or command.stdout_to ~= nil then
						return jouet.deny(
							"Writing/editing a file via an inline python/perl/ruby/node script is blocked." .. HINT
						)
					end
				end
			end
		end
		return nil
	end,
}

return rule
