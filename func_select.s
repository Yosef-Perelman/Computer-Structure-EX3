.section .rodata

format_scan_char:  .string    " %c"
format_scan_int:  .string    " %d"
example_Print:      .string    "first char: %c, second char: %c\n"
invalid_input:  .string "invalid input!\n"

pstrlenPrint:       .string    "first pstring length: %d, second pstring length: %d\n"
replaceCharPrint:   .string    "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpyPrint:     .string    "length: %d, string: %s\n"
pstrijcmpPrint:     .string    "compare result: %d\n"
invalidPrint:       .string    "invalid option!\n"

.L10:
    .quad .L50 # case 50
    .quad .L56 # case 51 - invalid input
    .quad .L52 # case 52
    .quad .L53 # case 53
    .quad .L54 # case 54
    .quad .L55 # case 55
    .quad .L56 # case 56 - invalid input
    .quad .L56 # case 57 - invalid input
    .quad .L56 # case 58 - invalid input
    .quad .L56 # case 59 - invalid input
    .quad .L50 # case 60

.text

    .globl	run_func
    .type	run_func, @function
run_func:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $50, %rdi
    cmpq    $10, %rdi
    ja      .L56
    jmp     *.L10(,%rdi,8)

.L50:
    subq    $16, %rsp
    movq    %rdx, -8(%rbp)  # save &pstring2
    movq    %rsi, %rdi  # move &pstring1 to rdi
    movq    $0, %rax
    call    pstrlen
    movq    %rax, -16(%rbp) # save pstring1 length
    movq    -8(%rbp), %rdi  # move &pstring2 to rdi
    movq    $0, %rax
    call    pstrlen

    movl    %eax, %edx  # move pstring2 to rdx
    and     $0xff, %rdx
    movq    $pstrlenPrint, %rdi
    movl    -16(%rbp), %esi # move pstring1 to rsi
    and     $0xff, %rsi
    movq    $0, %rax
    call    printf

    addq    $16, %rsp
    jmp     .L51

.L52:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    movq    $format_scan_char, %rdi
    leaq    -24(%rbp), %rsi
    movq    $0, %rax
    call    scanf   # get first char (aka "oldchar")
    movq    $format_scan_char, %rdi
    leaq    -32(%rbp), %rsi
    movq    $0, %rax
    call    scanf   # get second char (aka "newchar")
    movq    -8(%rbp), %rdi  # &pstring1 is in rdi
    movq    -24(%rbp), %rsi # old char in rsi
    movq    -32(%rbp), %rdx # new char in rdx
    movq    $0, %rax
    call    replaceChar
    movq    %rax, -8(%rbp)   # save pstring1 after the change
    movq    -16(%rbp), %rdi  # &pstring2 is in rdi
    movq    -24(%rbp), %rsi
    movq    -32(%rbp), %rdx
    movq    $0, %rax
    call    replaceChar

    movq    $replaceCharPrint, %rdi
    movq    -8(%rbp), %rcx   # pstring1 after the change is in rcx
    movq    %rax, %r8   # pstring2 after the change is in r8
    movq    $0, %rax
    call    printf

    addq    $32, %rsp
    jmp     .L51

.L53:
    subq    $64, %rsp
    movq    %rsi, -8(%rbp)  # save &pstring1
    movq    %rdx, -16(%rbp) # save &pstring2
    movb    (%rsi), %sil
    movb    %sil, -24(%rbp)    # save pstring1 length
    movb    (%rdx), %sil
    movb    %sil, -32(%rbp)    # save pstring2 length
    movq    $format_scan_int, %rdi
    leaq    -40(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_int, %rdi
    leaq    -48(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    -8(%rbp), %rdi  # pstring1 is in rdi
    movq    -16(%rbp), %rsi  # pstring2 is in rsi
    # maybe need 0xff
    movq    -40(%rbp), %rdx  # start index is in rdx
    movq    -48(%rbp), %rcx  # end index is in rcx
    movq    $0, %rax
    call    pstrijcpy

    movq    $pstrijcpyPrint, %rdi
    movl    -24(%rbp), %esi
    and     $0xff, %rsi
    movq    %rax, %rdx
    movq    $0, %rax
    call    printf
    movq    $pstrijcpyPrint, %rdi
    movl    -32(%rbp), %esi
    and     $0xff, %rsi
    movq    -16(%rbp), %r9
    leaq    1(%r9), %rdx
    movq    $0, %rax
    call    printf

    addq    $64, %rsp
    jmp .L51

.L54:
    subq    $16, %rsp
    movq    %rsi, -8(%rbp)
    movq    %rdx, -16(%rbp)
    movl    (%rsi), %r12d    # save the first pstring length
    movl    (%rdx), %r13d    # save the second pstring length

    movq    %rsi, %rdi
    movq    $0, %rax
    call    swapCase
    movq    $pstrijcpyPrint, %rdi
    movl    %r12d, %esi
    movq    %rax, %rdx
    movq    $0, %rax
    call    printf

    movq    -16(%rbp), %rdi
    movq    $0, %rax
    call    swapCase
    movq    $pstrijcpyPrint, %rdi
    movl    %r13d, %esi
    movq    %rax, %rdx
    movq    $0, %rax
    call    printf

    addq    $16, %rsp
    jmp .L51

.L55:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)
    movq    %rdx, -16(%rbp)
    movq    $format_scan_int, %rdi
    leaq    -24(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_int, %rdi
    leaq    -32(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    -8(%rbp), %rdi  # pstring1 is in rdi
    movq    -16(%rbp), %rsi  # pstring2 is in rsi
    movl    -24(%rbp), %edx  # start index is in rdx
    movl    -32(%rbp), %ecx  # end index is in rcx
    movq    $0, %rax
    call    pstrijcmp

    movq    $pstrijcmpPrint, %rdi
    movq    %rax, %rsi
    call    printf

    addq    $32, %rsp
    jmp .L51

.L56:
    movq    $invalid_input, %rdi
    movq    $0, %rax
    call    printf
    jmp     .L51
.L51:
    movq    %rbp, %rsp
    popq    %rbp
    movq    $0, %rax
    ret
