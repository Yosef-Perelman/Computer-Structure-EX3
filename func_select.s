# 206344814 Yosef Perelman
.section .rodata

format_scan_char:  .string    " %c"
format_scan_int:  .string    " %d"

pstrlenPrint:       .string    "first pstring length: %d, second pstring length: %d\n"
replaceCharPrint:   .string    "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpyPrint:     .string    "length: %d, string: %s\n"
pstrijcmpPrint:     .string    "compare result: %d\n"
invalidPrint:       .string    "invalid option!\n"

.L10:
    .quad .L50 # case 50 - pstrlen
    .quad .L56 # case 51 - invalid input
    .quad .L52 # case 52 - replaceChar
    .quad .L53 # case 53 - pstrijcpy
    .quad .L54 # case 54 - swapCase
    .quad .L55 # case 55 - pstrijcmp
    .quad .L56 # case 56 - invalid input
    .quad .L56 # case 57 - invalid input
    .quad .L56 # case 58 - invalid input
    .quad .L56 # case 59 - invalid input
    .quad .L50 # case 60 - pstrlen

.text

    .globl	run_func
    .type	run_func, @function
run_func:
    pushq   %rbp
    movq    %rsp, %rbp

    # compare ((selected number - 50) <= 10). if the input is valid go to the jump table and jump to the right label.
    subq    $50, %rdi
    cmpq    $10, %rdi
    ja      .L56
    jmp     *.L10(,%rdi,8)


.L50:
    subq    $16, %rsp
    movq    %rdx, -8(%rbp)  # save &pstring2
    movq    %rsi, %rdi      # move &pstring1 to rdi
    movq    $0, %rax
    call    pstrlen
    movq    %rax, -16(%rbp) # save pstring1 length
    movq    -8(%rbp), %rdi  # move &pstring2 to rdi
    movq    $0, %rax
    call    pstrlen

    movl    %eax, %edx      # move pstring2 length to rdx
    and     $0xff, %rdx
    movq    $pstrlenPrint, %rdi
    movl    -16(%rbp), %esi # move pstring1 length to rsi
    and     $0xff, %rsi
    movq    $0, %rax
    call    printf

    addq    $16, %rsp
    jmp     .L51

.L52:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    # get the first char (a.k.a "old char") that need to replace
    movq    $format_scan_char, %rdi
    leaq    -24(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    # get the second char (a.k.a "new char")
    movq    $format_scan_char, %rdi
    leaq    -32(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    # do the swap on pstring1
    movq    -8(%rbp), %rdi  # &pstring1 is in rdi
    movq    -24(%rbp), %rsi # old char in rsi
    movq    -32(%rbp), %rdx # new char in rdx
    movq    $0, %rax
    call    replaceChar
    movq    %rax, -8(%rbp)  # save pstring1 after the swap
    # do the swap on pstring2
    movq    -16(%rbp), %rdi # &pstring2 is in rdi
    movq    -24(%rbp), %rsi # old char in rsi
    movq    -32(%rbp), %rdx # new char in rdx
    movq    $0, %rax
    call    replaceChar

    # print the result
    movq    $replaceCharPrint, %rdi
    movq    -24(%rbp), %rsi # old char in rsi
    movq    -32(%rbp), %rdx # new char in rdx
    movq    -8(%rbp), %rcx  # pstring1 after the change is in rcx
    movq    %rax, %r8       # pstring2 after the change is in r8
    movq    $0, %rax
    call    printf

    addq    $32, %rsp
    jmp     .L51

.L53:
    subq    $64, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    # save pstring1 length
    movb    (%rsi), %sil
    movb    %sil, -24(%rbp)
    # save pstring2 length
    movb    (%rdx), %sil
    movb    %sil, -32(%rbp)
    # get the start index
    movq    $format_scan_int, %rdi
    leaq    -40(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    # get the end index
    movq    $format_scan_int, %rdi
    leaq    -48(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    # do the copy
    movq    -8(%rbp), %rdi  # pstring1 is in rdi
    movq    -16(%rbp), %rsi # pstring2 is in rsi
    movq    -40(%rbp), %rdx # start index is in rdx
    movq    -48(%rbp), %rcx # end index is in rcx
    movq    $0, %rax
    call    pstrijcpy

    # print the result
    movq    $pstrijcpyPrint, %rdi
    movl    -24(%rbp), %esi # move pstring1 length to rsi
    and     $0xff, %rsi
    movq    %rax, %rdx      # &pstring1 is in rdx
    movq    $0, %rax
    call    printf
    movq    $pstrijcpyPrint, %rdi
    movl    -32(%rbp), %esi # move pstring2 length to rsi
    and     $0xff, %rsi
    movq    -16(%rbp), %r9
    leaq    1(%r9), %rdx     # &pstring2 is in rdx
    movq    $0, %rax
    call    printf

    addq    $64, %rsp
    jmp .L51

.L54:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    # save pstring1 length
    movb    (%rsi), %sil
    movb    %sil, -24(%rbp)
    # save pstring2 length
    movb    (%rdx), %sil
    movb    %sil, -32(%rbp)

    # do the swap on pstring1 and print it
    movq    -8(%rbp), %rdi
    movq    $0, %rax
    call    swapCase
    movq    $pstrijcpyPrint, %rdi
    movl    -24(%rbp), %esi
    and     $0xff, %rsi
    movq    %rax, %rdx
    movq    $0, %rax
    call    printf

    # do the swap on pstring2 and print it
    movq    -16(%rbp), %rdi
    movq    $0, %rax
    call    swapCase
    movq    $pstrijcpyPrint, %rdi
    movl    -32(%rbp), %esi
    and     $0xff, %rsi
    movq    %rax, %rdx
    movq    $0, %rax
    call    printf

    addq    $32, %rsp
    jmp .L51

.L55:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    # get the start index
    movq    $format_scan_int, %rdi
    leaq    -24(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    # get the end index
    movq    $format_scan_int, %rdi
    leaq    -32(%rbp), %rsi
    movq    $0, %rax
    call    scanf

    # compare the substrings
    movq    -8(%rbp), %rdi  # pstring1 is in rdi
    movq    -16(%rbp), %rsi # pstring2 is in rsi
    movl    -24(%rbp), %edx # start index is in rdx
    movl    -32(%rbp), %ecx # end index is in rcx
    movq    $0, %rax
    call    pstrijcmp
    # print the result
    movq    $pstrijcmpPrint, %rdi
    movq    %rax, %rsi
    call    printf

    addq    $32, %rsp
    jmp .L51

# invalid input case
.L56:
    movq    $invalidPrint, %rdi
    movq    $0, %rax
    call    printf
    jmp     .L51

# finish of the run_func function
.L51:
    movq    %rbp, %rsp
    popq    %rbp
    movq    $0, %rax
    ret
