# Butane: Vim Buffer Utilities
## Light your buffers up.

Currently Butane provides only one simple command, the Bclose command, which
closes a buffer without changing the layout of your windows. (The most recently
used buffer, or failing that the previous buffer, or finally an empty file will
be placed in its place.)

If you want to give your buffers a bit of an extra spark I recommend the
following maps in your .vimrc or equivalent:

    noremap <leader>bd :Bclose<CR>      " Close the buffer.
    noremap <leader>bD :Bclose!<CR>     " Close the buffer & discard changes.
    noremap <leader>bn :bn<CR>          " Next buffer.
    noremap <leader>bp :bp<CR>          " Previous buffer.
    noremap <leader>bl :ls<CR>          " List buffers.
    noremap <leader>bt :b#<CR>          " Toggle to most recently used buffer.

Most of these commands are simple, but with a good leader key they are
much easier to hit than their built-in counterparts.
