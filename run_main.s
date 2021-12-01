.section .rodata
  format_scan_int:  .string    " %d"
  format_scan_string:  .string    " %s"

.text

    .globl  run_main
    .type   run_main, @function
run_main:
    push    %rbp
    movq    %rsp, %rbp
    subq    $528, %rsp

    movq    $format_scan_int, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_string, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movl    (%rsp), %edi
    and     $0xff, %rdi
    leaq    257(%rsp, %rdi), %rax
    movb    $10, (%rax)

    movq    $format_scan_int, %rdi
    leaq    256(%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movq    $format_scan_string, %rdi
    leaq    257(%rsp), %rsi
    movq    $0, %rax
    call    scanf
    movl    (%rsp), %edi
    and     $0xff, %rdi
    leaq    1(%rsp, %rdi), %rax
    movb    $10, (%rax)

    movq    $format_scan_int, %rdi
    leaq    528(%rsp), %rsi
    movq    $0, %rax
    call    scanf

    movl    528(%rsp), %edi # move the number choice to rdi
    leaq    (%rsp), %rsi
    leaq    256(%rsp), %rdx
    movq    $0, %rax
    call    run_func

    addq    $528, %rsp
    movq    %rbp, %rsp
    popq    %rbp
    ret