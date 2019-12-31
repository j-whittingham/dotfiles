" sdothum - 2016 (c) wtfpl

" Info
" ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂

  " Buffer statistics ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁

    " .................................................................... Setup

      let s:linedrawing = '▁─▔▂'            " declare multibytes, see heading.vim

      " regex list of multibyte characters used for line drawing
      " note: files using other multibyte characters will produce incorrect statistics
      let s:indicators = '▶■≈⌉'             " multibyte statusline indicators
      let s:multibytes = '[' . s:linedrawing . s:indicators . ']'
      let s:ascii      = '\(\d\|\a\|\s\|[`~!@#$%^&*()_\-+={}\[\]\\|;:\",\.<>/?]\)'

      augroup info
        autocmd!
      augroup END

  " ................................................... Byte position percentage

      function! BytePercent()
        " let byte = line2byte(line('.') + 1) - 1
        let byte   = line2byte(line('.')) + col('.') - 1
        let size   = line2byte(line('$') + 1) - 1
        return (line("w0") != 1 && line("w$") != line("$")) ? (byte * 100) / size : ''
      endfunction

    " ................................................................ Line info


      " see https://github.com/scrooloose/vimfiles/blob/master/vimrc#L78
      " return a warning for long lines > g:linewidth
      function! s:LineSizes()
        " return 'x +/y z' if long lines are found, where
        "   x is the number of long lines
        "   y is the median length of the long lines
        "   z is the length of the longest line
        if !exists('b:statusline_long_line_warning')
          let b:statusline_long_line_warning = ''
          if &modifiable
            let long_line_lens = s:LongLines()
            if len(long_line_lens) > 0
              let b:statusline_long_line_warning =
                  \         len(long_line_lens) . '>'
                  \. ' ≈' . s:Median(long_line_lens)
                  \. ' ⌉'  . max(long_line_lens)
            else
              let b:statusline_long_line_warning = '0>'
            endif
          endif
        endif
        return b:statusline_long_line_warning
      endfunction

      " return a list containing the lengths of the long lines in this buffer
      function! s:LongLines()
        let l:spaces    = repeat(' ', &tabstop)
        " trap multibyte line drawing characters used by "ruler" and "underline"
        let l:line_lens = map(getline(1,'$'),
            \ 'len(substitute(v:val =~ s:multibytes
            \? substitute(v:val, s:multibytes, " ", "g")
            \: v:val, "\\t", l:spaces, "g"))')
        return filter(l:line_lens, 'v:val > g:linewidth')
      endfunction

      " find the median of the given array of numbers
      function! s:Median(nums)
        let l:nums     = SortNumbers(a:nums) " original code incorrectly sorted by text
        let l:size     = len(l:nums)
        if l:size % 2 == 1
          let l:middle = (l:size-1)/2
          return l:nums[l:middle]
        else
          return (l:nums[l:size/2] + l:nums[(l:size/2)-1]) / 2
        endif
      endfunction

      function! LineSizes()
        if s:code == 1
          return s:LineSizes()
        endif
        return ''
      endfunction

      " line statistics off by default per buffer (declare flags to b:uffer)
      " autocmd info BufRead               * let b:code = 0
      " recalculate the long line warning when idle and after saving
      autocmd info CursorHold,BufWritePost * unlet! b:statusline_long_line_warning

    " ............................................................... Word count

      " see http://stackoverflow.com/questions/114431/fast-word-count-function-in-vim
      " null return suppresses wordcount for non-prose or empty new buffer
      function! WordCount()
        " trap buffer window, visual mode (gives incorrect word count)
        if expand('%:t') == 'ControlP' || mode() =~ '[vV]'
          return ''
        endif
        if s:code == 0 && s:prose == 0
          return ''
        endif
        let b:wordcount   = ''
        let l:statusmsg   = v:statusmsg
        let l:position    = getpos('.')     " g<C-g> prevents (cursor from) appending to EOL in vim 7.4
        execute "silent normal! g\<C-g>"
        if v:statusmsg != '--No lines in buffer--'
          let b:wordcount = str2nr(split(v:statusmsg)[11])
        endif
        let v:statusmsg   = l:statusmsg
        " go back (to EOL if need be)
        call setpos('.', l:position)
        return b:wordcount
      endfunction

    " ........................................................ Special Character

      function! SpecialChar()
        if mode() == 'n'                    " getline() test fails on switch into insert mode
          try
            if getline(line('.')) != ''     " ignore newline (is NUL)
              let l:char        = getline('.')[col('.')-1]
              " show hex value, not interested in ascii keyboard characters
              if l:char !~ s:ascii && l:char != "'"
                let l:statusmsg = v:statusmsg
                normal! ga
                let l:hex       = 'U+' . matchstr(split(v:statusmsg)[3], '[^,]*')
                let v:statusmsg = l:statusmsg
                " clear ga information!
                echo ''
                return l:hex
              endif
            endif
          catch /.*/
            " discard messages and clear message line
            echo ''
          endtry
        endif
        return ''
      endfunction

    " ................................................................. Warnings

      " see https://github.com/scrooloose/vimfiles/blob/master/vimrc#L78
      " inconsistent tab warning, return '&expandtab' if &expandtab is set wrong
      " return '|▶' if spaces and tabs are used to indent
      function! Indent()
        if !exists('b:statusline_tab_warning')
          let b:statusline_tab_warning = ''
          if &modifiable
            let l:tabs = search('^\t', 'nw') != 0
            "find spaces that arent used as alignment in the first indent column
            let l:spaces = search('^ \{' . &tabstop . ',}[^\t]', 'nw') != 0
            if l:tabs && l:spaces
              let b:statusline_tab_warning = '|▶'
            elseif (l:spaces && !&expandtab) || (l:tabs && &expandtab)
              let b:statusline_tab_warning = '&expandtab'
            endif
          endif
        endif
        return b:statusline_tab_warning
      endfunction

      " trailing spaces warning, return '■|' if trailing spaces/tabs are present
      function! Spaces()
        if !exists('b:statusline_pad_warning')
          let b:statusline_pad_warning = ''
          if &modifiable
            if s:prose == 0
              if search('[ \t]\+$', 'nw') != 0
                let b:statusline_pad_warning = '■|'
              endif
            endif
          endif
        endif
        return b:statusline_pad_warning
      endfunction

      " recalculate the tab warning flag when idle and after writing
      autocmd info CursorHold,BufWritePost * unlet! b:statusline_tab_warning
      " recalculate the trailing whitespace warning when idle, and after saving
      autocmd info CursorHold,BufWritePost * unlet! b:statusline_pad_warning

" info.vim
