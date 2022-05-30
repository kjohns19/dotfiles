let s:get_formatter_script = expand('<sfile>:p:h') . '/get_formatter.py'

" This is also loaded by C++
function s:Format()
    let l:formatter = system(s:get_formatter_script)
    if v:shell_error == 0
        execute '%py3f ' . l:formatter
    else
        echoerr l:formatter
    endif
endfunction
function s:FormatRange() range
    let l:formatter = system(s:get_formatter_script)
    if v:shell_error == 0
        execute '''<,''>py3f' . l:formatter
    else
        echoerr l:formatter
    endif
endfunction

let b:FileFormatFunc = function('<SID>Format')
let b:FileFormatRangeFunc = function('<SID>FormatRange')
