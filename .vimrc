" Settings
" --------

" Unicode
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" Autoindent (Einrueckung wie Zeile davor)
set autoindent
filetype on
filetype indent on
filetype detect

set history=10000
set nu  " enable line numbers
set showcmd  " show all commands

" Cursorposition an
set ruler

set nocompatible

" Tabulator-Schrittweite. Hier: 2 Zeichen
set tabstop=3
set shiftwidth=3
set softtabstop=3

" break at word boundaries rather that in words
set linebreak
" break after 80 characters while typing

autocmd BufNewFile,BufRead */las-vegas-reconstruction/* setlocal tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab

" Besserer Bildschirmaufbau :
set redraw

" Zeigt den Arbeitsmodus :
set showmode

" Strg+Y (K-Mode, I-Mode): Error-Fenster öffnen
map   :copen 3
imap  :copen 3

" Strg+X (K-Mode, I-Mode): Error-Fenster schließen
map   :ccl
imap  :ccli

set matchpairs+=<:>
set showmatch
set matchtime=3

command -nargs=1 Lorem r !curl -s 'http://loripsum.net/generate.php?p=<args>&l=long' | sed 's/<[^>]*> *//g'

if match($TERM, "screen")!=-1
	set term=xterm
	map OC <Right>
	map OD <Left>
	map [1;5C <S-Right>
	map [1;5D <S-Left>
endif

nmap <silent>  ;t :TlistUpdate<CR>:TlistToggle<CR>
nmap <silent> ;;t :TlistUpdate<CR>

" This is for RPM specfiles
if &ft == "spec" 
	nmap <silent>  ;l :r !echo "* $(date +'\%a \%b \%e \%Y') Lars Kiesow <lkiesow@uos.de> - $(sed -n 's/Version:[ \t]*//p' %)-$(sed -n 's/^Release:[ \t]*\(.*\)\%.*/\1/p' %)"o<ESC>O- 


" TeX specific stuff
endif


" This for LaTeX files
function! TexProject()
	let firstline = getline(1)
	let filepath  = expand('%:h')
	if firstline =~ "^%texproject: *..*"
		return substitute(firstline, "^%texproject: *", filepath.'/', 1)
	endif
	return expand('%')
endfunction

if &ft == "tex" || &ft == "plaintex"

	nmap <silent>  ;l :exec '!pdflatex "'.TexProject().'"'<CR>
	nmap <silent> ;;l :exec '!pdflatex "'.TexProject().'" && evince "'.substitute(TexProject(),"\.tex$",".pdf",1).'"'<CR>

endif 

" HTML to Android-Book (LaTeX) conversion
function! Abc()
	%s/<p>/\\Newpage/ge
	%s/<\/p>//ge
	%s/<em>/\\textit{/ge
	%s/<\/em>/}/ge
	%s/<hr[^>]*>/\\hrulefill/ge
	%s/ //ge
	%s/%/\\%/gce
endfunction

" Map paste mode to F2
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" toggle spell checker by <F3>
nnoremap <F3> :set spell! spell?<CR>

" toggle syntax highlighting with <F4>

set mouse=a
