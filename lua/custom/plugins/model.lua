return {
  {
    'gsuuon/model.nvim',
    cmd = { 'M', 'Model', 'Mchat' },
    init = function()
      vim.filetype.add {
        extension = {
          mchat = 'mchat',
        },
      }
    end,
    ft = 'mchat',

    keys = {
      { '<C-m>d', ':Mdelete<cr>', mode = 'n' },
      { '<C-m>s', ':Mselect<cr>', mode = 'n' },
      { '<C-m><space>', ':Mchat<cr>', mode = 'n' },
    },
  },
}
