org 0x7c00			; endereço de memória em que o programa será carregado		0x7c00 - Bootsector Area
jmp 0x0000:start	; far jump - seta cs para 0

label times 10 db 0	; define 10 bytes na memória com o valor 0							EXEMPLO

string db 'oi', 13, 10, 0	; separa espaço na memória para armazenar a string 'oi'		EXEMPLO

start:
	; seta os "parâmetros"
	xor ax, ax	; zera ax		xor - mais rápido que mov
	mov ds, ax	; zera ds	(não pode ser zerado diretamente)
	mov es, ax	; zera es	(não pode ser zerado diretamente)

	; stack set up
	cli			; clear interrupts
	mov ss, ax	; zera ss	(não pode ser zerado diretamente)
	mov sp, 0x7c00	; indica o endereço de memória em que a pilha vai começar (ela cresce para baixo)
	sti			; set interrupts

	; ...

	jmp done

done:
	jmp $	; $ = linha atual

times 510 - ($ - $$) db 0	; preenche o resto do setor com 0		$$ = 1ª linha do programa
dw 0xaa55	; assinatura de boot