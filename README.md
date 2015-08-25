# vivi.vim [![Circle CI](https://circleci.com/gh/liquidz/vivi.vim.svg?style=svg)](https://circleci.com/gh/liquidz/vivi.vim)

Support to setup a Elixir development environment in Vim.

## Requirements

* [vim-elixir](https://github.com/elixir-lang/vim-elixir) -> Syntax highlighting
* [vim-quickrun](https://github.com/thinca/vim-quickrun) -> Running `mix test`
* [vim-watchdogs](https://github.com/osyo-manga/vim-watchdogs) -> Syntax checking

## Installation

 * neobundle
```
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'liquidz/vivi.vim'
```

## Configuration

* Enables auto syntax checking. (default: DISABLED)
```
let g:vivi_enable_auto_syntax_checking = 1
```
* Enables default key mappings. (default: DISABLED)
```
let g:vivi_enable_default_key_mappings = 1
```

## Default key mappings

| mode   | lhs   | rhs  | notes |
| ------ | ----- | ---- | ----- |
| insert | ">>"  | "\|>" | Pipeline. |
| normal | \<Leader\>t  | \<Plug\>(vivi_mix_test) | Run `mix test`. |
| visual | \<Leader\>t  | \<Plug\>(vivi_mix_line_test) | Run `mix test` with specific line number. |

## License

Copyright (c) 2015 [Masashi Iizuka](http://twitter.com/uochan)

Distributed under the MIT License.
