.section .rodata

invalid_input:  .string "invalid input!\n"

.text

    .globl	pstrlen
    .type	pstrlen, @function
pstrlen:
    movl    (%rdi), %eax
    ret

    .globl  replaceChar
    .type   replaceChar, @function
replaceChar:
    movb    (%rdi), %cl    # rcx is len of the string
    and     $0xff, %rcx
    leaq    1(%rdi), %rax    # move to the start of the string
    xorq    %r8, %r8  # r8 is counter = i

.L1:
    cmpq    %r8, %rcx # check the loop condition, if i = size of pstring finish the loop
    je      .L4
    cmpb    (%rax), %sil # compare the char with the old char, if true replace char
    jne     .L3

.L2:
    movb    %dl, (%rax)   # replace char with the new char
    addq    $1, %rax
    addq    $1, %r8
    jmp     .L1

.L3:
    addq    $1, %rax
    addq    $1, %r8
    jmp     .L1

.L4:
    leaq    1(%rdi), %rax    # move to the start of the string
    ret

    .globl  pstrijcpy
    .type   pstrijcpy, @function
pstrijcpy:
.VALIDATION_CHECK:
    cmpb    (%rdi), %dl
    jg      .INVALID_INPUT
    cmpb    (%rsi), %dl
    jg      .INVALID_INPUT
    cmpb    (%rdi), %cl
    jg      .INVALID_INPUT
    # cmpl    (%rsi), %ecx
    cmpb    (%rsi), %cl
    jg      .INVALID_INPUT

    and     $0xff, %rdx
    leaq    1(%rdi, %rdx), %rax    # move to the start of the pstring1
    leaq    1(%rsi, %rdx), %r9    # move to the start of the pstring2

.L5:
    cmpl    %ecx, %edx  # compare i and j
    je      .L8 # if they equal jump to L8
    movb    (%r9), %r8b # if they not equal change the specific char
    movb    %r8b, (%rax)
    inc     %rax
    inc     %r9
    inc     %rdx
    jmp     .L5

.L8:
    movb    (%r9), %r8b # if they not equal change the specific char
    movb    %r8b, (%rax)
    leaq    1(%rdi), %rax    # move to the start of the string
    ret

.INVALID_INPUT:
    movq    $invalid_input, %rdi
    movq    $0, %rax
    call    printf
    ret

    .globl  swapCase
    .type   swapCase, @function
swapCase:
    xorq    %rsi, %rsi
    movb    (%rdi), %sil
    leaq    (%rdi), %rax
    xorq    %rdx, %rdx

.L6:
    cmpl    %edx, %esi
    je      .L7
    inc     %rdx
    inc     %rax
    cmpb    $0x5a, (%rax)  # check if char <= Z
    jle     .UPPER_CASE
    cmpb    $0x61, (%rax)  # check if char >= a
    jge     .LOWER_CASE
    jmp     .L6

.UPPER_CASE:
    cmpb    $0x41, (%rax)
    jl     .L6
    addb    $0x20, (%rax)
    jmp     .L6

.LOWER_CASE:
    cmpb    $0x7b, (%rax)
    jg     .L6
    subb    $0x20, (%rax)
    jmp     .L6

.L7:
    leaq    1(%rdi), %rax    # move to the start of the string
    ret

    .globl  pstrijcmp
    .type   pstrijcmp, @function
pstrijcmp:
.CMP_VALIDATION_CHECK:
    cmpb    (%rdi), %dl
    jg      .CMP_INVALID_INPUT
    cmpb    (%rsi), %dl
    jg      .CMP_INVALID_INPUT
    cmpb    (%rdi), %cl
    jg      .CMP_INVALID_INPUT
    # cmpl    (%rsi), %ecx
    cmpb    (%rsi), %cl
    jg      .CMP_INVALID_INPUT

    leaq    1(%rdi, %rdx), %rax
    leaq    1(%rsi, %rdx), %r10
    movl    %ecx, %r8d
    subl    %edx, %r8d
    xor     %r9, %r9

.L9:
    cmpl    %r8d, %r9d
    jg      .EQUAL
    cmpb    (%rsi), %r10b
    jg      .ONE_BIGGER
    jl      .TWO_BIGGER
    inc     %rax
    inc     %r10
    inc     %r9
    jmp     .L9

.ONE_BIGGER:
    movq    $-1, %rax
    ret

.TWO_BIGGER:
    movq    $1, %rax
    ret

.EQUAL:
    movq    $0, %rax
    ret

.CMP_INVALID_INPUT:
    movq    $invalid_input, %rdi
    movq    $0, %rax
    call    printf
    movq    $-2, %rax
    ret
