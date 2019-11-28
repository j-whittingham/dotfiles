" sdothum - 2016 (c) wtfpl

" Defaults
" ══════════════════════════════════════════════════════════════════════════════

" Mode _________________________________________________________________________

" .................................................................. Debug trace
let g:trace = !empty($VIMTRACE)  " touch ~/.session/vim:trace

" escape problematic shell commandline characters
function! s:trace(msg)
  if g:trace | silent execute '!echo "' . substitute(a:msg, '[-<>#$]', '\\&', 'g') . '" >>/tmp/vim:trace' | endif
endfunction

command! -nargs=1 Trace call <SID>trace(<f-args>)

" ..................................................................... Terminal
" !term fails on shell error 1 (?)
command! Term :call system('term "vimterm" STACK')

" Registers ____________________________________________________________________

" ....................................................................... Macros
" https://www.reddit.com/r/vim/comments/aqmnaf/handy_shortcut_to_repeat_the_last_recorded_macro/
function! s:replayMacro()
  try
    normal @@
  catch /E748/
    normal @q
  endtry
endfunction

command! ReplayMacro silent! call <SID>replayMacro()

" Format _______________________________________________________________________

" .................................................................... Line wrap
function! s:toggleWrap()
  if !Prose() | return | endif
  if &formatoptions =~ 't'
    NoPencil
    set formatoptions-=t
  else
    HardPencil
    set formatoptions+=t
  endif
  Notify Automatic line wrap: &formatoptions =~ 't'
endfunction

command! ToggleWrap call <SID>toggleWrap()

" Search and replace ___________________________________________________________

" ........................................................... Incremental search
let s:separator = ' '  " line wrap enabled incsearch (including irregular spacing)

function! s:toggleWrapSearch()
  let s:separator = s:separator == ' ' ? '\_s*' : ' '
  cnoremap <expr><space>  '/?' =~ getcmdtype() ? s:separator : ' '
  Notify Wrap search: s:separator != ' '
endfunction

command! ToggleWrapSearch call <SID>toggleWrapSearch()

" ...................................................................... Replace
" restore search highlight after replace
function! s:searchReplace(cmd)
  let l:search = @/
  let l:s = input('', a:cmd)
  execute l:s
  let @/ = l:search
endfunction

command! -nargs=1 SearchReplace silent! call <SID>searchReplace(<f-args>)

" default.vim
