local opener = {}

function opener.clear()

    local status_ok, _ = pcall(vim.cmd, "wa")
    if not status_ok then
        print("Please save all open buffers.")
        return
    end

    status_ok, _ = pcall(vim.cmd, [[
        bufdo bwipeout
        silent only
        silent tabonly
    ]])
    if not status_ok then
        print("Error: an error occurred when clearing")
        return
    end
end

function opener.open(dir)
    opener.clear()
    vim.cmd("cd " .. dir)
    -- TODO show intro
    -- vim.api.nvim_exec("intro", false)
end

return opener
