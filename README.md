# vivi.vim

Support to setup Elixir development environment in Vim.

## Requirements

* [vim-elixir](https://github.com/elixir-lang/vim-elixir)
* [vim-quickrun](https://github.com/thinca/vim-quickrun)
* [vim-watchdogs](https://github.com/osyo-manga/vim-watchdogs)

## Installation

 * neobundle
```
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'liquidz/vivi.vim'
```

## Configuration

* Change mix test outputter
```
let g:vivi_mix_test_outputter = 'quickfix'
```
* Enable default key mappings
```
let g:vivi_enable_default_key_mappings = 1
```

## Default key mappings

| mode   | lhs   | rhs | notes |
| ------ | ----- | --- | ----- |
| insert | ">>"  | "|>" | Pipeline |
| normal | \<Leader\>t  | \<Plug\>(mix_test) | Call `mix test` |

## License

Copyright (c) 2015 [Masashi Iizuka](http://twitter.com/uochan)

Distributed under the MIT License.
