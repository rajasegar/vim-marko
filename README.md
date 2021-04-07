# vim-marko

[![Build Status](https://travis-ci.com/rajasegar/vim-marko.svg?branch=main)](https://travis-ci.com/rajasegar/vim-marko)

Vim syntax highlighting and indentation for [marko](https://markojs.com)

This is mostly just HTML syntax highlighting with some keywords added and all
expressions inside of `${` and `}` highlighted as JavaScript.

Highlighting includes:

- HTML attributes with a colon like `on-click` highlighted
    as `Keyword`.
- `#if`, `/if`, `:else`, and `:else if` highlighted as `Conditional`.
- `#await`, `/await`, `:catch`, `:then`, and `@html` highlighted as `Keyword`.
- `#each` and `/each` highlighted as `Repeat`.


## Dependencies

The JavaScript highlighting depends on
[pangloss/vim-javascript][vim-javascript]. That ships with
[sheerun/vim-polyglot][vim-polyglot] so if you're already using that then you
should be set.


## Installation

The simplest way to install vim-marko is via a package manager like
[Pathogen][pathogen], [Vundle][vundle], [NeoBundle][neobundle],
[Plug][vim-plug], or [minpac][minpac].

For example, using minpac:

```vimscript
call minpac#add('rajasegar/vim-marko')
```

Or using Plug:

```vimscript
Plug 'rajasegar/vim-marko', {'branch': 'main'}
```

vim-marko works just fine with Vim 8's native package loading as well, that's
what I use.


## Options

To disable indentation within `<script>` and `<style>` tags, set one of these
variables in your `vimrc`:

```vim
let g:marko_indent_script = 0
let g:marko_indent_style = 0
```


## Preprocessed languages

Syntax highlighting for additional languages is supported, assuming you have a
corresponding syntax definition installed. For example, newer versions of Vim
ship with a TypeScript syntax definition, so you wouldn't need anything
additional installed for that to work. Supported languages include:

- `less`
- `scss`
- `sass`
- `stylus`
- `typescript`

Since marko doesn't support these out of the box (see
[marko-preprocess][preprocess] for how to set up some common language
preprocessors with e.g. Rollup), they're all disabled by default so the first
thing you'll need to do is enable your languages via the
`g:marko_preprocessors` variable:

```vim
let g:marko_preprocessors = ['typescript']
```

Then, use your language in your marko components like this:

```html
<script lang='typescript'>
</script>

<!-- Or... -->
<style type='text/scss'>
</style>
```

### Customizing the list of preprocessed languages

In addition to enabling the built-in preprocessors, you can add your own
preprocessors that this plugin will detect using the
`g:marko_preprocessor_tags` variable. It should be a list of dictionaries with
at least a `name` and a `tag` attribute. You can optionally include an `as`
attribute which maps to the syntax you'd like to use within the tag.

Here's an example:

```vim
let g:marko_preprocessor_tags = [
  \ { 'name': 'postcss', 'tag': 'style', 'as': 'scss' }
  \ ]
" You still need to enable these preprocessors as well.
let g:marko_preprocessors = ['postcss']
```

This would highlight `<style type="postcss">` contents as `scss`, useful if you
use something like [postcss-nested][nested].

You can also create shorthand names if, for example, writing out
`lang='typescript'` takes too long:

```vim
let g:marko_preprocessor_tags = [
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]
let g:marko_preprocessors = ['ts']
```

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Usage</th>
      <th>Required</th>
      <th>Default value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        The value within the attribute <code>lang</code> or <code>type</code> on
        the <code>tag</code> as well as the value to include in
        <code>g:marko_preprocessors</code>.
      </td>
      <td>Yes</td>
      <td>None</td>
    </tr>
    <tr>
      <td><code>tag</code></td>
      <td>The HTML tag to target e.g. <code>script</code> or <code>style</code>.</td>
      <td>Yes</td>
      <td>None</td>
    </tr>
    <tr>
      <td><code>as</code></td>
      <td>The syntax name to use for highlighting.</td>
      <td>No</td>
      <td>The <code>name</code> attribute.</td>
    </tr>
  </tbody>
</table>

Note, that enabling and loading a lot of different syntax definitions can
considerably degrade Vim's performance. Consider yourself warned.


## Integrations

- [ALE][ale]: vim-marko should work out of the box with `eslint` and a few
  other linters/fixers. PRs welcome if the one you want is missing.
- [matchit.vim][matchit]: vim-marko should work out of the box and allow moving
  between HTML tags as well as flow control like `#if/:else//if`.


## Tests

Indentation tests are provided and any contributions would be much appreciated.
They can be run with `make test` which will clone [vader.vim][vader] into the
current working directory and run the test suite.


