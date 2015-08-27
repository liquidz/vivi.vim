# vivi.vim [![Circle CI](https://circleci.com/gh/liquidz/vivi.vim.svg?style=svg)](https://circleci.com/gh/liquidz/vivi.vim)

Support to setup a Elixir development environment in Vim.

## Requirements

* [vim-elixir](https://github.com/elixir-lang/vim-elixir) -> Syntax highlighting
* [vim-quickrun](https://github.com/thinca/vim-quickrun) -> Running `mix` commands.
* [shabadou.vim](https://github.com/osyo-manga/shabadou.vim) -> Required by vim-watchdogs
* [vim-watchdogs](https://github.com/osyo-manga/vim-watchdogs) -> Syntax checking

## Installation

 * neobundle
```
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'liquidz/vivi.vim'
```

## Interface

### Commands

| command | notes |
| ------- | ----- |
| MixRun  | Run `mix run $CURRENT_FILE` in mix project, or run `elixir $CURRENT_FILE`. |
| MixDepsGet | Run `mix deps.get`. |
| MixDepsUpdateAll | Run `mix deps.update --all`. |
| MixTest | Run `mix test`. |
| MixTestForCurrentLine | Run `mix test` for current line number. |

### Key Mappings

| mode | mapping | notes |
| ---- | ------- | ----- |
| normal | \<Plug\>(vivi_mix_run) | call `MixRun` command. |
| normal | \<Plug\>(vivi_mix_deps_get) | call `MixDepsGet` command. |
| normal | \<Plug\>(vivi_mix_deps_update_all) | call `MixDepsUpdateAll` command. |
| normal | \<Plug\>(vivi_mix_test) | call `MixTest` command. |
| visual | \<Plug\>(vivi_mix_test_for_current_line) | call `MixTestForCurrentLine` command. |

## Configuration

* Enables auto syntax checking. (default: **DISABLED**)
```
let g:vivi_enable_auto_syntax_checking = 1
```
* Enables default key mappings. (default: **DISABLED**)
```
let g:vivi_enable_default_key_mappings = 1
```
* Change quickrun configration for `mix run` and `mix test`.
```
let g:vivi_mix_run_config = { ... }
let g:vivi_mix_test_config = { ... }
```

## Default Key Mappings

| mode   | lhs   | rhs  | notes |
| ------ | ----- | ---- | ----- |
| insert | ">>"  | "\|>" | Pipeline. |
| normal | \<Leader\>r  | \<Plug\>(vivi_mix_run) | |
| normal | \<Leader\>t  | \<Plug\>(vivi_mix_test) | |
| visual | \<Leader\>t  | \<Plug\>(vivi_mix_test_for_current_line) | |

## License

Copyright (c) 2015 [Masashi Iizuka](http://twitter.com/uochan)

Distributed under the MIT License.
