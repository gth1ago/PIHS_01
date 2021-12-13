.section .data

   pInicio:       .asciz   "\n\tPrograma Multiplicador Matricial\n"
   pMenu:         .asciz   "\n\t\t  MENU\n\t[1] Digitar Matrizes\n\t[2] Obter Matrizes de Arquivo\n\t[3] Calcular Produto Matricial\n\t[4] Gravar Matriz Resultante em Arquivo\n\t[5] Ver Matrizes\n\t[6] Sair\n"

   pOpcao:        .asciz   "\nDigite sua opcao => "
   pPedeNomeArq:  .asciz   "\nEntre com o nome do arquivo de entrada/saida\n> "
   pFimPedeNomeArq:
   pFim:          .asciz   "\nFinalizando ...\n\tAté =)\n\n"
   pSeparador:    .asciz   "\n-----------------------------------------------------------\n"
   pSelec:        .asciz   "\n\tVoce selecionou a opcao %d!\n\n"
   pMatrizL:      .asciz   "Digite a quantidade de linhas da Matriz %c => "
   pMatrizC:      .asciz   "Digite a quantidade de colunas da Matriz %c => "
   pMatrizValor:  .asciz   "Digite o valor de [%d][%d] => "
   pPulaLinha:    .asciz   "\n"
   pDadoMatriz:   .asciz   " %.2lf\t"
   pMostraMatriz: .asciz   "\tMatriz %c lida => "
   pFaltaMatriz:  .asciz   "\n\tVocê deve entrar com as matrizes primeiro.\n"
   pDimError:     .asciz   "\n\tA quantidade de colunas de A deve ser igual a quantidade de linhas de B\n"
   pCalculoFeito: .asciz   "\n\tProduto matricial realizado com sucesso! Imprima as matrizes para ver o resultado.\n"
   
   matrizA:       .space   8
   matrizB:       .space   8
   matrizC:       .space   8
   nomeArq:       .space   50
   dimLida:       .space   80
   valorLido:     .space   8

   opcao:         .int     0
   xA:            .int     0
   xB:            .int     0
   yA:            .int     0
   yB:            .int     0
   temMatriz:     .int     0
   temMatrizC:    .int     0
   temArquivo:    .int     0
   descritor:     .int     0 # descritor do arquivo de entrada/saida
   i:             .int     0
   j:             .int     0
   k:             .int     0

	valor:         .double  0.0

   dadoInt:       .asciz   "%d"
   dadoFloat:     .asciz   "%lf"
   dadoCarac:     .asciz   "%c"

   enter:         .byte    10 # Codigo ascii do pula linha
   espaco:        .byte    32 # Codigo ascii do espaco em branco
   NULL:          .byte    0  # Codigo ascii do NULL = '\0'

   .equ tamPedeArqEntrada, pFimPedeNomeArq-pPedeNomeArq

# As constantes abaixo se referem aos servicos disponibilizados pelas
# chamadas ao sistema, devendo serem passadas no registrador %eax

   SYS_EXIT: 	   .int     1
   SYS_FORK: 	   .int     2
   SYS_READ: 	   .int     3
   SYS_WRITE: 	   .int     4
   SYS_OPEN: 	   .int     5
   SYS_CLOSE: 	   .int     6
   SYS_CREAT: 	   .int     8

# Descritores de arquivo para saida e entrada padrao

   STD_OUT: 	   .int     1 # descritor do video
   STD_IN:  	   .int     2 # descritor do teclado

# Constante usada na chamada exit() para termino normal

   SAIDA_NORMAL:  .int     0 # codigo de saida bem sucedida

# Constantes de configuracao do parametro flag da chamada open().

   O_RDONLY:      .int     0x0000 # somente leitura
   O_WRONLY:      .int     0x0001 # somente escrita
   O_RDWR:        .int     0x0002 # leitura e escrita
   O_CREAT:       .int     0x0040 # cria o arquivo na abertura, caso ele nao exista
   O_EXCL:        .int     0x0080 # forca a criacao
   O_APPEND:      .int     0x0400 # posiciona o cursor do arquivo no final, para adicao
   O_TRUNC:       .int     0x0200 # reseta o arquivo aberto, deixando com tamanho 0 (zero)

# Constantes de configuracao do parametro mode da chamada open().

   S_IRWXU:       .int     0x01C0# user (file owner) has read, write and execute permission
   S_IRUSR:       .int     0x0100 # user has read permission
   S_IWUSR:       .int     0x0080 # user has write permission
   S_IXUSR:       .int     0x0040 # user has execute permission
   S_IRWXG:       .int     0x0038 # group has read, write and execute permission
   S_IRGRP:       .int     0x0020 # group has read permission
   S_IWGRP:       .int     0x0010 # group has write permission
   S_IXGRP:       .int     0x0008 # group has execute permission
   S_IRWXO:       .int     0x0007 # others have read, write and execute permission
   S_IROTH:       .int     0x0004 # others have read permission
   S_IWOTH:       .int     0x0002 # others have write permission
   S_IXOTH:       .int     0x0001 # others have execute permission
   S_NADA:        .int     0x0000 # nao altera a situacao

.section .text

.globl _start
_start:
   call     _menuOp
   call     _leOpcao

   call     _analisaOpcao
   jmp      _start

_leOpcao:
   pushl    $pOpcao
   call     printf   
   
   pushl    $opcao
   pushl    $dadoInt
   call     scanf 
   
   addl     $12, %esp
   ret

_menuOp:
   pushl    $pSeparador
   call     printf

   pushl    $pInicio
   call     printf

   pushl    $pMenu
   call     printf

   addl     $12, %esp
   ret

_analisaOpcao:
   movl     opcao, %eax

   # saida
   cmpl     $6, %eax
   je       _fim


   cmpl     $1, %eax
   je       _digitarMatrizes
   cmpl     $2, %eax
   je       _obterMatrizesArquivo
   
   cmpl     $0, temMatriz
   je       _semMatrizes

   cmpl     $3, %eax
   je       _calcularProdutoMatricial
   cmpl     $4, %eax
   je       _gravarMatrizResultante
   cmpl     $5, %eax
   je       _visualizarMatrizes
   ret

   _semMatrizes:
   pushl    $pFaltaMatriz
   call     printf
   addl     $4, %esp
   ret

_opcaoEscolhida:
   pushl   $pSeparador
   call    printf

   pushl   opcao
   pushl   $pSelec
   call    printf

   addl    $12, %esp

   ret

# matrizes = Vetor de linha * coluna
_digitarMatrizes:
   call     _verificaTemMatriz   # se já tiver, faz o free
   
   call     _opcaoEscolhida
   call     _leTamMatrizA
   call     _alocaMatrizA
   
   # faz leitura A
   movl     matrizA, %edi
   movl     xA, %eax
   mull     yA
   movl     %eax, %ecx           # total elementos/iterador
   movl     $0, %ebx             # contador
   
   call     _leValoresMatrizA
   call     _pulaLinha

   call     _leTamMatrizB
   call     _alocaMatrizB
   # faz leitura B
   movl     matrizB, %edi
   movl     xB, %eax
   mull     yB                   # total elementos/iterador
   movl     %eax, %ecx           # contador
   movl     $0, %ebx
   call     _leValoresMatrizB

   movl     $1, temMatriz
   ret

_obterMatrizesArquivo:
   call     _lerArqEntrada
   call     _leMatrizArquivoA

   movl     $1, temMatriz
   movl     $1, temArquivo

   ret

_leMatrizArquivoA:
   movl     SYS_READ, %eax
   movl     descritor, %ebx
   movl     $dimLida, %ecx
   movl     $80, %edx
   int      $0x80

   ret

_lerArqEntrada:
   movl     SYS_WRITE, %eax
   movl     STD_OUT, %ebx
   movl     $pPedeNomeArq, %ecx
   movl     $tamPedeArqEntrada, %edx
   int      $0x80

   # Le nome do arquivo de entrada
   movl     SYS_READ, %eax
   movl     STD_IN, %ebx
   movl     $nomeArq, %ecx
   movl     $80, %edx
   int      $0x80

   # Insere final de string
   movl     $nomeArq, %edi
   subl     $1, %eax
   addl     %eax, %edi
   movl     NULL, %eax
   movl     %eax, (%edi)

   # Abre arquivo para leitura
   movl     SYS_OPEN, %eax
   movl     $nomeArq, %ebx
   movl     O_RDONLY, %ecx
   movl     S_IRUSR, %edx
   int      $0x80
   movl     %eax, descritor

   ret

_calcularProdutoMatricial:
   call     _verificarValidade
   call     _alocaMatrizC
   call     _efetuarCalculo
   call     _calculoFeito

   movl     $1, temMatrizC

   ret

_calculoFeito:
   pushl    $pCalculoFeito
   call     printf
   addl     $4, %esp

   ret

_verificarValidade:
   movl     xB, %eax
   movl     yA, %ebx
   cmpl     %eax, %ebx
   jne      _dimensoesInvalidas

   ret

_dimensoesInvalidas:
   pushl    $pDimError
   call     printf
   addl     $4, %esp

   jmp      _start

_efetuarCalculo:
   
   movl     $0, i
   movl     $0, j
   movl     $0, k
   movl     xA, %ecx
   call     _loopExterno

   ret

_loopExterno:
   pushl    %ecx

   movl     xB, %ecx
   call     _loopIntermediario

   popl     %ecx
   incl     i
   loop     _loopExterno
   ret

_loopIntermediario:
   pushl    %ecx

   movl     yB, %ecx
   call     _loopInterno

   popl     %ecx
   incl     j
   loop     _loopIntermediario
   ret

_loopInterno:
   pushl    %ecx

   movl     matrizA, %edi
   movl     i, %eax
   mull     yB
   addl     k, %eax
   movl     $8, %edx
   mull     %edx
   addl     %eax, %edi

   fldl     (%edi)

   movl     matrizB, %esi
   movl     k, %eax
   mull     xB
   addl     j, %eax
   movl     $8, %edx
   mull     %edx
   addl     %eax, %esi

   fmull    (%esi)

   movl     matrizC, %edi
   movl     i, %eax
   mull     xB
   addl     j, %eax
   movl     $8, %edx
   mull     %edx
   addl     %eax, %edi

   faddl    (%edi)

   fstpl    (%edi)

   popl     %ecx
   incl     k
   loop     _loopInterno   
   ret

_gravarMatrizResultante:
   ret

_visualizarMatrizes:
   call     _opcaoEscolhida

   call     _mostraMatrizA
   call     _pulaLinha
   call     _mostraMatrizB
   movl     $0, %ebx
   cmpl     temMatrizC, %ebx
   je       _finalVisualizarMatrizes
   call     _pulaLinha
   call     _mostraMatrizC
   _finalVisualizarMatrizes:
   ret

_leTamMatrizA:
   # quantidade linhas de A
   pushl    $'A'
   pushl    $pMatrizL
   call     printf

   pushl    $xA
   pushl    $dadoInt
   call     scanf

   # quantidade coluna de A
   pushl    $'A'
   pushl    $pMatrizC
   call     printf

   pushl    $yA
   pushl    $dadoInt
   call     scanf
   addl     $32, %esp
   ret

_leTamMatrizB:
   # quantidade linhas de B
   pushl    $'B'
   pushl    $pMatrizL
   call     printf

   pushl    $xB
   pushl    $dadoInt
   call     scanf

   # quantidade coluna de B
   pushl    $'B'
   pushl    $pMatrizC
   call     printf

   pushl    $yB
   pushl    $dadoInt
   call     scanf

   addl     $32, %esp
   ret

_alocaMatrizA:
   # multiplica linha x coluna para alocação
   movl     xA, %eax
   mull     yA
   # multiplica pelo tamanho d ponto flutuante
   movl     $8, %ebx
   mull     %ebx

   pushl    %eax
   movl     $1, %ebx
   pushl    %ebx
   call     calloc
   movl     %eax, matrizA

   addl     $8, %esp
   ret

_alocaMatrizB:
   # multiplica linha x coluna para alocação
   movl     xB, %eax
   mull     yB
   # multiplica pelo tamanho d ponto flutuante
   movl     $8, %ebx
   mull     %ebx

   pushl    %eax
   movl     $1, %ebx
   pushl    %ebx
   call     calloc
   movl     %eax, matrizB

   addl     $8, %esp
   ret

_alocaMatrizC:
   # multiplica linha x coluna para alocação
   movl     xA, %eax
   mull     yB
   # multiplica pelo tamanho d ponto flutuante
   movl     $8, %ebx
   mull     %ebx

   pushl    %eax
   movl     $1, %ebx
   pushl    %ebx
   call     calloc
   movl     %eax, matrizC

   addl     $8, %esp
   ret

_leValoresMatrizA:
   # backup
   pushl    %ecx      
   pushl    %edi
   pushl    %ebx

   # calculo de linha/coluna para impressao
   movl     %ebx, %eax
   xorl     %edx, %edx
   divl     yA
   pushl    %edx
   movl     %ebx, %eax
   xorl     %edx, %edx
   divl     yA
   pushl    %eax

   pushl    $pMatrizValor
   call     printf
   addl     $12, %esp

   # leitura do float/double
   pushl    $valor
   pushl    $dadoFloat
   call     scanf 
   addl     $8, %esp
   fldl     valor
   fstpl    (%edi)

   popl     %ebx
   popl     %edi
   popl     %ecx

   movl     valor, %edx    # armazena no vetor
   movl     %edx, (%edi)
   addl     $8, %edi       # vai pro proximo valor
   
   incl     %ebx

   loop     _leValoresMatrizA

   ret

_leValoresMatrizB:
   # backup
   pushl    %ecx      
   pushl    %edi
   pushl    %ebx

   # calculo de linha/coluna para impressao
   movl     %ebx, %eax
   xorl     %edx, %edx
   divl     yB
   pushl    %edx
   movl     %ebx, %eax
   xorl     %edx, %edx
   divl     yB
   pushl    %eax

   pushl    $pMatrizValor
   call     printf
   addl     $12, %esp

   # leitura do float/double
   pushl    $valor
   pushl    $dadoFloat
   call     scanf 
   addl     $8, %esp
   fldl     valor
   fstpl    (%edi)

   popl     %ebx
   popl     %edi
   popl     %ecx

   movl     valor, %edx    # armazena no vetor
   movl     %edx, (%edi)
   addl     $8, %edi       # vai pro proximo valor
   
   incl     %ebx

   loop     _leValoresMatrizB

   ret

_verificaTemMatriz:
   movl     $0, %ebx            
   cmpl     temMatriz, %ebx       
   je       _segueMat

   # se ja houve leitura de matriz
   pushl    matrizA
   call     free
   pushl    matrizB
   call     free
   addl     $8, %esp
_segueMat:
   ret

# funcao auxiliar 
_pulaLinha:
    pushl   $pPulaLinha
    call    printf
    addl    $4, %esp

    ret

_mostraMatrizA:
   pushl    $'A'
   pushl    $pMostraMatriz
   call     printf
   movl     matrizA, %edi
   movl     xA, %eax
   mull     yA
   movl     %eax, %ecx
   addl     $8, %esp
   movl     yA, %ebx
   call     _mostraMatriz
   ret

_mostraMatrizB:
   pushl    $'B'
   pushl    $pMostraMatriz
   call     printf
   movl     matrizB, %edi
   movl     xB, %eax
   mull     yB
   movl     %eax, %ecx
   addl     $8, %esp
   movl     yB, %ebx
   call     _mostraMatriz
   ret

_mostraMatrizC:
   pushl    $'C'
   pushl    $pMostraMatriz
   call     printf
   movl     matrizC, %edi
   movl     xA, %eax
   mull     yB
   movl     %eax, %ecx
   addl     $8, %esp
   movl     yB, %ebx
   call     _mostraMatriz
   ret

_mostraMatriz:
   pushl    %ebx              # Tamanho Coluna

   fldl     (%edi)
   pushl    %ecx

   movl     %ecx, %eax
   xorl     %edx, %edx
   divl     %ebx
   cmpl     $0, %edx
   jne      _proximaLinha
   pushl    $pPulaLinha
   call     printf
   addl     $4, %esp
   _proximaLinha:
   subl     $8, %esp
   fstpl    (%esp)
   pushl    $pDadoMatriz
   call     printf
   addl     $12, %esp

   popl     %ecx

   addl     $8, %edi

   popl     %ebx

   loop     _mostraMatriz

   ret

_fim:
   call     _verificaTemMatriz   # desalocar matrizes

   pushl    $pFim
   call     printf
   addl     $4, %esp
   pushl    $0
   call     exit
