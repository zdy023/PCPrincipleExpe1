	name	e11da
data	segment
sawval	db	0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,190,195,200,205,210,215,220,225,230,235,240,245,250,0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,190,195,200,205,210,215,220,225,230,235,240,245,250
trival	db	0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,190,195,200,205,210,215,220,225,230,235,240,245,250,255,250,245,240,235,230,225,220,215,210,205,200,195,190,185,180,175,170,165,160,155,150,145,140,135,130,125,120,115,110,105,100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10,5
sinval	db	0,0,1,2,4,6,9,12,15,19,23,28,33,39,45,51,57,64,71,78,85,93,100,108,116,124,131,139,147,155,162,170,177,184,191,198,204,210,216,222,227,232,236,240,243,246,249,251,253,254,255,255,255,254,253,251,249,246,243,240,236,232,227,222,216,210,204,198,191,184,177,170,162,155,147,139,131,124,116,108,100,93,85,78,71,64,57,51,45,39,33,28,23,19,15,12,9,6,4,2,1,0
data	ends

stk	segment stack
	dw	100 dup(?)
stk	ends

code	segment
	assume	ds:data,es:data,ss:stk,cs:code

start:	mov	ax,data
	mov	ds,ax
	mov	es,ax
	mov	ax,stk
	mov	ss,ax

n	=	5 ;adjust the execution time of nop to adjust the delay time
port	=	0280h ;the port num of dac0832
step	=	5 ;time step
stepnum	=	102 ;stepnum = 2*255/step

delay	macro
	local	timer
	mov	cx,n
timer:	nop
	loop	timer
	endm

chkkbd	macro	label
	local	cmp32,cmp33,cmp34
	mov	ah,01h
	int	21h
	cmp	al,31h
	jnz	cmp32
	lea	si,sawval
	add	si,bx
	jmp	label
cmp32:	cmp	al,32h
	jnz	cmp33
	lea	si,trival
	add	si,bx
	jmp	label
cmp33:	cmp	al,33h
	jnz	cmp34
	lea	si,sinval
	add	si,bx
	jmp	label
cmp34:	cmp	al,34h
	je	eop
	endm

	mov	dx,port
	xor	bx,bx ;use bx to store the index (0-stepnum)
ickkbd:	chkkbd	gnwv
	jmp	ickkbd

gnwv:	lodsb
	out	dx,al
	inc	bx
	cmp	bx,stepnum
	jne	nxvlt
	sub	si,bx
	xor	bx,bx
	mov	ah,0bh
	int	21h
	test	al,al
	je	dlbnx
nxvlt:	chkkbd	dlbnx
dlbnx:	delay
	jmp	gnwv

eop:	mov	ah,4ch
	int	21h

code	ends
	end	start
