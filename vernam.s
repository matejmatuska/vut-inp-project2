; Vernamova sifra na architekture DLX
; Matej Matuška xmatus36

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xmatus36"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)
        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

; r2-r15-r17-r22-r30-r0
; r2 current char
; r17 login index
; r22 key index (bool)

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	addi r17, r0, 0
	addi r22, r0, 0
loop:
	lb r2, login+0(r17) ; load login[r17]
	
	slti r15, r2, 97 ; r15 = (login[r17] < 97)
	bnez r15, on_number ; if r15 jump on_number
	nop
	nop

	; we have a letter
	bnez r22, else ; if r22 != 0 jump else
	nop
	nop

	addi r2, r2, 13 ; FIRST LETTER OF KEY
	sgti r15, r2, 122
	beqz r15, endif
	nop
	nop
	; the letter "overflew"
	subi r30, r2, 122 ; r30 = diff
	addi r2, r30, 96

	j endif
	nop
	nop
else:
	subi r2, r2, 1 ; SECOND LETTER OF KEY
	slti r15, r2, 97
	beqz r15, endif
	nop
	nop
	; the letter "overflew"
	addi r30, r0, 97
	sub r30, r30, r2 ; r30 = diff
	addi r15, r0, 123
	sub r2, r15, r30
endif:
	sb cipher+0(r17), r2 ; store cipher[r17]
	
	addi r17, r17, 1
	seqi r22, r22 , 0 ; flip the key letter bit
	j loop
	nop
	nop
	
on_number:
	sb cipher+0(r17), r0 ; write termination char (NULL byte)

end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
