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


byte1 dq 0 ; byte of the first array
byte2 dq 0 ; byte of the second array
lengthOfArray dq 0
index  dq 0
newByte dq 0 ; new byte thats going to replace the first array byte


alpha dq 0 ; blending proportion variable (0-255)
alpharemainder dq 0 ; remainder of the  blending proportion variable (255 - alpha)

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

    push rax
    push rbx
    push rcx
    push rdx
    push r9
    push r8
    
    

    mov byte1, rcx
    mov byte2, rdx
    mov lengthOfArray, r8
    pop r8
    mov alpha, r9 
    pop r9
    mov rdx, alpha
    movzx rdx, dl
    mov alpha, rdx
    mov al, 255
    sub al, dl
    movzx rax, al
    mov alpharemainder, rax  
    

    mov rax, lengthOfArray
    dec rax
    mov lengthOfArray, rax

    mov rax, 0
    mov index, rax

    jmp Calculate

Calculate:

    mov rcx, qword ptr [byte1] 
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
    mov rax, index
    mov rbx, lengthOfArray
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

    mov rbx, index ; same for second image bytes
    inc rbx
    mov index, rbx

    jmp Calculate ; return to Calculating




Finished:    
   
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret ; exit procedure

BlendInAsm endp
end
;-------------------------------------------------------------------------
