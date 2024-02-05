;-------------------------------------------------------------------------
;
;Author: Szymon Skalka
;
;This is the .asm main function
;
;-------------------------------------------------------------------------
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

.CODE

DllEntry PROC hInstDLL:DWORD, reason:DWORD, reserved1:DWORD

mov	eax, 1 	;TRUE
ret

DllEntry ENDP

;-------------------------------------------------------------------------
; This is an example function. It's here to show
; where to put your own functions in the DLL
;-------------------------------------------------------------------------

MyProc1 proc firstByte1: byte , lastByte1: byte, firstByte2: byte, lastByte2: byte, ALPHA: byte
    
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

    

Copy:
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


    mov ecx, dword ptr [byte1]
    mov [ecx], eax ; save blended value to pointer of imageByteArray4[]

   
    jmp Check

Check: 
    mov eax, byte1
    mov ebx, lastbyte1
    cmp eax, ebx ; compare current byte and last byte in array
    JB Increment ; if less  increment pointers
    jmp Finished ; finish is last byte is reached and blended
   
    

Increment:
    mov eax, byte1 ; load pointers of first 
    mov ebx, byte2 ; and second image bytes
    add eax, 1 ; increment 
    add ebx, 1
    mov byte1, eax ; save to variables
    mov byte2, ebx
    jmp Copy


    

Finished:
    ret

MyProc1 endp

END DllEntry
;-------------------------------------------------------------------------
