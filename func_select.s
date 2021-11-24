.text

    .globl	run_func
    .type	run_func, @function
run_func:
    cmpq    $50, %rdi
    je      .L50

    cmpq    $52, %rdi
    je      .L52

    cmpq    $53, %rdi
    je      .L53

    cmpq    $54, %rdi
    je      .L54

    cmpq    $55, %rdi
    je      .L55

    cmpq    $60, %rdi
    je      .L50


.L50:
    movq    $0, %rax
    call    pstrlen

.L52:
    movq    $0, %rax
    call    replaceChar

.L53:
    movq    $0, %rax
    call    pstrijcpy

.L54:
    movq    $0, %rax
    call    swapCase

.L55:
    movq    $0, %rax
    call    pstrijcmp
