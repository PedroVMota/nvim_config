return {
	{
		dir = ".",
		name = "newera-version-check",
		lazy = false,
		config = function()
			local config_dir = vim.fn.stdpath("config")

			-- Get the local git tag of this config
			local function get_local_version(callback)
				vim.fn.jobstart({ "git", "-C", config_dir, "describe", "--tags", "--abbrev=0" }, {
					stdout_buffered = true,
					on_stdout = function(_, data)
						if data and #data > 0 then
							local tag = vim.trim(table.concat(data, ""))
							if tag ~= "" then
								callback(tag)
								return
							end
						end
						callback(nil)
					end,
				})
			end

			-- Get the latest tag from the remote repo
			local function get_remote_version(callback)
				vim.fn.jobstart({
					"curl", "-sL", "-m", "5",
					"https://api.github.com/repos/PedroVMota/NewEraNeovim/releases/latest",
				}, {
					stdout_buffered = true,
					on_stdout = function(_, data)
						if data and #data > 0 then
							local body = table.concat(data, "")
							local tag = body:match('"tag_name"%s*:%s*"([^"]+)"')
							if tag then
								callback(tag)
								return
							end
						end
						-- Fallback: try git ls-remote for tags
						vim.fn.jobstart({
							"git", "ls-remote", "--tags", "--sort=-v:refname",
							"https://github.com/PedroVMota/NewEraNeovim.git",
						}, {
							stdout_buffered = true,
							on_stdout = function(_, tag_data)
								if tag_data and #tag_data > 0 then
									local output = table.concat(tag_data, "\n")
									local latest = output:match("refs/tags/(v%d+%.%d+%.%d+)")
									callback(latest)
								else
									callback(nil)
								end
							end,
						})
					end,
				})
			end

			local function compare_versions(local_tag, remote_tag)
				if not local_tag or not remote_tag then
					return false
				end

				local lmaj, lmin, lpat = local_tag:match("v(%d+)%.(%d+)%.(%d+)")
				local rmaj, rmin, rpat = remote_tag:match("v(%d+)%.(%d+)%.(%d+)")

				if not lmaj or not rmaj then
					return local_tag ~= remote_tag
				end

				lmaj, lmin, lpat = tonumber(lmaj), tonumber(lmin), tonumber(lpat)
				rmaj, rmin, rpat = tonumber(rmaj), tonumber(rmin), tonumber(rpat)

				if rmaj > lmaj then return true end
				if rmaj == lmaj and rmin > lmin then return true end
				if rmaj == lmaj and rmin == lmin and rpat > lpat then return true end

				return false
			end

			local function check_config_version(silent)
				get_local_version(function(local_tag)
					get_remote_version(function(remote_tag)
						vim.schedule(function()
							if not remote_tag then
								if not silent then
									vim.notify(
										"Could not fetch latest NewEraNeovim version.",
										vim.log.levels.ERROR,
										{ title = "NewEraNeovim" }
									)
								end
								return
							end

							local local_display = local_tag or "unknown"

							if compare_versions(local_tag, remote_tag) then
								vim.notify(
									string.format(
										"NewEraNeovim update available: %s -> %s\nRun 'git pull' and install.sh to update.",
										local_display,
										remote_tag
									),
									vim.log.levels.WARN,
									{ title = "NewEraNeovim" }
								)
							elseif not silent then
								vim.notify(
									string.format("NewEraNeovim is up to date (%s)", local_display),
									vim.log.levels.INFO,
									{ title = "NewEraNeovim" }
								)
							end
						end)
					end)
				end)
			end

			-- Check on startup (silent — only notifies if outdated)
			vim.defer_fn(function()
				check_config_version(true)
			end, 3000)

			-- Manual command (always shows result)
			vim.api.nvim_create_user_command("NewEraUpdate", function()
				vim.notify("Checking for updates...", vim.log.levels.INFO, { title = "NewEraNeovim" })
				check_config_version(false)
			end, { desc = "Check for NewEraNeovim config updates" })
		end,
	},
}
