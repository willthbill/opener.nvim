local has_telescope, telescope = pcall(require, 'telescope')

if not has_telescope then
    print('error: telescope.nvim (nvim-telescope/telescope.nvim) is required by opener.nvim')
    return
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require('telescope.actions')
local action_state = require "telescope.actions.state"

local has_plenary, scan = pcall(require, "plenary.scandir")

if not has_plenary then
    print('error: plenary.nvim (nvim-lua/plenary.nvim) is required by opener.nvim')
    return
end

local lib = require("opener.lib")

local default_options = {}

local function setup(opts)
    if not opts then return end
    if not type(opts) == "table" then return end
    default_options = opts
end

local has_fd = vim.fn.executable "fd" == 1
local has_find = vim.fn.executable "find" == 1

local function finder(opts)
    local root_dir = vim.fn.expand(opts.root_dir or "~")
    local respect_gitignore = opts.respect_gitignore
    local hidden = opts.hidden
    if has_fd then
        local command = { "fd", "--full-path", "^"..root_dir, "-t", "d", "-a" } -- full-path is used to include root_dir in results
        if hidden then
            table.insert(command, "-H")
        end
        if respect_gitignore == false then
            table.insert(command, "--no-ignore-vcs")
        end
        return finders.new_oneshot_job(command, {
            cwd = root_dir,
        })
    elseif has_find then -- TODO: make results equal fd exactly
        local command = { "find", root_dir, "-type", "d"}
        if not hidden then
            for _, e in pairs({ "-not", "-path", "*/.*" }) do
                table.insert(command, e)
            end
        end
        return finders.new_oneshot_job(command, {
            cwd = ".",
        })
    else
        local data = scan.scan_dir(root_dir, {
            hidden = hidden,
            only_dirs = true,
            respect_gitignore = respect_gitignore,
        })
        table.insert(data, 1, root_dir)
        return finders.new_table { results = data }
    end
end

local function action(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if selection then -- selection is sometimes NIL
        actions.close(prompt_bufnr)
        local dir = selection[1];
        lib.open(dir)
    end
end

local function main(user_opts)
    user_opts = user_opts or {}
    local opts = vim.deepcopy(default_options)
    for k,v in pairs(user_opts) do opts[k] = v end
    pickers.new(opts, {
        prompt_title = "Open Directory",
        results_title = "Directories",
        finder = finder(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_,_)
            actions.select_default:replace(action)
            return true
        end,
    }):find()
end

return telescope.register_extension {
    setup = setup,
    exports = { opener = main }
}
