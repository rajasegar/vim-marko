" Vim indent file
" Language:   Marko (HTML/JavaScript/CSS)
" Author:     Rajasegar Chandran <rajasegar.c@gmail.com>
" Maintainer: Rajasegar Chandran <rajasegar.c@gmail.com>
" URL:        https://github.com/rajasegar/vim-marko

if exists("b:did_indent")
  finish
endif

if !exists('g:marko_indent_script')
  let g:marko_indent_script = 1
endif

if !exists('g:marko_indent_style')
  let g:marko_indent_style = 1
endif

" Try to mirror marko's indent settings so the HTML indenting scripts match.
if g:marko_indent_script
  let b:html_indent_script1 = "inc"
else
  let b:html_indent_script1 = "zero"
endif

if g:marko_indent_style
  let b:html_indent_style1 = "inc"
else
  let b:html_indent_style1 = "zero"
endif

runtime! indent/html.vim
unlet! b:did_indent

let s:html_indent = &l:indentexpr
let b:did_indent = 1

setlocal indentexpr=GetMarkoIndent()
setlocal indentkeys=o,O,*<Return>,<>>,{,},0),0],!^F,;,=/else,=/else-if,=/@then,=/@catch,=/@placeholder,=/if,=/for,=/await,=/while,=/macro

" Only define the function once.
if exists('*GetMarkoIndent')
  finish
endif

function! GetMarkoIndent()
  let current_line_number = v:lnum

  if current_line_number == 0
    return 0
  endif

  let current_line = getline(current_line_number)

  " Opening class and style tags should be all the way outdented.
  if current_line =~ '^\s*\(class\|style\)\s*\{'
    return 0
  endif

  let previous_line_number = prevnonblank(current_line_number - 1)
  let previous_line = getline(previous_line_number)
  let previous_line_indent = indent(previous_line_number)

  " The inside of class and style should be indented unless disabled.
  if previous_line =~ '^\s*class\s*{'
    if g:marko_indent_script
      return previous_line_indent + shiftwidth()
    else
      return previous_line_indent
    endif
  endif

  if previous_line =~ '^\s*style\s*{'
    if g:marko_indent_style
      return previous_line_indent + shiftwidth()
    else
      return previous_line_indent
    endif
  endif

  execute "let indent = " . s:html_indent

  " For some reason, the HTML CSS indentation keeps indenting the next line over
  " and over after each style declaration.
  if searchpair('style {', '', '}', 'bW') && previous_line =~ ';$' && current_line !~ '}'
    return previous_line_indent
  endif

  " "/await" or ":catch" or ":then"
  if current_line =~ '^\s*{\s*\/await' || current_line =~ '^\s*{\s*:\(catch\|then\)'
    let await_start = searchpair('{\s*#await\>', '', '{\s*\/await\>', 'bW')

    if await_start
      return indent(await_start)
    endif
  endif

  " "/each"
  if current_line =~ '^\s*{\s*\/each'
    let each_start = searchpair('{\s*#each\>', '', '{\s*\/each\>', 'bW')

    if each_start
      return indent(each_start)
    endif
  endif

  " "/if"
  if current_line =~ '^\s*{\s*\/if'
    let if_start = searchpair('{\s*#if\>', '', '{\s*\/if\>', 'bW')

    if if_start
      return indent(if_start)
    endif
  endif

  " ":else" is tricky because it can match an opening "#each" _or_ an opening
  " "#if", so we try to be smart and look for the closest of the two.
  if current_line =~ '^\s*{\s*:else'
    let if_start = searchpair('{\s*#if\>', '', '{\s*\/if\>', 'bW')

    " If it's an "else if" then we know to look for an "#if"
    if current_line =~ '^\s*{\s*:else if' && if_start
      return indent(if_start)
    else
      " The greater line number will be closer to the cursor position because
      " we're searching backward.
      return indent(max([if_start, searchpair('{\s*#each\>', '', '{\s*\/each\>', 'bW')]))
    endif
  endif

  " "#if" or "#each"
  if previous_line =~ '^\s*{\s*#\(if\|each\|await\)'
    return previous_line_indent + shiftwidth()
  endif

  " ":else" or ":then"
  if previous_line =~ '^\s*{\s*:\(else\|catch\|then\)'
    return previous_line_indent + shiftwidth()
  endif

  return indent
endfunction
