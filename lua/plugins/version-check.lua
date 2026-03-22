return {
	{
		dir = ".",
		name = "neovim-version-check",
		lazy = false,
		config = function()
			local function check_neovim_version()
				local current = vim.version()
				local current_str = string.format("v%d.%d.%d", current.major, current.minor, current.patch)

				vim.fn.jobstart({
					"curl",
					"-sL",
					"-m", "5",
					"https://api.github.com/repos/neovim/neovim/releases/latest",
				}, {
					stdout_buffered = true,
					on_stdout = function(_, data)
						if not data or #data == 0 then
							return
						end

						local body = table.concat(data, "")
						local tag = body:match('"tag_name"%s*:%s*"([^"]+)"')

						if not tag then
							return
						end

						local major, minor, patch = tag:match("v(%d+)%.(%d+)%.(%d+)")
						if not major then
							return
						end

						major = tonumber(major)
						minor = tonumber(minor)
						patch = tonumber(patch)

						local outdated = false
						if major > current.major then
							outdated = true
						elseif major == current.major and minor > current.minor then
							outdated = true
						elseif major == current.major and minor == current.minor and patch > current.patch then
							outdated = true
						end

						if outdated then
							vim.schedule(function()
								vim.notify(
									string.format(
										"Neovim update available: %s -> %s\nRun install.sh to update.",
										current_str,
										tag
									),
									vim.log.levels.WARN,
									{ title = "NewEraNeovim" }
								)
							end)
						end
					end,
				})
			end

			-- Check on startup, delayed to not block init
			vim.defer_fn(check_neovim_version, 2000)

			-- User command to check manually
			vim.api.nvim_create_user_command("NeovimVersionCheck", function()
				local current = vim.version()
				local current_str = string.format("v%d.%d.%d", current.major, current.minor, current.patch)

				vim.notify("Checking for updates...", vim.log.levels.INFO, { title = "NewEraNeovim" })

				vim.fn.jobstart({
					"curl",
					"-sL",
					"-m", "10",
					"https://api.github.com/repos/neovim/neovim/releases/latest",
				}, {
					stdout_buffered = true,
					on_stdout = function(_, data)
						if not data or #data == 0 then
							return
						end

						local body = table.concat(data, "")
						local tag = body:match('"tag_name"%s*:%s*"([^"]+)"')

						if not tag then
							vim.schedule(function()
								vim.notify(
									"Could not fetch latest version.",
									vim.log.levels.ERROR,
									{ title = "NewEraNeovim" }
								)
							end)
							return
						end

						vim.schedule(function()
							if tag == current_str then
								vim.notify(
									string.format("Neovim is up to date (%s)", current_str),
									vim.log.levels.INFO,
									{ title = "NewEraNeovim" }
								)
							else
								vim.notify(
									string.format(
										"Neovim update available: %s -> %s\nRun install.sh to update.",
										current_str,
										tag
									),
									vim.log.levels.WARN,
									{ title = "NewEraNeovim" }
								)
							end
						end)
					end,
				})
			end, { desc = "Check for Neovim updates" })
		end,
	},
}
