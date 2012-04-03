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

set history=1000

" Backspace-Tasten-Verhalten. 
" 2 heisst: loesche im Insertmodus linkes Zeichen ueber Zeilenende hinaus
set backspace=2

" Zeilennummerierung einschalten
set nu

" Zeige im Kommandomodus die ueblicherweise blind getippten Kommandos, z.B. 100G
set showcmd 

" Cursorposition an
set ruler

set nocompatible

" Tabulator-Schrittweite. Hier: 2 Zeichen
set tabstop=3

" Bei Zeilen-Links/Rechtsshift <<, >> Anzahl der Einrueckungen
set shiftwidth=3
set linebreak

autocmd BufNewFile,BufRead */meshing.pg2011/* setlocal tabstop=4 shiftwidth=4 softtabstop=4 smarttab expandtab
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
imap  !!date +"\%D \%T"kJi


" For HTML
"  — Wrap tags around the selection
function! VisualTagsWrap()
	if !exists('g:tags_to_wrap')
		let g:tags_to_wrap=[]
	endif
	let g:tags_to_wrap=split(input('space separated tags to wrap block: ', join(g:tags_to_wrap, ' ')), '\s\+')
	if len(g:tags_to_wrap)>0
		execute 'normal! `>a</'.join(reverse(g:tags_to_wrap), '></').'>'
		execute 'normal! `<i<'.join(reverse(g:tags_to_wrap), '><').'>'
	endif
endfunction

vnoremap <silent>,w <ESC>:call VisualTagsWrap()<CR>

set matchpairs+=<:>
set showmatch
set matchtime=3

inoreabbrev lorem Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.

inoreabbrev /*** /*******************************************************************************<CR><CR><BS>*****************************************************************************

" new mapping for vim-latex placeholder
"    imap <C-Down> <Plug>IMAP_JumpForward
" disable placeholder
let g:Imap_UsePlaceHolders=0
" set F9 to save compile and view the document
map <F9> :w<CR> <Plug>Tex_Compile <Plug>Tex_View <ESC>:!sleep 1<CR><CR>

nmap <silent>  ;t :TlistUpdate<CR>:TlistToggle<CR>
nmap <silent> ;;t :TlistUpdate<CR>

nmap <silent>  ;l :!pdflatex %<CR>
nmap <silent> ;;l :!pdflatex % && evince %:r.pdf<CR>

" Map paste mode to F2
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set mouse=a
