" sdothum - 2016 (c) wtfpl

" Files
" ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂

  " File handling ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁

    " ........................................................ Filetype settings

      nmap <leader><leader>t :setfiletype<Space>

      augroup filetype
        autocmd!
        autocmd Filetype conf    setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype draft   setlocal spell wrap enc=utf-8 formatoptions=twa1 textwidth=72 syntax=mail
        autocmd Filetype fish    setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype haskell setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype lua     setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype mail    setlocal spell wrap enc=utf-8 formatoptions=twa1 textwidth=72 syntax=mail
        autocmd Filetype python  setlocal nospell expandtab tabstop=4 shiftwidth=4 softtabstop=4
        autocmd Filetype ruby    setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype shell   setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype sh      setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype slim    setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
        autocmd Filetype vim     setlocal nospell expandtab tabstop=2 shiftwidth=2 softtabstop=2
      augroup END

    " ............................................................... Modifiable

      let g:goyotypes = 'vimwiki\|mail\|draft'

      " [regex name, filetype, modifiable, wordcount] rule tuple
      " modifiable (0) nomodifiable (1) modifiable
      " wordcount (0) no word count (1) statusline with wordcount
      " note "/name" to represent "^name"
      let s:nametypes =
        \[
        \  ['conf$', 'conf', 1, 0]
        \, ['config$', 'conf', 1, 0]
        \, ['eml$', 'mail', 1, 1]
        \, ['error$', 'log', 0, 0]
        \, ['log$', 'log', 0, 0]
        \, ['rc$', 'rc', 1, 0]
        \, ['txt$', 'text', 0, 1]
        \, ['wiki$', 'vimwiki', 1, 1]
        \, ['\(^\|/\)readme', 'text', 0, 1]
        \]

      " [regex fileinfo, filetype, modifiable, readonly] rule tuple
      " modifiable (0) nomodifiable (1) modifiable
      " readonly (0) not set (1) set
      let s:contenttypes =
        \[
        \  ['binary', 'binary', 0, 1]
        \, ['no read permission', 'binary', 0, 1]
        \, ['text', 'text', 1, 0]
        \]

      " set buffer attributes by known filetypes
      function! CheckFiletype()
        for [name, filetype, modifiable, wordcount] in s:nametypes
          if expand('%') =~ name
            let &filetype = (&filetype == '' ? filetype : &filetype)
            let &modifiable = modifiable
            break
          endif
        endfor
        if &filetype == ''                  " by file content if not autodetected
          for [content, filetype, modifiable, readonly] in s:contenttypes
            if system('file -i ' . expand('%') . '|cut -d: -f2') =~ content
              let &filetype = filetype
              let &modifiable = modifiable
              let &readonly = readonly
            endif
          endfor
        endif
      endfunction

      " toggle modifiable attribute
      " nmap <silent><C-F1>  :let &modifiable = (&modifiable == 0 ? 1 : 0)<CR>
      nmap <silent><leader>- :let &modifiable = (&modifiable == 0 ? 1 : 0)<CR>

      " check filetype on open
      autocmd filetype BufNewFile,BufRead * call CheckFiletype()
      autocmd filetype BufWinEnter        *.txt,*.txt.gz if &filetype == 'help' | set nomodifiable | endif

  " Documents ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁

    " .................................................................... Wikis

      function! Wiki(index)
        " open vimwiki index file
        execute 'normal ' . a:index . g:mapleader . "ww"
        " vimenter bypasses other autocmds and filetype assignments
        " producing an unitialized non-lightline (raw) statusline !!??
        call CheckFiletype()
      endfunction

      function! OpenWikis()
        " new 'maxhi' option is still a bit buggy
        redir! >/tmp/vim.log
        for index in reverse(range(2, len(g:vimwiki_list))) " skip journal" wiki(1)
          call Wiki(index)
        endfor
        if &filetype =~ g:goyotypes         " reset cursorline (for last open for some reason..)
          call ToggleHiLite()
        endif
        redir END
      endfunction

      " open vimwiki ()
      autocmd filetype VimEnter * if argv (0) =~ '/vimwiki$' | bdelete | call OpenWikis() | endif
      autocmd filetype VimEnter * if &filetype =~ g:goyotypes | call ToggleGoyo() | endif

    " ................................................................... E-mail

      function! ComposeMail()
        call SetTheme()                     " set default cursorline highlight
        call FontSize(0)                    " set font
        call ProseView()
        " email has blank lines inserted externally (via sed) for replys to
        " avoid the previously messy and unpredictable editing mode vim commands
        " see bin/dcompose
        execute 'normal 4G'
        if matchstr(getline(5), '\S') > ''
          execute 'normal Yp'
        endif
        execute 'startinsert'
      endfunction

      " position cursor for email reply or new message, see .sup/config.yaml and bin/dcompose
      autocmd filetype Filetype mail call ComposeMail()

" files.vim
