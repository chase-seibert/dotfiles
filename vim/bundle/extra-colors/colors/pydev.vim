set background=light
highlight clear
if exists("syntax_on")
    syntax reset
endif

" Syntax group
highlight Comment    gui=none guifg=#C0C0C0 guibg=bg      ctermfg=2
highlight Constant   gui=none guifg=#00884c guibg=bg      ctermfg=White
highlight Error      gui=none guifg=#f8f8f8 guibg=#4040ff term=reverse        ctermbg=Red    ctermfg=White
highlight Identifier gui=bold guifg=#000000 guibg=bg      ctermfg=Green
highlight Ignore     gui=none guifg=bg      guibg=bg      ctermfg=black
highlight PreProc    gui=none guifg=#0000FF guibg=bg      ctermfg=Green
highlight Special    gui=none guifg=#00AA00 guibg=bg      ctermfg=DarkMagenta
highlight Statement  gui=none guifg=#0000FF guibg=bg      ctermfg=White
highlight Todo       gui=none guifg=#ff5050 guibg=white   term=standout       ctermbg=Yellow ctermfg=Black
highlight Type       gui=none guifg=#000000 guibg=bg      ctermfg=LightGreen
highlight Underlined gui=none guifg=blue    guibg=bg
highlight String     gui=none guifg=#00AA00 guibg=bg      ctermfg=Yellow
highlight Number     gui=none guifg=#800000 guibg=bg      ctermfg=White

if !has("gui_running")
    hi link Float          Number
    hi link Conditional    Repeat
    hi link Include        PreProc
    hi link Macro          PreProc
    hi link PreCondit      PreProc
    hi link StorageClass   Type
    hi link Structure      Type
    hi link Typedef        Type
    hi link Tag            Special
    hi link Delimiter      Normal
    hi link SpecialComment Special
    hi link Debug          Special
endif
