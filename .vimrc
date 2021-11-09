""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible  " I do not care about Vi compatibility
set history=10000 " Increase history size
set nu            " Enable line numbers by default
set showcmd       " Display commands on last screen line
set ruler         " Show line and column number of cursor position
set linebreak     " break at word boundaries rather that in words
set showmode      " Show a message about the current mode
set mouse=a       " Enable Mouse
set backspace=indent,eol,start,nostop
                  " Backspace to delete newline
set hlsearch      " Highlight search results


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set term=xterm-256color " | Vim may always use 256 colors as all modern
set t_Co=256            " | terminals should support this. But it may be
                        " | falsely detected because of screen or tmux.

set background=dark

highlight Pmenu ctermbg=234 ctermfg=220
highlight PmenuSel ctermfg=11 ctermbg=0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set enc=utf-8          " | Set default to Unicode
set fenc=utf-8         " |
set termencoding=utf-8 " |


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent     " | Autoindent according to file type
filetype on        " |
filetype indent on " |
filetype detect    " |

set tabstop=3      " Set the width of a tab to three spaces
set shiftwidth=3   " Set the width of a shift (< and > keys) to one tab

highlight ForbiddenWhitespace ctermbg=red  " Highlight trailing whitespace
match ForbiddenWhitespace /\s\+$/
" Do not highlight spaces at the end of line while typing on that line.
" autocmd InsertEnter * match ForbiddenWhitespace /\s\+\%#\@<!$/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Project Specific Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! Indent(tabsize, textwidth)
	execute "setlocal tabstop=".a:tabsize
	execute 'setlocal shiftwidth='.a:tabsize
	execute 'setlocal softtabstop='.a:tabsize
	execute 'setlocal textwidth='.a:textwidth
	execute 'setlocal colorcolumn='.(a:textwidth + 1)
	execute 'setlocal smarttab'
	execute 'setlocal expandtab'
endfunction

" Enable modelines to specify per file settings at the top of a given file
" Example:
"   vim: et:ts=4:sw=4:sts=4
set modeline

autocmd BufNewFile,BufRead *.py   :call Indent(4, 79)
autocmd BufNewFile,BufRead *.tsx  :call Indent(2, 80)
autocmd BufNewFile,BufRead *.scad :call Indent(4, 80)

" Opencast wants two spaces for each tab and a textwidth of 120 columns
"autocmd BufNewFile,BufRead */*opencast*/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 smarttab expandtab textwidth=120 colorcolumn=121
autocmd BufNewFile,BufRead */opencast/* :call Indent(2, 120)

" Use four spaces for each tab
autocmd BufNewFile,BufRead */pyCA/* setlocal tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab textwidth=78


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Safe settings for gopass
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufNewFile,BufRead */gopass/* setlocal noswapfile nobackup noundofile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bracket Matching
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set matchpairs+=<:>
set showmatch
set matchtime=3


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Lorem Ipsum
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command -nargs=1 Lorem r !curl -L -s 'http://loripsum.net/generate.php?p=<args>&l=long' | sed 's/<[^>]*> *//g'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TagList Support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map ;t to open/close the TagList
nmap <silent>  ;t :TlistUpdate<CR>:TlistToggle<CR>

" Map ;;t to update the TagList
nmap <silent> ;;t :TlistUpdate<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RPM Build Related Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Format to use for RPM Spec changelog (generated with \c)
let g:spec_chglog_format = '%a %b %d %Y Lars Kiesow <lkiesow@uos.de>'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LaTeX Related Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""
" Search for a TeX project specification in the first line of the current
" file. If a project file is specified then return the main project file,
" otherwise return the current file. This can be used for running TeX on the
" from an included TeX file.
" A project specification looks like this:
"   %texproject: ../master-thesis.tex
"""
function! TexProject()
	let firstline = getline(1)
	let filepath  = expand('%:h')
	if firstline =~ "^%texproject: *..*"
		return substitute(firstline, "^%texproject: *", filepath.'/', 1)
	endif
	return expand('%')
endfunction


if &ft == "tex" || &ft == "plaintex"

	" Map ;l to the execution of pdflatex on the current TeX project
	nmap <silent>  ;l :exec '!pdflatex -shell-escape "'.TexProject().'"'<CR>

	" Map ;;l to the execution of pdflatex and open the resulting pdf.
	nmap <silent> ;;l :exec '!pdflatex -shell-escape "'.TexProject().'" && xdg-open "'.substitute(TexProject(),"\.tex$",".pdf",1).'" &> /dev/null'<CR>

	" Build environment construct based on the word under the cursor
	nmap <silent> ;;e b"zdei\begin{}<ESC>"zPo\end{}<ESC>"zPO<TAB>

	" Format (wrap) inner paragraph
	nmap <silent> ;;f vipgw

	" LaTeX support for taglist
	let tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'
	let tlist_make_settings  = 'make;m:makros;t:targets'

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HTML to Android-Book (LaTeX) conversion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This is useful for the preparation of HTML files (especially HPMOR) for
" typesetting ebooks for Android devices using LaTeX and the androidbook
" class.
function! Abc()
	%s/<p[^>]*>/\\Newpage/ge
	%s/<\/p>//ge
	%s/<em>/\\textit{/ge
	%s/<\/em>/}/ge
	%s/<hr[^>]*>/\\hrulefill/ge
	%s/ //ge
	%s/%/\\%/gce
	%s/<br[^>]*>/ \\\\/g
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Paste Mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map paste mode to F2
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlight by default
syntax on
let g:syntax = 1

" Toggle syntax highlighting with <F4>
map <F4> :call ToggleSyntax()<cr>
function! ToggleSyntax()
	try
		if g:syntax_on
			syntax off
		endif
	catch /.*/
		syntax on
	endtry
endfunction

" Make sure that files with .md file extension are interpreted as markdown not
" as modula2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown background=dark


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spelling
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle spell checker by <F3>
nnoremap <F3> :set spell! spell?<CR>

" Specify colors for spell checking
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=202 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline ctermfg=202
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" Tell vim where to get dictionaries
let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Special settings for vimdiff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" The diff highlighting often clashes with the dark background and the syntax
" highlighting. Setting the dark background theme helps. Disabling syntax
" highlighting helps more.
if &diff
	set background=dark
	syn off
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Special configuration from git repository root
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("gitcfgloaded") == 0
	let gitrootcmd = "echo -n $(git rev-parse --show-toplevel)"
	let gitpath = system("cd $(dirname " . bufname("%") . "); " . gitrootcmd)
	if v:shell_error == 0
		if filereadable(gitpath . "/.vimrc")
			let gitcfgloaded = 1
			exec "source " . gitpath . "/.vimrc"
		endif
	endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Management
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime bundle/vim-pathogen/pathogen.vim
execute pathogen#infect()
