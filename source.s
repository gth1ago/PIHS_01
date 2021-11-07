# Trabalho Prático I - Manipulador de Conjuntos Numéricos
# Disciplina: Prog. Interfac. Hardware E Software (PIHS)
# Docente: 
#   Ronaldo Augusto Q. Volpato
# Discentes: 
#   Gabriel Thiago H. Santos    RA: 107774
#   Gustavo Henrique F. Cruz    RA: 109895

.section .data
    opcao:      .int    0
    nA:         .int    0
    nB:         .int    0
    temConj:    .int    0
    num:        .int    0
    temEmB:     .int    0
    tamInval:   .int    0

    conjuntoA:  .space  4
    conjuntoB:  .space  4

    pInicio:    .asciz  "\n\tManipulador de Conjuntos Numericos\n"
    pMenu:      .asciz  "\n\t\t  MENU\n\t[1] Leitura dos Conjuntos\n\t[2] Encontrar Uniao\n\t[3] Encontrar Inserccao\n\t[4] Encontrar a Diferenca\n\t[5] Encontrar o Complementar\n\t[6] Ver vetores\n\t[7] Sair\n"
    pOpcao:     .asciz  "\nDigite sua opcao => "
    pInter:     .asciz  "\n\tIntersecao => "
    pDiferenca: .asciz  "\n\tDiferenca de A - B => "
    pCompl:     .asciz  "\n\tComplementar de B em relacao a A => "
    pSeparador: .asciz  "\n-----------------------------------------------------------\n"
    pOpcaoInv:  .asciz  "\tOpcao INVALIDA\n\n\tTente Novamente!"
    pSelec:     .asciz  "\n\tVoce selecionou a opcao %d!\n\n"
    pQtdeA:     .asciz  "Digite a quantidade de elementos no Conjunto A => "
    pQtdeB:     .asciz  "Digite a quantidade de elementos no Conjunto B => "
    pPedeNum:   .asciz  "Digite o %o numero => "
    pUniao:     .asciz  "\tUniao => "
    pMostraCon: .asciz  "\tConjunto %c lido:"
    pMsgAviso:  .asciz  "\tVoce deve inserir os vetores antes de prosseguir!\n"
    pRepetido:  .asciz  "\nVoce inseriu um elemento repetido. Todos devem ser unicos. Tente novamente.\n"
    pTamErr:    .asciz  "\nNao e possivel verificar o complementar de B, o conjunto B é maior que A.\n"
    pContErr:   .asciz  "O conjunto B nao esta contido em A, impossivel calcular o complementar.\n"
    pPulaLinha: .asciz  "\n"

    tipoDado:   .asciz  "%d"
    tipoDadoEsp:.asciz  " %d"

.section .text

.globl _start
_start:
    call    _menu
    call    _leOpcao

    call    _analisaOpcao                           # recebe a opcao e faz o call para a opcao escolhida
    jmp     _start

# funcao auxiliar 
_pulaLinha:
    pushl   $pPulaLinha
    call    printf
    addl    $4, %esp

    ret

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

    # saida
    cmpl    $7, %eax
    je      _fim
   
    cmpl    $1, %eax
    je      _leConjuntos

    # verifica se ja tem vetor pras proximas opções
    movl    $0, %ebx            
    cmpl    temConj, %ebx       
    je      _semConj

    cmpl    $2, %eax
    je      _callUniao
    cmpl    $3, %eax
    je      _callInterseccao
    cmpl    $4, %eax
    je      _callDiferenca
    cmpl    $5, %eax
    je      _callComplementar
    cmpl    $6, %eax
    je      _callMostraConj

    call    _opInvalida
        
    ret

# rotulos para uso de call
_callUniao:
    call    _uniao
    jmp     _start

_callInterseccao:
    call     _intersecao
    jmp     _start

_callDiferenca:
    call    _diferenca
    jmp     _start

_callComplementar:
    call    _complementar
    jmp     _start

_callMostraConj:
    call    _mostraConjuntos
    jmp     _start

_opInvalida:
    pushl   $pSeparador
    call    printf 
    pushl   $pOpcaoInv
    call    printf

    addl    $8, %esp

    ret

_semConj:
    pushl   $pSeparador
    call    printf
    call    _pulaLinha
    pushl   $pMsgAviso
    call    printf

    addl    $8, %esp
    ret

# leitura dos conjuntos (opcao 1)
_leConjuntos:
    # para desalocar vetores usados
    call    _verificaTemVetor

_segueLeitura:
    call    _opcaoEscolhida
    call    _leConjuntoA
    call    _alocaConjuntoA
    
    movl    conjuntoA, %edi
    movl    nA, %ecx
    movl    $1, %ebx
    call    _leConjunto

    call    _pulaLinha

    call    _leConjuntoB
    call    _alocaConjuntoB

    movl    conjuntoB, %edi
    movl    nB, %ecx
    movl    $1, %ebx
    call    _leConjunto

    movl    $1, temConj

    jmp     _start

_verificaTemVetor:
    movl    $0, %ebx            
    cmpl    temConj, %ebx       
    je      _segueConjunto
    
    # se ja houve leitura de conjuntos, desaloca a memoria com free
    pushl   conjuntoA
    call    free
    pushl   conjuntoB
    call    free
    addl    $8, %esp
_segueConjunto:
    ret

_leConjuntoA:
    pushl   $pQtdeA
    call    printf

    pushl   $nA
    pushl   $tipoDado
    call    scanf

    addl    $12, %esp

    ret

_alocaConjuntoA:
    movl    nA, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, conjuntoA

    addl    $4, %esp

    ret

_leConjuntoB:
    pushl   $pQtdeB
    call    printf

    pushl   $nB
    pushl   $tipoDado
    call    scanf

    addl    $12, %esp

    ret

_alocaConjuntoB:
    movl    nB, %eax
    movl    $4, %ebx
    mull    %ebx
    pushl   %eax
    call    malloc
    movl    %eax, conjuntoB

    addl    $4, %esp

    ret

_opcaoEscolhida:
    pushl   $pSeparador
    call    printf

    pushl   opcao
    pushl   $pSelec
    call    printf

    addl    $12, %esp

    ret

_leConjunto:
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

    call    _insercaoUnica

    popl    %ebx
    popl    %edi
    popl    %ecx

    cmpl    $0, %eax
    jne     _continuarLeConjunto
    pushl   %ecx
    call    _deuErrado
    popl    %ecx
    jmp     _leConjunto

    _continuarLeConjunto:

    movl    num, %edx
    movl    %edx, (%edi)
    addl    $4, %edi
    incl    %ebx

    loop    _leConjunto

    ret

# funcao auxiliar para se é elemento repetido
_deuErrado:
    pushl   $pRepetido
    call    printf
    addl    $4, %esp

    ret

# verifica a intersecao
_insercaoUnica:
    subl    $1, %ebx
    subl    $4, %edi

    cmpl    $0, %ebx
    jne     _continuarInsercaoUnica
    ret

    _continuarInsercaoUnica:

    pushl   %ecx

    movl    %ebx, %ecx
    call    _verificarUnicidade

    popl    %ecx

    ret

# verifica se é unico
_verificarUnicidade:
    pushl   %ecx

    movl    num, %eax
    movl    (%edi), %ebx

    cmpl    %eax, %ebx
    jne     _continuarVerificacao
    popl    %ecx
    movl    $0, %eax
    ret

    _continuarVerificacao:

    popl    %ecx

    subl    $4, %edi

    loop    _verificarUnicidade

    movl    $1, %eax

    ret

# mostrar os conjuntos (opcao 6)
_mostraConjuntos:
    call    _opcaoEscolhida
    call    _mostraConjA
    call    _pulaLinha

    pushl   $'B'
    pushl   $pMostraCon
    call    printf
    addl    $8, %esp
    call    _mostraConjB

    ret
    #jmp     _start

_mostraConjA:
    pushl   $'A'
    pushl   $pMostraCon
    call    printf
    movl    conjuntoA, %edi
    movl    nA, %ecx
    addl    $8, %esp
    call    _mostraConj
    ret

_mostraConjB:
    movl    conjuntoB, %edi
    movl    nB, %ecx
    addl    $8, %esp
    call    _mostraConj
    ret

_mostraConj:
    pushl   %edi
    pushl   %ecx

    movl    (%edi), %eax
    pushl   %eax
    pushl   $tipoDadoEsp
    call    printf

    addl    $8, %esp

    popl    %ecx
    popl    %edi

    addl    $4, %edi

    loop    _mostraConj

    ret

_uniao:
    call    _opcaoEscolhida

    pushl   $pUniao
    call    printf
    addl    $4, %esp

    movl    nA, %ecx
    movl    conjuntoA, %edi

_voltaInterA:
    # percorre primeiro o A e
    # printa se o elemento não tiver no conjunto B
    # depois printa o conjunto B inteiro
    movl    $0, temEmB
    movl    (%edi), %eax   
    pushl   %ecx                                # backup

    movl    nB, %ecx
    movl    conjuntoB, %esi
    
    call    _voltaInterB    
    
    popl    %ecx

    addl    $4, %edi    

    loop    _voltaInterA

    # printa B
    call    _mostraConjB

    jmp     _start

_voltaInterB:
    movl    (%esi), %ebx
    pushl   %ecx            # backups
    pushl   %eax
    
    cmpl    %ebx, %eax
    jne      _continuaInter
    movl    $1, temEmB

_continuaInter:
    popl    %eax  
    popl    %ecx
    
    addl    $4, %esi
    loop    _voltaInterB

    cmpl    $0, temEmB
    jne     _segueUniao
    pushl   %eax
    pushl   $tipoDadoEsp    
    call    printf
    addl    $8, %esp

_segueUniao:
    ret

_intersecao:
    call    _opcaoEscolhida

    pushl   $pInter
    call    printf
    addl    $4, %esp

    movl    nA, %ecx
    movl    conjuntoA, %edi

_voltaComparaA:
    # para cada  eax (elemento) de A, verifica o B se tem repetido
    movl    (%edi), %eax   
    pushl   %ecx                                # backup
    
    movl    nB, %ecx
    movl    conjuntoB, %esi
    
    call    _voltaComparaB
    
    popl    %ecx

    addl    $4, %edi    

    loop    _voltaComparaA

    jmp     _start

_voltaComparaB:
    movl    (%esi), %ebx
    pushl   %ecx                                # backups
    pushl   %eax
    
    cmpl    %ebx, %eax
    jne      _continua
    call    _tamInvalido

_continua:
    popl    %eax  
    popl    %ecx
    
    addl    $4, %esi
    loop    _voltaComparaB

    ret

_tamInvalido:
    pushl   %ebx
    pushl   $tipoDadoEsp
    call    printf 
    addl    $8, %esp

    ret

_diferenca:
    call    _opcaoEscolhida
    pushl   $pDiferenca
    call    printf
    addl    $4, %esp

    movl    nA, %ecx
    movl    conjuntoA, %edi

_voltaDiferenca:
    # printa se o elemento não tiver no conjunto B
    
    movl    $0, temEmB
    movl    (%edi), %eax   
    pushl   %ecx                                    # backup

    movl    nB, %ecx
    movl    conjuntoB, %esi
    
    call    _voltaDifB    
    
    popl    %ecx

    addl    $4, %edi    

    loop    _voltaDiferenca

    jmp     _start

_voltaDifB:
    movl    (%esi), %ebx
    pushl   %ecx                                    # backups
    pushl   %eax
    
    cmpl    %ebx, %eax
    jne      _continuaDif
    movl    $1, temEmB

_continuaDif:
    popl    %eax  
    popl    %ecx
    
    addl    $4, %esi
    loop    _voltaDifB

    cmpl    $0, temEmB
    jne     _segueDif
    pushl   %eax
    pushl   $tipoDadoEsp    
    call    printf
    addl    $8, %esp

_segueDif:
    ret

_complementar:
    call    _opcaoEscolhida
    
    # verifica se é possivel fazer o complementar de B em relacao a A
    # B precisa estar contido em A

    movl    $nB, %ecx
    pushl   %ecx
    call    _VerificarBContidoEmA
    popl    %ecx

    pushl   $pCompl
    call    printf
    addl    $4, %esp

    # printa se o elemento de A não estiver em B
    movl    nA, %ecx
    movl    conjuntoA, %edi

_voltaComplementar:
    # printa se o elemento não tiver no conjunto B
    movl    $0, temEmB
    movl    (%edi), %eax   
    pushl   %ecx                                    # backup

    movl    nB, %ecx
    movl    conjuntoB, %esi
    
    call    _voltaDifB    
    
    popl    %ecx

    addl    $4, %edi    

    loop    _voltaComplementar

    jmp     _start

_voltaCompB:
    movl    (%esi), %ebx
    pushl   %ecx                                    # backups
    pushl   %eax
    
    cmpl    %ebx, %eax
    jne      _continuaComp
    movl    $1, temEmB

_continuaComp:
    popl    %eax  
    popl    %ecx
    
    addl    $4, %esi
    loop    _voltaCompB

    cmpl    $0, temEmB
    jne     _segueComp
    pushl   %eax
    pushl   $tipoDadoEsp    
    call    printf
    addl    $8, %esp

_segueComp:
    ret

_VerificarBContidoEmA:
    call    _verificarTamanhos
    
    movl    conjuntoB, %esi
    
    movl    nB, %ecx
    
    cmpl    $0, tamInval
    je      _continuarVerificarBContidoEmA
    call    _BNaoEstaContidoEmATamanhoErro
    jmp     _start

_continuarVerificarBContidoEmA:
    pushl   %ecx
    pushl   %esi

    movl    (%esi), %eax
    movl    nA, %ecx
    movl    conjuntoA, %edi
    call    _verificarNumEstaEmA

    popl    %esi
    popl    %ecx

    cmpl    $1, %eax
    jne     _ElementoNaoEstaContido
    call    _BNaoEstaContidoEmAContidoErro
    jmp     _start

_ElementoNaoEstaContido:
    addl    $4, %esi

    loop    _continuarVerificarBContidoEmA

    ret

_verificarNumEstaEmA:
    pushl   %ecx

    movl    (%edi), %ebx

    cmpl    %eax, %ebx
    jne     _continuarVerificarNumEstaEmA
    popl    %ecx
    movl    $0, %eax
    ret

    _continuarVerificarNumEstaEmA:

    popl    %ecx

    addl    $4, %edi

    loop    _verificarNumEstaEmA

    movl    $1, %eax

    ret

# funcao aulixiar - erro pois conj B é maior do que A
_BNaoEstaContidoEmATamanhoErro:
    pushl   $pTamErr
    call    printf
    addl    $4, %esp

    ret

# funcao auxiliar - erro pois conj B nao esta contido em A
_BNaoEstaContidoEmAContidoErro:
    pushl   $pContErr
    call    printf
    addl    $4, %esp

    ret

# funcao auxiliar - verificar o tamanho para o complementar
_verificarTamanhos:
    movl    $0, tamInval
    movl    nA, %eax
    movl    nB, %ebx

    cmpl    %eax, %ebx
    jle     _continuarVerificarTamanhos
    movl    $1, tamInval

_continuarVerificarTamanhos:
    ret

_fim:
    # para desalocar vetores usados
    call    _verificaTemVetor

    pushl   $0
    call    exit
