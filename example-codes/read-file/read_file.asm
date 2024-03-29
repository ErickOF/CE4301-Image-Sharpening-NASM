 
; Program to open and read from a file
; Compile with:
;     nasm -f elf64 -o readFromFile64.o readFromFile64.asm
; Link with:
;     ld -m elf_x86_64 -o readFromFile64 readFromFile64.o
; Run with:
;     ./readFromFile64
;==============================================================================
; Author : Rommel Samanez
;==============================================================================
global _start


%include 'functions.asm'

section .data
    fileName:       db   "original.txt", 0x0
    ; open file and read and write mode
    fileFlags:      dq   002o
    fileDescriptor: dq   0

section .bss
    ; Resolution: 2048x2048
    fileBuffer:     resq 4194304
    bufferSize:     equ  4194304

section .rodata
    msg1:           db   "Bytes readed=",0
    msg2:           db   "File Descriptor=",0

section .text
_start:
    mov     rax, 2                  ; SYS_OPEN
    mov     rdi, fileName           ; const char *filename
    mov     rsi, [fileFlags]        ; int flags
    syscall

    mov     [fileDescriptor], rax
    mov     rsi, msg2
    call    print

    mov     rax, [fileDescriptor]
    call    printnumber
    call    printnewline

    ; Read a message to the created file
    mov     rax, 0                  ; SYS_READ
    mov     rdi, [fileDescriptor]
    mov     rsi, fileBuffer
    mov     rdx, bufferSize         ; Bytes to read
    syscall

    ; Print the number of bytes Readed
    push    rax
    
    mov     rsi, msg1
    call    print
    
    pop     rax
    
    call    printnumber
    call    printnewline

    push    rax
    ; index = 0
    mov     rsi, 0x0

    ; Rows
    mov     ax, [fileBuffer + rsi]
    ror     ax, 8
    movzx   rax, ax

    call    printnumber
    call    printnewline

    add     rsi, 0x2                ; index += 2

    ; Cols
    mov     ax, [fileBuffer + rsi]
    ror     ax, 8
    movzx   rax, ax

    call    printnumber
    call    printnewline

    add     rsi, 0x2                ; index += 2

    ; img[0][0];
    mov byte al, [fileBuffer + rsi]
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     rsi                     ; index++;

    ; img[0][1];
    mov byte al, [fileBuffer + rsi]
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     rsi                     ; index++;

    ; img[0][2];
    mov byte al, [fileBuffer + rsi]
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     rsi                     ; index++;

    ; img[0][3];
    mov byte al, [fileBuffer + rsi]
    movzx   rax, al

    call    printnumber
    call    printnewline

    inc     rsi                     ; index++;

    pop     rax

    ; Close file Descriptor
    mov     rax, 3                  ; SYS_CLOSE
    mov     rdi, [fileDescriptor]
    syscall

    ; Print message Readed
    ;mov     rsi, fileBuffer
    ;call    println

    call    exit
