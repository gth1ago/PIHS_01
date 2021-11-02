.section .data
    opcao:      .int    0
    nA:         .int    0
    nB:         .int    0
    temConj:    .int    0
    num:        .int    0

    conjuntoA:  .space  4
    conjuntoB:  .space  4

    pInicio:    .asciz  "\n\tManipulador de Conjuntos Numericos\n"
    pMenu:      .asciz  "\n\t\t  MENU\n\t[1] Leitura dos Conjuntos\n\t[2] Encontrar Uniao\n\t[3] Encontrar Inserccao\n\t[4] Encontrar o Complementar\n\t[5] Encontrar o Complementar\n\t[6] Ver vetores\n\t[7] Sair\n"
    pOpcao:     .asciz  "\nDigite sua opcao => "
    pSeparador: .asciz  "\n--------------------------------------------\n"
    pOpcaoInv:  .asciz  "\tOpcao INVALIDA\n\n\tTente Novamente!"
    pSelec:     .asciz  "\n\tVoce selecionou a opcao %d!\n"
    pQtdeA:     .asciz  "Digite a quantidade de elementos no Conjunto A => "
    pQtdeB:     .asciz  "Digite a quantidade de elementos no Conjunto B => "
    pPedeNum:   .asciz  "Digite o %do numero => "
    pMostraCon: .asciz  "\Conjunto %d lido: "
    pPulaLinha: .asciz  "\n"
    pEspaco:    .asciz  "\t"

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
    je      _mostraConjuntos
    cmpl    $7, %eax
    je      _fim
   
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
    movl    conjuntoA, %edi
    movl    nA, %ecx
    movl    $1, %ebx
    call    _leVetor

    movl    conjuntoB, %edi
    movl    nB, %ecx
    movl    $1, %ebx
    call    _leVetor
    
    movl    $1, temConj

    jmp     _start

_pegaTamanhos:
    call    _opcaoEscolhida

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
    
    addl    $24, %esp

    ret

_opcaoEscolhida:
    pushl   $pSeparador
    call    printf

    pushl   opcao
    pushl   $pSelec
    call    printf

    addl    $12, %esp

    ret

_alocaVetor:
    movl    nA, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, conjuntoA

    movl    nB, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, conjuntoB

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

_mostraConjuntos:
    pushl   $1
    pushl   $pMostraCon
    call    printf
    movl    conjuntoA, %edi
    movl    nA, %ecx
    addl    $8, %esp
    call    _mostraConj 

    pushl   $2
    pushl   $pMostraCon
    call    printf
    movl    conjuntoB, %edi
    movl    nB, %ecx
    addl    $8, %esp
    call    _mostraConj

    jmp     _start

_mostraConj:
    pushl   %edi
    pushl   %ecx

    movl    (%edi), %eax
    pushl   %eax
    pushl   $tipoDado
    call    printf

    addl    $8, %esp

    popl    %ecx
    popl    %edi

    addl    $4, %edi

    loop    _mostraConj

    ret

_uniao:

_interseccao:

_diferenca:

_complementar:

_fim:
    pushl   $0
    call    exit
