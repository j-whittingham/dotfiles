VimUnDoå ã°ÄBüûôÈo¹$'®AädL¤xR¸U                                      ]ú»    _Ð                             ÿÿÿÿ                                                                                                                                                                                                                                                                                                                                                 v       ]úºx     õ                    P" Format _______________________________________________________________________       P" .................................................................... Line wrap   function! default#ToggleWrap()     if !Prose() | return | endif     if &formatoptions =~ 't'   H    let l:textwidth = &textwidth  " formatoptions -t sets textwidth to 0       SoftPencil       set formatoptions-=t   K    let &textwidth = l:textwidth  " restore for correct Margins calculation     else       HardPencil       set formatoptions+=t     endif   3  Notify Automatic line wrap: &formatoptions =~ 't'   endfunction5_Ð                             ÿÿÿÿ                                                                                                                                                                                                                                                                                                                                                 v       ]ú»    õ                 " sdothum - 2016 (c) wtfpl       
" Defaults   ì" ââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ       " default.vim5çª