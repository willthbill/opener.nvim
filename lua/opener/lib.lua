local user_config = require("opener.setup").user_config

local opener = {}

local function raw_clear()

    local status_ok, _ = pcall(vim.cmd, "wa")
    if not status_ok then
        error("(opener.nvim) open buffers are not saved or empty.")
        return
    end

    status_ok, _ = pcall(vim.cmd, [[
        silent bufdo bdelete
        silent only
        silent tabonly
    ]])
    if not status_ok then
        error("(opener.nvim) an error occurred when clearing")
    end

end

function opener.clear()

    local status_ok, _ = pcall(vim.cmd, "wa")
    if not status_ok then
        print("Please save all open buffers.\n")
        return
    end

    raw_clear()
end

-- does not respect user configuration (hooks)
local function raw_open(dir)

    raw_clear()

    local status_ok, _ = pcall(vim.cmd, "cd " .. dir)
    if not status_ok then
        error("(opener.nvim) an error occurred when entering " .. dir)
    end

    -- TODO show intro
    -- vim.api.nvim_exec("intro", false)
end

-- does respect user configuration (hooks)
function opener.open(dir)

    if vim.fn.isdirectory(dir) == 0 then
        print("Directory does not exist.\n")
        return
    end

    local status_ok, _ = pcall(vim.cmd, "wa")
    if not status_ok then
        print("Please save all open buffers.\n")
        return
    end

    -- At this point everything should run without errors
    -- Run pre_open hooks
    for _, f in ipairs(user_config.pre_open) do
        f(dir)
    end

    raw_open(dir)

    -- Run post_open hooks
    for _, f in ipairs(user_config.post_open) do
        f(dir)
    end
end

return opener
