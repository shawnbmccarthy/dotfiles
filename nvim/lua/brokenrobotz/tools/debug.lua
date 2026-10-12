local map = vim.keymap.set
local loaded = false

local function dap()
  if not loaded then
    loaded = true
    local d, ui = require("dap"), require("dapui")
    ui.setup()
    d.listeners.before.attach.brokenrobotz = function() ui.open() end
    d.listeners.before.launch.brokenrobotz = function() ui.open() end
    d.listeners.before.event_terminated.brokenrobotz = function() ui.close() end
    d.listeners.before.event_exited.brokenrobotz = function() ui.close() end
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

    d.adapters.lldb = { type = "executable", command = "lldb-dap", name = "lldb" }
    local lldb_launch = {
      name = "launch executable",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspacefolder}",
      stopOnEntry = false,
      args = {},
    }

    local rust_launch = vim.tbl_extend("force", lldb_launch, {
      initCommands = function()
        local sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
        local etc = sysroot .. "/lib/rustlib/etc"
        return {
          ('command script import "%s/lldb_lookup.py"'):format(etc),
          ('command source "%s/lldb_commands"'):format(etc),
        }
      end,
    })
    d.configurations.rust = { rust_launch }
    d.configurations.c = { lldb_launch }
    d.configurations.cpp = { lldb_launch }
  end
  return require("dap")
end

map("n", "<leader>db", function() dap().toggle_breakpoint() end, {desc = "debug: toggle breakpoint" })
map("n", "<leader>dB", function() dap().set_breakpoint(vim.fn.input("condition: ")) end, {desc = "debug: conditional breakpoint" })
map("n", "<leader>dc", function() dap().continue() end, {desc = "debug: start/continue" })
map("n", "<leader>do", function() dap().step_over() end, { desc = "debug: step over" })
map("n", "<leader>di", function() dap().step_into() end, { desc = "debug: step into" })
map("n", "<leader>dO", function() dap().step_out() end, { desc = "debug: step out" })
map("n", "<leader>dq", function() dap().terminate() end, { desc = "debug: stop" })
map("n", "<leader>du", function() dap(); require("dapui").toggle() end, { desc = "debug: toggle panels" })

map("n", "<leader>dt", function() dap(); require("jdtls").test_nearest_method() end, { desc = "debug: nearest test (java)" })
map("n", "<leader>dT", function() dap(); require("jdtls").test_class() end, { desc = "debug: test class (java)" })

