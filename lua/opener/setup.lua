local M = {}

M.user_config = {
    pre_open = {},
    post_open = {},
}

local function fix_hooks(key)
    if not M.user_config[key] then M.user_config[key] = {} end
    if type(M.user_config[key]) == "string" or type(M.user_config[key]) == "function" then
        M.user_config[key] = {M.user_config[key]}
    end
    for idx, cmd in ipairs(M.user_config[key]) do
        if type(cmd) == "string" then
            M.user_config[key][idx] = function() vim.cmd(cmd) end
        elseif type(cmd) == "function" then
            M.user_config[key][idx] = cmd
        else
            print("(opener.nvim) " .. type(cmd) .. " is an invalid type for " .. key)
            M.user_config[key][idx] = function()end
        end
    end
end

function M.setup(opts)
    if not opts or type(opts) ~= "table" then
        M.user_config = {}
    else
        M.user_config = opts
    end
    fix_hooks("pre_open")
    fix_hooks("post_open")
end

return M
