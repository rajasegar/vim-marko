" Vim syntax file
" Language:   Marko (HTML/JavaScript/CSS)
" Author:     Rajasegar Chandran <rajasegar.c@gmail.com>
" Maintainer: Rajasegar Chandran <rajasegar.c@gmail.com>
" Depends:    pangloss/vim-javascript
" URL:        https://github.com/rajasegar/vim-marko
"
" Like vim-jsx, this depends on the pangloss/vim-javascript syntax package (and
" is tested against it exclusively). If you're using vim-polyglot, then you're
" all set.

if exists("b:current_syntax")
  finish
endif

" Read HTML to begin with.
runtime! syntax/html.vim
unlet! b:current_syntax

" Expand HTML tag names to include mixed case, periods, and colons.
syntax match htmlTagName contained "\<[a-zA-Z:\.]*\>"

" According to vim-jsx, you can let jsBlock take care of ending the region.
"   https://github.com/mxw/vim-jsx/blob/master/after/syntax/jsx.vim
syntax region markoExpression start="${" end="" contains=jsBlock,javascriptBlock containedin=htmlString,htmlTag,htmlArg,htmlValue,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlHead,htmlTitle,htmlBoldItalicUnderline,htmlUnderlineBold,htmlUnderlineItalicBold,htmlUnderlineBoldItalic,htmlItalicUnderline,htmlItalicBold,htmlItalicBoldUnderline,htmlItalicUnderlineBold,htmlLink,htmlLeadingSpace,htmlBold,htmlBoldUnderline,htmlBoldItalic,htmlBoldUnderlineItalic,htmlUnderline,htmlUnderlineItalic,htmlItalic,htmlStrike,javaScript

" Block conditionals.
syntax match markoConditional "if" contained containedin=htmlTag
syntax match markoConditional "else-if" contained containedin=htmlTag
syntax match markoConditional "else" contained containedin=htmlTag

" Block keywords.
syntax match markoKeyword "await" contained containedin=htmlTag
syntax match markoKeyword "@catch" contained containedin=htmlTag
syntax match markoKeyword "/@catch" contained containedin=htmlTag
syntax match markoKeyword "@then" contained containedin=htmlTag
syntax match markoKeyword "/@then" contained containedin=htmlTag
syntax match markoKeyword "@placeholder" contained containedin=htmlTag
syntax match markoKeyword "/@placeholder" contained containedin=htmlTag
syntax match markoKeyword "@include-text" contained containedin=htmlTag
syntax match markoKeyword "@include-html" contained containedin=htmlTag
syntax match markoKeyword "macro" contained containedin=htmlTag

" Repeat functions.
syntax match markoRepeat "for" contained containedin=htmlTag
syntax match markoRepeat "while" contained containedin=htmlTag

highlight def link markoConditional Conditional
highlight def link markoKeyword Keyword
highlight def link markoRepeat Repeat

" Preprocessed languages that aren't supported out of the box by marko require
" additional syntax files to be pulled in and can slow Vim down a bit. For that
" reason, preprocessed languages must be enabled manually. Note that some may
" require additional plugins that contain the actual syntax definitions.
"
" Heavily cribbed from https://github.com/posva/vim-vue and largely completed by
" @davidroeca (thank you!).

" A syntax should be registered if there's a valid syntax definition known to
" Vim and it is enabled for the marko plugin.
function! s:enabled(language)
  " Check whether a syntax file for {language} exists
  let s:syntax_name = get(a:language, 'as', a:language.name)
  if empty(globpath(&runtimepath, 'syntax/' . s:syntax_name . '.vim'))
    return 0
  endif

  " If g:marko_preprocessors is set, check for it there, otherwise return 0.
  if exists('g:marko_preprocessors') && type(g:marko_preprocessors) == v:t_list
    return index(g:marko_preprocessors, a:language.name) != -1
  else
    return 0
  endif
endfunction

" Default tag definitions.
let s:languages = [
      \ { 'name': 'less', 'tag': 'style' },
      \ { 'name': 'scss', 'tag': 'style' },
      \ { 'name': 'sass', 'tag': 'style' },
      \ { 'name': 'stylus', 'tag': 'style' },
      \ { 'name': 'typescript', 'tag': 'script' },
      \ ]

" Add global tag definitions to our defaults.
if exists('g:marko_preprocessor_tags') && type(g:marko_preprocessor_tags) == v:t_list
  let s:languages += g:marko_preprocessor_tags
endif

for s:language in s:languages
  let s:attr = '\(lang\|type\)=\("\|''\)[^\2]*' . s:language.name . '[^\2]*\2'
  let s:start = '<' . s:language.tag . '\>\_[^>]*' . s:attr . '\_[^>]*>'

  if s:enabled(s:language)
    execute 'syntax include @' . s:language.name . ' syntax/' . get(s:language, 'as', s:language.name) . '.vim'
    unlet! b:current_syntax

    execute 'syntax region marko_' . s:language.name
          \ 'keepend'
          \ 'start=/' . s:start . '/'
          \ 'end="</' . s:language.tag . '>"me=s-1'
          \ 'contains=@' . s:language.name . ',markoSurroundingTag'
          \ 'fold'
  endif
endfor


" JAVA SCRIPT
syntax include @htmlJavaScript syntax/javascript.vim
unlet b:current_syntax
syntax region  markoJavaScript start=+class {+ keepend end=+}+me=s-1 contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc

"syntax region markoSurroundingTag contained start='class {'  end='}' fold contains=jsBlock,javascriptBlock,javaScript

" CSS
syntax include @htmlCss syntax/css.vim
unlet b:current_syntax
syntax region markoStyle start=+style {+ keepend end=+}+ fold contains=@htmlCss,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc
 

syntax region markoForParameter start='|' end='|' contains=jsIdentifier containedin=htmlTag

" HTML Re-imagined
let b:current_syntax = "marko"

" Sync from start because of the wacky nesting.
syntax sync fromstart
