# 206344814 Yosef Perelman
.section .rodata

invalid_input:  .string "invalid input!\n"

.text

    .globl	pstrlen
    .type	pstrlen, @function
pstrlen:
    movl    (%rdi), %eax    # return the string length
    ret

    .globl  replaceChar
    .type   replaceChar, @function
replaceChar:
    movb    (%rdi), %cl     # move the length of the string to rdx
    and     $0xff, %rcx
    leaq    1(%rdi), %rax   # move to the start of the string to rax
    xorq    %r8, %r8        # r8 is counter

.L1:
    cmpq    %r8, %rcx       # check the loop condition, if (r8 = size of the string) finish the loop
    je      .L4
    cmpb    (%rax), %sil    # otherwise, compare the chars and if they aren't equal jump to .L3
    jne     .L3

.L2:
    movb    %dl, (%rax)     # if they equal - do the swap
    addq    $1, %rax        # go one char forward in the string
    addq    $1, %r8         # increase the counter by 1
    jmp     .L1             # go to the start of the loop

.L3:
    addq    $1, %rax        # go one char forward in the string
    addq    $1, %r8         # increase the counter by 1
    jmp     .L1             # go to the start of the loop

.L4:
    leaq    1(%rdi), %rax   # go back to the start of the string
    ret

    .globl  pstrijcpy
    .type   pstrijcpy, @function
pstrijcpy:
    push    %rbp
    movq    %rsp, %rbp
    subq    $8, %rsp
    movq    %rdi, -8(%rbp)

.VALIDATION_CHECK:
    # check if the indexes are bigger than the strings lengths
    movb    (%rdi), %r8b
    movb    (%rsi), %r9b
    and     $0xff, %r8
    and     $0xff, %r8
    dec     %r8
    dec     %r9
    cmpb    %r8b, %dl
    jg      .INVALID_INPUT
    cmpb    %r9b, %dl
    jg      .INVALID_INPUT
    cmpb    %r8b, %cl
    jg      .INVALID_INPUT
    cmpb    %r9b, %cl
    jg      .INVALID_INPUT

    and     $0xff, %rdx
    leaq    1(%rdi, %rdx), %rax   # go to the start of the pstring1
    leaq    1(%rsi, %rdx), %r9    # go to the start of the pstring2

.L5:
    cmpl    %ecx, %edx      # compare i and j (rdx = i and rcx = j)
    je      .L8             # if they equal jump to L8 (to change the last char and finish the function)
    movb    (%r9), %r8b     # if they not equal change the specific char
    movb    %r8b, (%rax)
    inc     %rax            # go one char forward in the first string
    inc     %r9             # go one char forward in the second string
    inc     %rdx            # i = i + 1
    jmp     .L5             # go to the start of the loop

.L8:
    movb    (%r9), %r8b     # change the char
    movb    %r8b, (%rax)
    leaq    1(%rdi), %rax   # go to the start of the string
    jmp     .L12            # go to the finish of the function

.INVALID_INPUT:
    movq    $invalid_input, %rdi
    movq    $0, %rax
    call    printf
    movq    -8(%rbp), %rax    # move to the start of the string
    addq    $1, %rax
    jmp     .L12

.L12:
    # end of function
    addq    $8, %rsp
    leave
    ret

    .globl  swapCase
    .type   swapCase, @function
swapCase:
    xorq    %rsi, %rsi
    movb    (%rdi), %sil    # length of the string in rsi
    leaq    (%rdi), %rax    # rax point to the string
    xorq    %rdx, %rdx      # rdx is counter

.L6:
    cmpl    %edx, %esi      # compare the index and the string length to check if the loop is over
    je      .L7             # if they equal jump to .L7 to the end of function
    inc     %rdx            # increase the counter by 1
    inc     %rax            # go one char forward in the string
    cmpb    $0x5a, (%rax)   # check if char <= Z
    jle     .UPPER_CASE
    cmpb    $0x61, (%rax)   # check if char >= a
    jge     .LOWER_CASE
    jmp     .L6             # go to the start of the loop

.UPPER_CASE:
    cmpb    $0x41, (%rax)   # check if char < A
    jl     .L6
    addb    $0x20, (%rax)   # change the char to lower case
    jmp     .L6             # go to the start of the loop

.LOWER_CASE:
    cmpb    $0x7a, (%rax)   # check if char > z
    jg     .L6
    subb    $0x20, (%rax)   # change the char to upper case
jmp     .L6                 # go to the start of the loop

.L7:
    leaq    1(%rdi), %rax    # go to the start of the string
    ret

    .globl  pstrijcmp
    .type   pstrijcmp, @function
pstrijcmp:

.CMP_VALIDATION_CHECK:
    # check if the indexes are bigger than the strings lengths
    movb    (%rdi), %r8b
    movb    (%rsi), %r9b
    and     $0xff, %r8
    and     $0xff, %r8
    dec     %r8
    dec     %r9
    cmpb    %r8b, %dl
    jg      .CMP_INVALID_INPUT
    cmpb    %r9b, %dl
    jg      .CMP_INVALID_INPUT
    cmpb    %r8b, %cl
    jg      .CMP_INVALID_INPUT
    cmpb    %r9b, %cl
    jg      .CMP_INVALID_INPUT

    leaq    1(%rdi, %rdx), %rax # the first string in rax
    leaq    1(%rsi, %rdx), %r10 # the second string in r10
    movl    %ecx, %r8d      # the length of the loop in r8 (j - i)
    subl    %edx, %r8d
    inc     %r8
    xor     %r9, %r9        # r9 is counter

.L9:
    # compare the counter and the loop length, if they equal it means we move through all
    # the substrings and they equal.
    cmpl    %r8d, %r9d
    je      .EQUAL
    # compare the chars and jump to the right place
    xorq    %rdi, %rdi
    xorq    %rsi, %rsi
    movb    (%rax), %dil
    movb    (%r10), %sil
    cmpb    %dil, %sil
    jg      .ONE_BIGGER
    jl      .TWO_BIGGER
    inc     %rax            # go one char forward in the first substring
    inc     %r10            # go one char forward in the second substring
    inc     %r9             # increase the counter by 1
    jmp     .L9             # go to the start of the loop

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
