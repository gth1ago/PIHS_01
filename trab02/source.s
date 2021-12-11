/*
Arquivo aula 30/11 GravaLeRegistros.s
Esse programa realiza a gravacao e leitura de registros em um arquivo,usando chamadas ao
sistema nas funcoes que manipulam arquivo. Por meio de um menu de opcoes, o usuario pode
escolher gravar ou mostrar registros. Os registros contem apenas 3 campos, mas poderiam
ter mais.
*/

.section .data

   pInicio:       .asciz   "\n\tPrograma Multiplicador Matricial\n"
   pMenu:         .asciz   "\n\t\t  MENU\n\t[1] Digitar Matrizes\n\t[2] Obter Matrizes de Arquivo\n\t[3] Calcular Produto Matricial\n\t[4] Gravar Matriz Resultante em Arquivo\n\t[5] Ver Matrizes\n\t[6] Sair\n"

   pOpcao:        .asciz   "\nDigite sua opcao => "
   pPedeNomeArq:  .asciz   "\nEntre com o nome do arquivo de entrada/saida\n> "

   pFim:          .asciz   "\nFinalizando ...\n\tAté =)\n\n"
   pSeparador:    .asciz   "\n-----------------------------------------------------------\n"
   pSelec:        .asciz   "\n\tVoce selecionou a opcao %d!\n\n"
   pMatrizL:      .asciz   "Digite a quantidade de linhas da Matriz %c => "
   pMatrizC:      .asciz   "Digite a quantidade de colunas da Matriz %c => "
   pMatrizValor:  .asciz   "Digite o valor de [-][%d] => "
   pPulaLinha:    .asciz   "\n"
   pDadoMatriz:   .asciz   " %.2lf"
   pMostraMatriz: .asciz   "\tMatriz %c lida => "
   pAvisoPrint:   .asciz   "\tBom, pra printar ponto flutuante tem mo trampo q nao consegui usar, ae fica 0 pq n ta printando certo, mas creio q a leitura ta td ok.. creio..\n\n"
   
   matrizA:       .space   8
   matrizB:       .space   8
   nomeArq:       .space   50

   opcao:         .int     0
   xA:            .int     0
   xB:            .int     0
   yA:            .int     0
   yB:            .int     0
   temMatriz:     .int     0
   descritor:     .int     0 # descritor do arquivo de entrada/saida

	valor:         .double  0.0

   dadoInt:       .asciz   "%d"
   dadoFloat:     .asciz   "%lf"
   dadoCarac:     .asciz   "%c"

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

# Constantes de configuracao do parametro flag da chamada open(). Estes valores
# sao dependentes de implementacao. Para se ter certeza dos valores corretos, compile o
# programa no final deste arquivo usando "gcc valoresopen.c -o valoresopen" e execute-o
# usando "./valoresopen". Caso seja diferente, corrija as definicoes abaixo.

   O_RDONLY:      .int     0x0000 # somente leitura
   O_WRONLY:      .int     0x0001 # somente escrita
   O_RDWR:        .int     0x0002 # leitura e escrita
   O_CREAT:       .int     0x0040 # cria o arquivo na abertura, caso ele n�o exista
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
   cmpl     $3, %eax
   je       _calcularProdutoMatricial
   cmpl     $4, %eax
   je       _gravarMatrizResultante
   cmpl     $5, %eax
   je       _visualizarMatrizes

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
   movl     %eax, %ecx         # tamanho total
   # movl     %edx, 0          # tinha q mostrar linha x
   movl     $0, %ebx           # mostrar coluna
   
   call     _leValoresMatriz
   call     _pulaLinha

   call     _leTamMatrizB
   call     _alocaMatrizB
   # faz leitura B
   movl     matrizB, %edi
   movl     xB, %eax
   mull     yB
   movl     %eax, %ecx
   # movl     %edx, 0
   movl     $0, %ebx
   
   call     _leValoresMatriz

   movl     $1, temMatriz
   ret

_obterMatrizesArquivo:
   ret

_calcularProdutoMatricial:
   ret
   
_gravarMatrizResultante:
   ret

_visualizarMatrizes:
   call     _opcaoEscolhida

   # nao sei os jeito certo de puxar e printar ponto flutuante
   # em <_mostraMatriz>
   pushl    $pAvisoPrint
   call     printf
   addl     $4, %esp
   # ---

   call     _mostraMatrizA
   call     _pulaLinha
   call     _mostraMatrizB
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
   call     malloc
   movl     %eax, matrizA

   addl     $4, %esp
   ret

_alocaMatrizB:
   # multiplica linha x coluna para alocação
   movl     xB, %eax
   mull     yB
   # multiplica pelo tamanho d ponto flutuante
   movl     $8, %ebx
   mull     %ebx

   pushl    %eax
   call     malloc
   movl     %eax, matrizB

   addl     $4, %esp
   ret

_leValoresMatriz:
   # backup
   pushl    %ecx      
   pushl    %edi

   # index p printar
   pushl    %ebx
   # pushl    %eax   # (precisava d + reg p mostra x e y)

   pushl    $pMatrizValor
   call     printf
   addl     $4, %esp

   # leitura do float/double
   pushl    $valor
   pushl    $dadoFloat
   call     scanf 
   addl     $8, %esp

   popl     %ebx
   popl     %edi
   popl     %ecx

   movl     valor, %edx    # armazena no vetor
   movl     %edx, (%edi)
   addl     $8, %edi       # vai pro proximo valor
   
   # tem q aumenta a linha e a coluna
   incl     %ebx

   loop     _leValoresMatriz

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
   call    _mostraMatriz
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
   call    _mostraMatriz
   ret

_mostraMatriz:
   pushl    %edi
   pushl    %ecx

   # aqui printa, talvez converter algo pro jeito certo p flutuante
   movl     (%edi), %eax
   pushl    %eax
   pushl    $pDadoMatriz
   call     printf

   addl     $8, %esp

   popl     %ecx
   popl     %edi

   addl     $8, %edi

   loop     _mostraMatriz

   ret

_fim:
   call     _verificaTemMatriz   # desalocar matrizes

   pushl    $pFim
   call     printf
   addl     $4, %esp
   pushl    $0
   call     exit
