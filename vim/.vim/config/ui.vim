" sdothum - 2016 (c) wtfpl

" User Interface
" ══════════════════════════════════════════════════════════════════════════════

" Fonts ________________________________________________________________________

augroup ui | autocmd! | augroup END

" ................................................................. Code / Prose
" Iosevka custom compiled, with nerd-fonts awesome patches, see make_install/iosevka
let g:mono      = empty(glob('~/.session/vim:mono')) ? '' : '-mono'         " see statusline.vim
let g:font      = ['Iosevka' . $MONO . '\', 'Iosevka-proof' . $MONO . '\']  " family [code, prose]
let g:font_type = -1                                                        " current font setting (0) source (1) prose
let g:font_step = empty(glob('~/.session/vim:fontsize')) ? 1 : 2            " increase (point size) for prose

" Display ______________________________________________________________________

" ................................................................... Initialize
" intial view mode: source code or prose, plugin windows inherit current theme (avoids thrashing)
autocmd ui VimEnter,BufWinEnter * Layout

" ....................................................................... Redraw
nmap <silent><F9>      :Refresh<CR>
imap <silent><F9> <C-o>:Refresh<CR>

" ..................................................................... Messages
" clear messages after awhile to keep screen clean and distraction free!
autocmd ui CursorHold * echo

" Highlighting _________________________________________________________________

" .......................................................... Syntax highlighting
set omnifunc=syntaxcomplete#Complete
syntax on  " turn on syntax highlighting
 
" ftplugin set syntax is overridden by vim runtime Syntax autocmd
autocmd ui Syntax <buffer> execute 'set syntax=' . &filetype
" refresh highlighting on arm
" autocmd ui CursorHold * if !Prose() && !&diff && !empty(&filetype) | execute 'set filetype=' . &filetype | endif

" UI ___________________________________________________________________________

" ............................................................ Toggle statusline
" toggle statusline details
nmap <silent><F7>        :ToggleInfo<CR>
imap <silent><F7>   <C-o>:ToggleInfo Prose()<CR>

" show info+sleep in balanced diff windows
autocmd ui VimEnter * if &diff | ToggleInfo | WaitFor | execute "normal! \<C-w>=" | endif

" .................................................................... View mode
nmap <silent><F11>      :ToggleProof<CR>
imap <silent><F11> <C-o>:ToggleProof<CR>

if has('gui_running')
  autocmd ui InsertEnter * ToggleProof | SignifyDisable
  autocmd ui InsertLeave * ToggleProof | SignifyEnable
endif

" ............................................................. Switch font size
nmap <silent><S-F9>      :Font !g:font_type<CR>
imap <silent><S-F9> <C-o>:Font !g:font_type<CR>

" ui.vim
