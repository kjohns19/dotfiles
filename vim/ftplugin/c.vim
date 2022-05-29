" This is also loaded by C++
function s:Format()
    %py3f /usr/share/clang/clang-format-13/clang-format.py
endfunction
function s:FormatRange() range
    '<,'>py3f /usr/share/clang/clang-format-13/clang-format.py
endfunction

let b:FileFormatFunc = function('<SID>Format')
let b:FileFormatRangeFunc = function('<SID>FormatRange')
