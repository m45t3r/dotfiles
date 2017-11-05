""""""""""""""""""""
" install vim-plug "
""""""""""""""""""""
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"""""""""""
" plugins "
"""""""""""
call plug#begin()
" general
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'brooth/far.vim'
Plug 'dietsche/vim-lastplace'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'neomake/neomake'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'szw/vim-tags'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'justinmk/vim-dirvish'
" python
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'zchee/deoplete-jedi', { 'for': 'python' }
" ruby
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
" scss
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
call plug#end()

""""""""""""""""""""""""
" plugin configuration "
""""""""""""""""""""""""

" ack
let g:ackprg = 'ag --vimgrep'
" airline
let g:airline_powerline_fonts = 1
" deoplete
let g:deoplete#enable_at_startup = 1
" dirvish
let g:dirvish_mode = ':sort ,^.*[\/],'
" ctags
let g:vim_tags_auto_generate = 1
" far.vim
let g:far#source = 'agnvim'
" fzf
nnoremap <C-p> :Files<cr>
nnoremap <C-b> :Buffers<cr>
nnoremap <Leader>c :Commits<cr>
" gruvbox
set termguicolors
set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
" jedi
let g:jedi#smart_auto_mappings = 0
" Neomake
autocmd! BufWritePost * Neomake
let g:neomake_open_list = 2
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E115,E266,E501'], }
let g:neomake_python_pylint_maker = { 'args': ['--ignore=missing-docstring'], }
let g:neomake_ruby_enabled_makers = ['mri', 'rubocop']
" Undotree
nnoremap <F4> :UndotreeToggle<cr>
set undofile
set undodir=~/.config/nvim/undotree
let undotree_WindowLayout = 3
" vim-rspec
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>
let g:rspec_command = '!bundle exec rspec {spec}'
" vim-test
let test#strategy = 'neovim'
nnoremap <silent> <leader>t :TestNearest<CR>
nnoremap <silent> <leader>T :TestFile<CR>
nnoremap <silent> <leader>a :TestSuite<CR>
nnoremap <silent> <leader>l :TestLast<CR>
nnoremap <silent> <leader>g :TestVisit<CR>

""""""""
" misc "
""""""""
" automagically remove trailing spaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" enable/disable paste mode
set pastetoggle=<F6>
" show line number
set number
" copy and paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa
" show vertical column
set colorcolumn=81,121
" neovim terminal
nnoremap <silent> <leader><Space> :terminal<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
" easier window moviment
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
