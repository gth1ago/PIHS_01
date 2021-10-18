.section .data
    opcao:      .int    0
    nA:         .int    0
    nB:         .int    0
                                # 120 => ate 30 inteiros
    vetorA:     .space  120     # tem q ser definidor pelo USER
    vetorB:     .space  120

    pInicio:    .asciz  "\n\tManipulador de Conjuntos Numericos\n"
    pMenu:      .asciz  "\n\t\t  MENU\n\t[1] Leitura dos Conjuntos\n\t[2] Encontrar Uniao\n\t[3] Encontrar Inserccao\n\t[4] Encontrar o Complementar\n\t[5] Encontrar o Complementar\n\t[6] Sair\n"
    pOpcao:     .asciz  "\nDigite sua opcao => "
    pSeparador: .asciz  "\n--------------------------------------------\n"
    pOpcaoInv:  .asciz  "\tOpcao INVALIDA\n\n\tTente Novamente!"
    pSelecionou:.asciz  "\n\tVoce selecionou a opcao %d!\n"
    pQtdeA:     .asciz  "Digite a quantidade de elementos no Conjunto A => "
    pQtdeB:     .asciz  "Digite a quantidade de elementos no Conjunto B => "
    
    tipoDado:   .asciz  "%d"


.section .text

.globl _start
_start:
    call    _menu
    call    _leOpcao
    jmp     _analisaOpcao

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

    # so se ja tiver o conjunto A e B
    cmpl    $2, %eax
    je      _uniao
    cmpl    $3, %eax
    je      _interseccao
    cmpl    $4, %eax
    je      _diferenca
    cmpl    $5, %eax
    je      _complementar
    cmpl    $6, %eax
    je      _fim
   
    pushl   $pSeparador
    call    printf 
    pushl   $pOpcaoInv
    call    printf
    pushl   $pSeparador
    call    printf

    addl    $12, %esp
    jmp     _start

# modificá-los sempre que quiser. Serão sempre 2 conjunto: A e B.
# elementos diferente no msm conjunto
_leitura:
    pushl   $pSeparador
    call    printf

    pushl   opcao            # funcao p isso
    pushl   $pSelecionou
    call    printf
    
    pushl   $pQtdeA
    call    printf

    pushl   $nA
    pushl   $tipoDado
    call    scanf

    pushl   $pQtdeB
    call    printf

    pushl   $nB         # mesma variavel (?)
    pushl   $tipoDado
    call    scanf
    
    addl    $36, %esp
    
    jmp _start    

_uniao:

_interseccao:

_diferenca:

_complementar:

_fim:
    pushl   $0
    call    exit
