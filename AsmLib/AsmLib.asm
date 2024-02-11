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
.386
.MODEL FLAT, STDCALL

OPTION CASEMAP:NONE

.DATA

alpha dd 0
lastbyte1 dd 0
lastbyte2 dd 0
alpharemainder dd 0

byte1 dd 0
byte2 dd 0
newByte dd 0

.CODE

DllEntry PROC hInstDLL:DWORD, reason:DWORD, reserved1:DWORD

mov	eax, 1 	;TRUE
ret

DllEntry ENDP

; Name: BlendInAsm
; Parameters: 4 pointers and the alpha blending value (0-255).
; Pointing to first and last byte in each imageArray.
; No output parameters - all operations done on the first array pointers
; Registers: eax, ebx, ecx, edx\
; Flags: TODO
;

BlendInAsm proc firstByte1: byte , lastByte1: byte, firstByte2: byte, lastByte2: byte, ALPHA: byte
    
    ;load parameters to variables
    mov eax, dword ptr [lastByte1] 
    mov lastbyte1, eax
    mov eax, dword ptr [lastByte2] 
    mov lastbyte2, eax
    mov eax, dword ptr [firstByte1] 
    mov byte1, eax
    mov eax, dword ptr [firstByte2] 
    mov byte2, eax
    mov dl, ALPHA
    movzx edx, dl
    mov alpha, edx
    mov al, 255
    sub al, dl
    movzx eax, al
    mov alpharemainder, eax

    

Calculate:

    ;TODO: after the first array element value of [byte1] is always 0

    mov ecx, dword ptr [byte1] 
    mov al, [ecx]
    movzx eax, al ; load first image byte to eax
    mov ecx, alpharemainder 
    mul ecx ; multiply by remainder of alpha
    mov ebx , eax ; store first image byte to ebx

    mov ecx, dword ptr [byte2] 
    mov al, [ecx]
    movzx eax, al ; load second image byte to eax
    mov ecx, alpha
    mul ecx ; multiply by alpha
    add eax, ebx ; add byte1 to byte2
    mov ecx, 255 ; load 255 for diving
    div ecx ; get blended byte value
    mov newByte, eax


    mov ecx, dword ptr [byte1] 
    nop
    mov eax, newByte
    mov byte ptr [ecx], al ; save blended value to pointer of imageByteArray4[]

   
    jmp Check

Check: 
    mov eax, byte1
    mov ebx, lastbyte1
    cmp eax, ebx ; compare current byte and last byte in array
    JB Increment ; if less  increment pointers
    jmp Finished ; finish is last byte is reached and blended
   
    

Increment:
    mov ebx, byte1 ; load pointers of first     
    add ebx, 1 ; increment     
    mov byte1, ebx ; save to variables

    mov ebx, byte2 ; same for second image bytes
    add ebx, 1
    mov byte2, ebx

    jmp Calculate ; return to Calculating


    

Finished:
    ret

BlendInAsm endp

END DllEntry
;-------------------------------------------------------------------------
