function s:Format()
    call Flake8()
endfunction

let b:FileFormatFunc = function('<SID>Format')
