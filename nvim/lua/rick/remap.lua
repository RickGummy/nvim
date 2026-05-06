-- netrw
-- LSP configurations (modern nvim 0.11+ API)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- save and quit
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- move line down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted line up" })

-- keep cursor center when going up and down a page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move half a page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move half a page up" })

-- keep cursor centered when jumping from one search to another
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search" })

-- paste without yanking
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- let me paste outside of nvim you terrorist
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard " })

-- delete without storing in history
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete without yanking" })

-- quickfix list navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- run current file
vim.keymap.set("n", "<leader>r", function()
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")
    local cmd

    if ft == "python" then
        cmd = "python3 " .. file
    elseif ft == "go" then
        cmd = "go run " .. file
    elseif ft == "cpp" then
        cmd = "g++ -std=c++20 " .. file .. " -o /tmp/run && /tmp/run"
    elseif ft == "c" then
        cmd = "gcc " .. file .. " -o /tmp/run && /tmp/run"
    else
        print("no run command, go add it for " .. ft)
        return
    end

    vim.cmd("split | terminal " .. cmd)
end, { desc = "Run current file" })

vim.keymap.set({ "i", "n" }, "<D-CR>", "<Esc>o", { desc = "New line below" })
vim.keymap.set({ "i", "n" }, "<D-S-CR>", "<Esc>O", { desc = "New line above" })
