	name	e12ad
data	segment
dastr	db	'D/A','$'
adstr	db	'A/D',0dh,0ah,'$'
digs	db	'0123456789ABCDEF'
data	ends

stk	segment stack
	dw	100 dup(?)
stk	ends

code	segment
	assume	ds:data,es:data,ss:stk,cs:code

start:	mov	ax,stk
	mov	ss,ax
	mov	ax,data
	mov	ds,ax
	mov	es,ax

n	=	2 ;adjust the execution time of nop to adjust the delay time
portda	=	0280h ;the port num of dac0832
portad	=	0288h ;the port num of adc0809

delay	macro
	local	timer
	mov	cx,n
timer:	nop
	loop	timer
	endm

	mov	si,sp
	mov	ax,[si]
	push	ax

tabstt:	lea	dx,dastr
	mov	ah,09h
	int	21h
	mov	dl,09h ;horizontal tab
	mov	ah,02h
	int	21h
	lea	dx,adstr
	mov	ah,09h
	int	21h
	;print table header

	pop	ax
	mov	si,20
daadc:	mov	bl,al
	mov	dx,portda
	out	dx,al
	call	prthex
	mov	dl,09h
	mov	ah,02h
	int	21h
	;send a num to da and print it
	delay
	mov	dx,portad+1
	out	dx,al
	delay
	in	al,dx
	call	prthex
	mov	bh,al
	mov	ah,02h
	mov	dl,0dh
	int	21h
	mov	dl,0ah
	int	21h
	mov	ah,bh
	mov	al,bl
	aad
	dec	si
	jnz	daadc

	push	ax
wtin:	mov	ah,01h
	int	21h
	or	al,20h ;convert to lower case
	cmp	al,'c'
	je	tabstt
	cmp	al,'e'
	jne	wtin
	pop	ax
	mov	ah,4ch
	int	21h

prtnum	proc ;print a byte in decimal, ax(al) - the byte to print
	push	dx

	aam
	push	ax
	mov	al,ah ;get lowest digit
	aam
	push	ax ;get higher digits

	test	ah,ah
	je	pt10
	mov	dl,ah
	or	dl,30h
	mov	ah,02h
	int	21h
	;print the highest digit
pt10:	pop	ax
	test	al,al
	je	pt1
	mov	dl,al
	or	dl,30h
	mov	ah,02h
	int	21h
	;print the second highest digit
pt1:	pop	ax
	mov	dl,al
	or	dl,30h
	mov	ah,02h
	int	21h
	;print the lowest digit

	pop	dx
	ret
prtnum	endp

prthex	proc ;print a byte in hex, ax(al) - the byte to print
	push	dx
	push	bx
	push	cx

	lea	bx,digs

	mov	cl,al
	and	al,0fh
	xlat	digs
	push	ax
	;get lower digit

	mov	al,cl
	mov	cl,4
	shr	al,cl
	xlat	digs
	mov	dl,al
	mov	ah,02h
	int	21h
	;print higher digit
	pop	ax
	mov	dl,al
	mov	ah,02h
	int	21h
	;print lower digit

	pop	cx
	pop	bx
	pop	dx
	ret
prthex	endp

code	ends
	end	start
