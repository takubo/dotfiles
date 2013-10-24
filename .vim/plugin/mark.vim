"let g:DUM_ID = 1
"hi SignDummyHi					guibg=darkgrey
"sign define SignDummy	texthl=SignDummyHi	text=Å@
"exe "sign place " . g:DUM_ID . " line=1 name=SignDummy file=" . expand('%:p')

"hi mkhi	guifg=#dd2000	guibg=darkgrey
hi mkhi	guifg=#dd2000

sign define Mk_a	texthl=mkhi		text=a
sign define Mk_b	texthl=mkhi		text=b
sign define Mk_c	texthl=mkhi		text=c
sign define Mk_d	texthl=mkhi		text=d
sign define Mk_e	texthl=mkhi		text=e
sign define Mk_f	texthl=mkhi		text=f
sign define Mk_f	texthl=mkhi		text=f
sign define Mk_g	texthl=mkhi		text=g
sign define Mk_h	texthl=mkhi		text=h
sign define Mk_i	texthl=mkhi		text=i
sign define Mk_j	texthl=mkhi		text=j
sign define Mk_k	texthl=mkhi		text=k
sign define Mk_l	texthl=mkhi		text=l
sign define Mk_m	texthl=mkhi		text=m
sign define Mk_n	texthl=mkhi		text=n
sign define Mk_o	texthl=mkhi		text=o
sign define Mk_p	texthl=mkhi		text=p
sign define Mk_q	texthl=mkhi		text=q
sign define Mk_r	texthl=mkhi		text=r
sign define Mk_s	texthl=mkhi		text=s
sign define Mk_t	texthl=mkhi		text=t
sign define Mk_u	texthl=mkhi		text=u
sign define Mk_v	texthl=mkhi		text=v
sign define Mk_w	texthl=mkhi		text=w
sign define Mk_x	texthl=mkhi		text=x
sign define Mk_y	texthl=mkhi		text=y
sign define Mk_z	texthl=mkhi		text=z
sign define Mk_A	texthl=mkhi		text=A
sign define Mk_B	texthl=mkhi		text=B
sign define Mk_C	texthl=mkhi		text=C
sign define Mk_D	texthl=mkhi		text=D
sign define Mk_E	texthl=mkhi		text=E
sign define Mk_F	texthl=mkhi		text=F
sign define Mk_F	texthl=mkhi		text=F
sign define Mk_G	texthl=mkhi		text=G
sign define Mk_H	texthl=mkhi		text=H
sign define Mk_I	texthl=mkhi		text=I
sign define Mk_J	texthl=mkhi		text=J
sign define Mk_K	texthl=mkhi		text=K
sign define Mk_L	texthl=mkhi		text=L
sign define Mk_M	texthl=mkhi		text=M
sign define Mk_N	texthl=mkhi		text=N
sign define Mk_O	texthl=mkhi		text=O
sign define Mk_P	texthl=mkhi		text=P
sign define Mk_Q	texthl=mkhi		text=Q
sign define Mk_R	texthl=mkhi		text=R
sign define Mk_S	texthl=mkhi		text=S
sign define Mk_T	texthl=mkhi		text=T
sign define Mk_U	texthl=mkhi		text=U
sign define Mk_V	texthl=mkhi		text=V
sign define Mk_W	texthl=mkhi		text=W
sign define Mk_X	texthl=mkhi		text=X
sign define Mk_Y	texthl=mkhi		text=Y
sign define Mk_Z	texthl=mkhi		text=Z


function! s:SetMark()
  let l:key = getchar()
  let l:char = nr2char(l:key)
  if "a" <=? l:char && l:char <=? "z"
    exe "normal! m" . l:char
    exe "sign unplace " . l:key
    exe "sign place " . l:key . " line=" . line(".") . " name=Mk_" . l:char . " file=" . expand("%:p")
    "exe "sign place " . l:key . " line=" . line(".") . " name=Mk_" . l:char . " buffer=" . bufnr(0, 1)
  elseif l:key == "\<BS>"
    let l:key = getchar()
    let l:char = nr2char(l:key)
    if "a" <=? l:char && l:char <=? "z"
      try
	exe "normal! `" . l:char
	exe "delmarks " . l:char
	exe "sign unplace"
	exe "normal! \<C-o>"
      catch
      endtry
    endif
  endif
endfunction

function! s:DelMark()
  exe "sign unplace"
endfunction

nnoremap <silent> m :call <SID>SetMark()<CR>
"nnoremap <silent> m :keepjumps call <SID>SetMark()<CR>
"nnoremap <silent> <F5> :call <SID>DelMark()<CR>
