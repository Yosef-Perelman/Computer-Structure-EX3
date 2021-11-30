.text

    .globl	pstrlen
    .type	pstrlen, @function
pstrlen:
    movl    (%rdi), %eax
    ret

    .globl  replaceChar
    .type   replaceChar, @function
replaceChar:
    movl    (%rdi), %ecx    # ecx is len of the string
    leaq    4(%rdi), %rax    # move to the start of the string
    xorq    %r8, %r8  # r8 is counter = i

.L1:
    cmpq    %r8, %rcx # check the loop condition, if i = size of pstring finish the loop
    je      .L4
    cmpb    (%rax), %sil # compare the char with the old char, if true replace char
    jne      .L3

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
    leaq    4(%rdi), %rax    # move to the start of the string
    ret