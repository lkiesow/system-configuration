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

" Strg+D (I-Mode): Datum einfügen
"imap  !!date +"\%D \%T"kJi
nmap <silent> ;d o!!date '+\%Y-\%m-\%d \%H:\%M:\%S'kJ
nmap <silent> ;;d o!!date +\%y\%m\%dkJ
nmap <silent> ;;;d Do!!date +\%y\%m\%dkJ

set matchpairs+=<:>
set showmatch
set matchtime=3

inoreabbrev lorem Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.

inoreabbrev /*** /*******************************************************************************<CR><CR><BS>*****************************************************************************

function LigaturesSet()
	%s/IJ/Ĳ/gce
	%s/ij/ĳ/gce
	%s/ffi/ﬃ/gce
	%s/ffl/ﬄ/gce
	%s/ff/ﬀ/gce
	%s/fi/ﬁ/gce
	%s/fl/ﬂ/gce
	%s/ſt/ﬅ/gce
"	%s/st/ﬆ/gce
endfunction

function LigaturesSetHTML()
	call LigaturesSet()
	%s/Ĳ/\&#306;/ge
	%s/ĳ/\&#307;/ge
	%s/ﬃ/\&#64259;/ge
	%s/ﬄ/\&#64260;/ge
	%s/ﬀ/\&#64256;/ge
	%s/ﬁ/\&#64257;/ge
	%s/ﬂ/\&#64258;/ge
	%s/ﬅ/\&#64261;/ge
"	%s/ﬆ/\&#64262;/ge
endfunction

function LigaturesFromHTML()
	%s/&#306;/Ĳ/ge
	%s/&#307;/ĳ/ge
	%s/&#64259;/ﬃ/ge
	%s/&#64260;/ﬄ/ge
	%s/&#64256;/ﬀ/ge
	%s/&#64257;/ﬁ/ge
	%s/&#64258;/ﬂ/ge
	%s/&#64261;/ﬅ/ge
"	%s/&#64262;/ﬆ/ge
endfunction

" new mapping for vim-latex placeholder
"    imap <C-Down> <Plug>IMAP_JumpForward
" disable placeholder
let g:Imap_UsePlaceHolders=0
" set F9 to save compile and view the document
map <F9> :w<CR> <Plug>Tex_Compile <Plug>Tex_View <ESC>:!sleep 1<CR><CR>

nmap <silent>  ;t :TlistUpdate<CR>:TlistToggle<CR>
nmap <silent> ;;t :TlistUpdate<CR>

" TeX specific stuff
function! TexProject()
	let firstline = getline(1)
	let filepath  = expand('%:h')
	if firstline =~ "^%texproject: *..*"
		return substitute(firstline, "^%texproject: *", filepath.'/', 1)
	endif
	return expand('%')
endfunction
"nmap <silent>  ;l :!pdflatex "%"<CR>
"nmap <silent> ;;l :!pdflatex "%" && evince "%:r.pdf"<CR>
nmap <silent>  ;l :exec '!pdflatex "'.TexProject().'"'<CR>
nmap <silent> ;;l :exec '!pdflatex "'.TexProject().'" && evince "'.substitute(TexProject(),"\.tex$",".pdf",1).'"'<CR>
nmap <silent>  ;x :!xelatex %<CR>
nmap <silent> ;;x :!xelatex % && evince %:r.pdf<CR>

" Map paste mode to F2
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" toggle spell checker by <F3>
nnoremap <F3> :set spell! spell?<CR>

" toggle syntax highlighting with <F4>

set mouse=a
