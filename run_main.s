# 206344814 Yosef Perelman
.section .rodata
  format_scan_int:  .string    " %d"
  format_scan_string:  .string    " %s"

.text

    .globl  run_main
    .type   run_main, @function
run_main:
    push    %rbp
    movq    %rsp, %rbp
    subq    $528, %rsp  # allocate memory for the pstrings

    # get the first pstring and his length
    movq    $format_scan_int, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_string, %rdi
    leaq    1(%rsp), %rsi   # leave to the length only one byte because it represented as char
    movq    $0, %rax
    call    scanf
    # movl    (%rsp), %edi
    # and     $0xff, %rdi

    # get the second pstring and his length
    movq    $format_scan_int, %rdi
    leaq    256(%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_string, %rdi
    leaq    257(%rsp), %rsi # leave to the length only one byte because it represented as char
    movq    $0, %rax
    call    scanf
    # movl    (%rsp), %edi
    # and     $0xff, %rdi

    # get the option select
    movq    $format_scan_int, %rdi
    leaq    525(%rsp), %rsi
    movq    $0, %rax
    call    scanf

    movl    525(%rsp), %edi # move the selected option to rdi
    leaq    (%rsp), %rsi    # move &pstring1 to rsi
    leaq    256(%rsp), %rdx # move &pstring2 to rdx
    movq    $0, %rax
    call    run_func    # call run_func

    addq    $528, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret