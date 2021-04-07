# vim-marko

[![Build Status](https://travis-ci.com/rajasegar/vim-marko.svg?branch=main)](https://travis-ci.com/rajasegar/vim-marko)

Vim syntax highlighting and indentation for [marko](https://markojs.com)

This is mostly just HTML syntax highlighting with some keywords added and all
expressions inside of `${` and `}` highlighted as JavaScript.

Highlighting includes:

- HTML attributes with a colon like `on-click` highlighted as `Keyword`.
- `<if>`, `</if>`, `<else>`, and `<else-if>` highlighted as `Conditional`.
- `<await>`, `</await>`, `<@catch>`, `<@then>` highlighted as `Keyword`.
- `<for>` and `<while>` highlighted as `Repeat`.


## Dependencies

The JavaScript highlighting depends on [pangloss/vim-javascript](https://github.com/pangloss/vim-javascript). That ships with
[sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot) so if you're already using that then you
should be set.


## Installation

The simplest way to install vim-marko is via a package manager like
[Pathogen](https://github.com/tpope/vim-pathogen), [Vundle](https://github.com/VundleVim/Vundle.vim), [NeoBundle](https://github.com/Shougo/neobundle.vim),
[Plug](https://github.com/junegunn/vim-plug), or [minpac](https://github.com/k-takata/minpac).

For example, using minpac:

```vimscript
call minpac#add('rajasegar/vim-marko')
```

Or using Plug:

```vimscript
Plug 'rajasegar/vim-marko', {'branch': 'main'}
```


## Options

To disable indentation within `class {` and `style {` tags, set one of these
variables in your `vimrc`:

```vim
let g:marko_indent_script = 0
let g:marko_indent_style = 0
```

## Integrations

- [ALE][ale]: vim-marko should work out of the box with `eslint` and a few
  other linters/fixers. PRs welcome if the one you want is missing.
- [matchit.vim][matchit]: vim-marko should work out of the box and allow moving
  between HTML tags as well as flow control like `#if/:else//if`.


## Tests

Indentation tests are provided and any contributions would be much appreciated.
They can be run with `make test` which will clone [vader.vim][vader] into the
current working directory and run the test suite.


