; -------------------------------------------------------------------------
;
; Autor: Szymon Skalka
; Temat: Program laczacy dwa pliki graficzne.
; Opis: Program mnozy wartosci bajtowe dwoch obrazow przez zmienna i oblicza wartosc polaczona 
; Data: 11.02.2024 Semestr 5 Rok II Skalka Szymon
; Wersja 1.0
;
; This is the ASM exported function
;
; -------------------------------------------------------------------------

.DATA

alpha dq 0
lastbyte1 dq 0
lastbyte2 dq 0
alpharemainder dq 0

byte1 dq 0
byte2 dq 0
newByte dq 0

.CODE


; Name: BlendInAsm
; Parameters: 4 pointers and the alpha blending value (0-255).
; Pointing to first and last byte in each imageArray.
; No output parameters - all operations done on the first array pointers
; Registers: rax, rbx, rcx, rdx\
; Flags: TODO
;

BlendInAsm proc 
    
    ;load parameters to variables
    mov rax, rcx
    mov byte1, rax
    mov rax, rdx
    mov lastbyte1, rax
    mov rax, r8
    mov byte2, rax
    mov rax, r9
    mov lastbyte2, rax   
    mov rdx, qword ptr[rbp + 48]
    movzx rdx, dl
    mov alpha, rdx
    mov al, 255
    sub al, dl
    movzx rax, al
    mov alpharemainder, rax

    

Calculate:

    mov rcx, qword ptr [byte1] 
    mov al, [rcx]
    mov al, [rcx]
    movzx rax, al ; load first image byte to rax
    mov rcx, alpharemainder 
    mul rcx ; multiply by remainder of alpha
    mov rbx , rax ; store first image byte to rbx

    mov rcx, qword ptr [byte2] 
    mov al, [rcx]
    movzx rax, al ; load second image byte to rax
    mov rcx, alpha
    mul rcx ; multiply by alpha
    add rax, rbx ; add byte1 to byte2
    mov rcx, 255 ; load 255 for diving
    div rcx ; get blended byte value
    mov newByte, rax


    mov rcx, qword ptr [byte1] 
    mov rax, newByte
    mov byte ptr [rcx], al ; save blended value to pointer of imageByteArray4[]

   
    jmp Check
    
Check: 
    mov rax, byte1
    mov rbx, lastbyte1
    cmp rax, rbx ; compare current byte and last byte in array
    JB Increment ; if less  increment pointers
    jmp Finished ; finish if last byte is reached and blended
   
    

Increment:
    mov rbx, byte1 ; load pointers of first     
    inc rbx ; increment     
    mov byte1, rbx ; save to variables

    mov rbx, byte2 ; same for second image bytes
    inc rbx
    mov byte2, rbx

    jmp Calculate ; return to Calculating


    

Finished:
    ret

BlendInAsm endp
end
;-------------------------------------------------------------------------
