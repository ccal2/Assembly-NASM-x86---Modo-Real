org 0x7c00			; endereço de memória em que o programa será carregado		0x7c00 - Bootsector Area
jmp 0x0000:start	; far jump - seta cs para 0

buffer times 4 db 0	; separa 4 bytes na memória e os inicializa com o valor 0

start:
	; seta os "parâmetros"
	xor ax, ax	; zera ax		xor - mais rápido que mov
	mov ds, ax	; zera ds	(não pode ser zerado diretamente)
	mov es, ax	; zera es	(não pode ser zerado diretamente)

	mov di, buffer	; di aponta para o início de numero
	call readStr

	jmp done

readStr:
	mov ah, 00h	; lê teclado	retorno: al = tecla pressionada
	int 16h		; 16h - teclado

	cmp al, 0dh	; 0dh = carriage return (Enter)
	je .done	; se igual, vai para .done

	stosb		; al --> ES:DI		incrementa DI

	call printChar

	jmp readStr ; se não, vai para readStr novamente

	.done:
		mov al, 0	; 0 = \0
		stosb		; coloca o \0 na string

		call newLine; ~= \n

		ret

newLine:
	mov ah, 0eh	; imprime caracter de al
	mov al, 13 	; 13, 10 = \n
	int 10h
	
	mov al, 10 	;13, 10 = \n
	int 10h

; OU
	;mov ah, 03h ; pega a posição do cursor	retorno: (...)	dh = linha	dl = coluna
	;mov bh, 0	; número da página
	;int 10h

	;mov ah, 02h	; seta a posĩção do cursor
	;inc dh		; coloca o cursor na próxima linha
	;xor dl, dl	; coloca o cursor no inicio da linha
	;int 10h

	ret

printChar:	; sem modo video
	mov ah, 0eh	; imprime caracter armazenado em al
	mov bh, 0
	int 10h
	ret

done:
	jmp $		; $ = linha atual

times 510 - ($ - $$) db 0	; preenche o resto do setor com 0		$$ = 1ª linha do programa
dw 0xaa55		; assinatura de boot