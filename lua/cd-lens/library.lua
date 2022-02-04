local CDLens = {}

function CDLens.Clear()
    local status_ok, _ = pcall(vim.cmd, "wa")
    if not status_ok then
        print("Please save all open buffers.")
        return
    end

    local status_ok, _ = pcall(vim.cmd, [[
        bufdo bwipeout
        silent only
        silent tabonly
    ]])
    if not status_ok then
        print("Error: an error occurred when clearing")
        return
    end
end

function CDLens.CD(dir)
    ClearVim()
    vim.cmd("cd " .. dir)
    -- TODO show intro
    -- vim.api.nvim_exec("intro", false)
end

return CDLens
