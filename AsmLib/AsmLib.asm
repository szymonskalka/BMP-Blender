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

; Function arguments
; Function start
       push ebp
       mov ebp, esp

       ;movsx eax, [firstByte1]

; Function end
        ret
MyProc1 endp

END DllEntry
;-------------------------------------------------------------------------
