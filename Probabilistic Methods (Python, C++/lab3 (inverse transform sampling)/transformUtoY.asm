.686
.model flat

public _transformUtoY

.data
; transformUtoY(y) = 100 * y + 50;

.code
_transformUtoY PROC
	push ebp
    mov ebp, esp
    sub esp, 8
    mov dword ptr [ebp - 4], 50
    mov dword ptr [ebp - 8], 100

    finit
    fild dword ptr [ebp - 4]
    fild dword ptr [ebp - 8]
    fld qword ptr [ebp + 8]
    fmul
    fadd

    mov esp, ebp
    pop ebp
    ret
_transformUtoY ENDP
END