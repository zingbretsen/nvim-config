return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup()

      -- local path = require('mason-registry').get_package('debugpy'):get_install_path()
      require('dap-python').setup()
      --.setup(path .. '/venv/bin/python')

      require('nvim-dap-virtual-text').setup()

      dap.adapters.python = {
        type = 'executable',
        command = '/tmp/.venv/bin/python -m debugpy.adapter',
      }
      --
      --
      local python_ls_debugger = vim.fn.exepath 'debugpy'
      if python_ls_debugger ~= '' then
        dap.adapters.python = {
          type = 'executable',
          command = '/tmp/.venv/bin/python',
          args = { '-m', 'debugpy.adapter' },
        }

        -- dap.adapters.streamlit = {
        --   type = 'executable',
        --   command = '/tmp/.venv/bin/python',
        --   args = { '-m', 'debugpy.adapter' },
        -- }
        --
        dap.configurations.python = {
          {
            type = 'python',
            name = 'launch with options',
            python = function() end,
            program = '${file}',
            pythonPath = function()
              -- Automatically detect the Python path from the current virtual environment
              local venv_path = os.getenv 'VIRTUAL_ENV'
              if venv_path then
                return venv_path .. '/bin/python'
              else
                -- Use system Python if not in a virtual environment
                return 'python' -- Replace with your global Python path
              end
            end,
            -- task = 'phx.server',
            request = 'launch',
            projectDir = '${workspaceFolder}',
            exitAfterTaskReturns = false,
            debugAutoInterpretAllModules = false,
          },
          -- {
          --   type = 'streamlit',
          --   name = 'streamlit',
          --   python = function() end,
          --   module = 'streamlit.cli',
          --   args = { 'run', '${file}' },
          --   pythonPath = function()
          --     -- Automatically detect the Python path from the current virtual environment
          --     local venv_path = os.getenv 'VIRTUAL_ENV'
          --     if venv_path then
          --       return venv_path .. '/bin/python'
          --     else
          --       -- Use system Python if not in a virtual environment
          --       return 'python' -- Replace with your global Python path
          --     end
          --   end,
          --   -- task = 'phx.server',
          --   request = 'launch',
          --   projectDir = '${workspaceFolder}',
          --   exitAfterTaskReturns = false,
          --   debugAutoInterpretAllModules = false,
          -- },
        }
      end

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F13>', dap.restart)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
