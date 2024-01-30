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
    

    mov eax, dword ptr [lastByte1] 
    mov lastbyte1, eax

    mov eax, dword ptr [lastByte2] 
    mov lastbyte2, eax

    mov dl, ALPHA
    movzx edx, dl
    mov alpha, edx

    mov al, 255
    sub al, dl
    movzx eax, al
    mov alpharemainder, eax


    mov ecx, dword ptr [firstByte1] 
    mov al, [ecx]
    movzx eax, al


     mov ecx, dword ptr [firstByte2] 
    mov bl, [ecx]
    movzx ebx, bl


  
  

       
       ret
MyProc1 endp

END DllEntry
;-------------------------------------------------------------------------
