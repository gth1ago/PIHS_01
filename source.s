.section .data
    opcao:      .int    0
    nA:         .int    0
    nB:         .int    0
    temVetor:   .int    0
    num:        .int    0

    vetorA:     .space  4
    vetorB:     .space  4

    pInicio:    .asciz  "\n\tManipulador de Conjuntos Numericos\n"
    pMenu:      .asciz  "\n\t\t  MENU\n\t[1] Leitura dos Conjuntos\n\t[2] Encontrar Uniao\n\t[3] Encontrar Inserccao\n\t[4] Encontrar o Complementar\n\t[5] Encontrar o Complementar\n\t[6] Sair\n"
    pOpcao:     .asciz  "\nDigite sua opcao => "
    pSeparador: .asciz  "\n--------------------------------------------\n"
    pOpcaoInv:  .asciz  "\tOpcao INVALIDA\n\n\tTente Novamente!"
    pSelec:     .asciz  "\n\tVoce selecionou a opcao %d!\n"
    pQtdeA:     .asciz  "Digite a quantidade de elementos no Conjunto A => "
    pQtdeB:     .asciz  "Digite a quantidade de elementos no Conjunto B => "
    pPedeNum:   .asciz  "Digite o %do numero => "
    
    tipoDado:   .asciz  "%d"

.section .text

.globl _start
_start:
    call    _menu
    call    _leOpcao

    call    _analisaOpcao
    jmp     _start

_menu:
    pushl   $pSeparador
    call    printf

    pushl   $pInicio
    call    printf

    pushl   $pMenu
    call    printf
    
    addl    $12, %esp
    RET

_leOpcao:
    pushl   $pOpcao
    call    printf

    pushl   $opcao
    pushl   $tipoDado
    call    scanf
    addl    $12, %esp
    RET

_analisaOpcao:    
    movl    opcao, %eax

    cmpl    $1, %eax
    je      _leitura

    # so se ja tiver o conjunto A e B (dps)
    cmpl    $2, %eax
    je      _uniao
    cmpl    $3, %eax
    je      _interseccao
    cmpl    $4, %eax
    je      _diferenca
    cmpl    $5, %eax
    je      _complementar
    cmpl    $6, %eax
    call      _fim
   
    pushl   $pSeparador
    call    printf 
    pushl   $pOpcaoInv
    call    printf
    pushl   $pSeparador
    call    printf

    addl    $12, %esp
    jmp     _start

_leitura:
    call    _pegaTamanhos

    call    _alocaVetor

    # leitura dos elementos
    movl    vetorA, %edi
    movl    nA, %ecx
    movl    $1, %ebx
    call    _leVetor

    movl    vetorB, %edi
    movl    nB, %ecx
    movl    $1, %ebx
    call    _leVetor
    
    movl    $1, temVetor

    jmp     _start

_pegaTamanhos:
    pushl   $pSeparador
    call    printf

    pushl   opcao            # funcao p isso
    pushl   $pSelec
    call    printf
    
    pushl   $pQtdeA
    call    printf

    pushl   $nA
    pushl   $tipoDado
    call    scanf

    pushl   $pQtdeB
    call    printf

    pushl   $nB
    pushl   $tipoDado
    call    scanf
    
    addl    $36, %esp

    ret


_alocaVetor:
    movl    nA, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, vetorA

    movl    nB, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, vetorB

    addl    $8, %esp

    ret

_leVetor:
    pushl   %ecx
    pushl   %edi
    pushl   %ebx

    pushl   $pPedeNum
    call    printf
    addl    $4, %esp

    pushl   $num
    pushl   $tipoDado
    call    scanf
    addl    $8, %esp

    popl    %ebx
    popl    %edi
    popl    %ecx

    movl    num, %edx
    movl    %edx, (%edi)
    addl    $4, %edi
    incl    %ebx

    loop    _leVetor

    ret

_uniao:

_interseccao:

_diferenca:

_complementar:

_fim:
    pushl   $0
    call    exit
