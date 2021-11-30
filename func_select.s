.section .rodata

format_scan_chars:  .string    " %c"
example_Print:      .string    "first char: %c, second char: %c\n"

pstrlenPrint:       .string    "first pstring length: %d, second pstring length: %d\n"
replaceCharPrint:   .string    "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpyPrint:     .string    "length: %d, string: %s\n"
pstrijcmpPrint:     .string    "compare result: %d\n"
invalidPrint:       .string    "invalid option!\n"

.L10:
    .quad .L50 # case 50
    .quad .L51 # case 51 - default
    .quad .L52 # case 52
    .quad .L53 # case 53
    .quad .L54 # case 54
    .quad .L55 # case 55
    .quad .L51 # case 56 - default
    .quad .L51 # case 57 - default
    .quad .L51 # case 58 - default
    .quad .L51 # case 59 - default
    .quad .L50 # case 60

.text

    .globl	run_func
    .type	run_func, @function
run_func:
    pushq   %rbp
    movq    %rsp, %rbp
    leaq    -50(%rdi), %rcx
    cmpq    $10, %rcx
    ja      .L51
    jmp     *.L10(,%rcx,8)

.L50:
    movq    %rsi, %rdi
    movq    $0, %rax
    call    pstrlen
    movq    %rax, %rsi
    movq    %rdx, %rdi
    movq    $0, %rax
    call    pstrlen
    movq    %rax, %rdx

    movq    $pstrlenPrint, %rdi
    movq    $0, %rax
    call    printf

    jmp .L51

.L52:
    subq    $32, %rsp
    movq    %rsi, -8(%rbp)
    movq    %rdx, -16(%rbp)
    movq    $format_scan_chars, %rdi
    leaq    -24(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_chars, %rdi
    leaq    -32(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    -8(%rbp), %rdi  # pstring1 is in rdi
    movq    -24(%rbp), %rsi
    movq    -32(%rbp), %rdx
    movq    $0, %rax
    call    replaceChar
    movq    %rax, -8(%rbp)   # pstring1 after the change is in rbp-8
    movq    -16(%rbp), %rdi  # pstring2 is in rdi
    movq    -24(%rbp), %rsi
    movq    -32(%rbp), %rdx
    movq    $0, %rax
    call    replaceChar

    movq    $replaceCharPrint, %rdi
    movq    -8(%rbp), %rcx   # pstring1 after the change is in rcx
    movq    %rax, %r8   # pstring2 after the change is in r8
    movq    $0, %rax
    call    printf

    jmp     .L51

.L53:
    subq    $16, %rsp
    movq    $format_scan_chars, %rdi
    leaq    -8(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_chars, %rdi
    leaq    -16(%rbp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $example_Print, %rdi
    movq    -8(%rbp), %rsi
    movq    -16(%rbp), %rdx
    movq    $0, %rax
    call    printf
    jmp .L51

.L54:
    jmp .L51

.L55:
    jmp .L51

.L51:
    movq    %rbp, %rsp
    popq    %rbp
    movq    $0, %rax
    ret
