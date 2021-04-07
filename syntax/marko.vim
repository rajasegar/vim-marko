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

" JAVA SCRIPT
syntax include @htmlJavaScript syntax/javascript.vim
unlet b:current_syntax
syntax region  markoJavaScript start=+class {+ keepend end=+}+me=s-1 contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc


" CSS
syntax include @htmlCss syntax/css.vim
unlet b:current_syntax
syntax region markoStyle start=+style {+ keepend end=+}+me=s-1  contains=@htmlCss,htmlTag,htmlEndTag,htmlCssStyleComment,@htmlPreproc
 

syntax region markoForParameter start='|' end='|' contains=jsIdentifier containedin=htmlTag

" HTML Re-imagined
let b:current_syntax = "marko"

" Sync from start because of the wacky nesting.
syntax sync fromstart
