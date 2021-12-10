/*
Arquivo aula 30/11 GravaLeRegistros.s
Esse programa realiza a gravacao e leitura de registros em um arquivo,usando chamadas ao
sistema nas funcoes que manipulam arquivo. Por meio de um menu de opcoes, o usuario pode
escolher gravar ou mostrar registros. Os registros contem apenas 3 campos, mas poderiam
ter mais.
*/

.section .data
   pInicio:       .asciz   "\n\tPrograma Multiplicador Matricial\n"
   pMenu:         .asciz   "\n\t\t  MENU\n\t[1] Digitar Matrizes\n\t[2] Obter Matrizes de Arquivo\n\t[3] Calcular Produto Matricial\n\t[4] Gravar Matriz Resultante em Arquivo\n\t[5] Sair\n"

   pOpcao:        .asciz   "\nDigite sua opcao => "
   pPedeNomeArq:  .asciz   "\nEntre com o nome do arquivo de entrada/saida\n> "

   pFim:          .asciz   "\nFinalizando ...\n>>> Visualize o arquivo!\n\n"
   pSeparador:    .asciz   "\n-----------------------------------------------------------\n"

#  txtPedeNome:   .asciz   "\nDigite seu nome => "
#  txtPedeProf:   .asciz   "\nDigite sua profissao => "
#  txtPedeSal:    .asciz   "\nDigite seu salario => "
#  txtPedeCpf:    .asciz   "\nDigite seu CPF => "
#  txtPedeIda:    .asciz   "\nDigite sua idade => "
#  txtMostraNome: .asciz   "\nNome: %s\n"
#  txtMostraProf: .asciz   "\nProfissao: %s\n"
#  txtMostraSal:  .asciz   "\nSalario: R$ %.2lf\n"
#  txtMostraCpf:  .asciz   "\nCPF: %s\n"
#  txtMostraIda:  .asciz   "\nIdade: %.0lf anos\n"
#  registro:      .space   143 # nome (70), profissao (50), salario (8 = double), idade (3), CPF(12)
#  lixo:          .int     0
#  tam:           .int     143
	
   nomeArq:       .space   50
   opcao:         .int     0
   dadoInt:       .asciz   "%d"
   dadoFloat:     .asciz   "%lf"
   descritor:     .int     0 # descritor do arquivo de entrada/saida

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
   cmpl     $5, %eax
   je       _fim

   cmpl     $1, %eax
   je       _digitarMatrizes
   cmpl     $2, %eax
   je       _obterMatrizesArquivo
   cmpl     $3, %eax
   je       _calcularProdutoMatricial
   cmpl     $4, %eax
   je       _gravarMatrizResultante

   ret

_digitarMatrizes:
   ret

_obterMatrizesArquivo:
   ret

_calcularProdutoMatricial:
   ret
   
_gravarMatrizResultante:
   ret


_fim:
   pushl    $pFim
   call     printf
   addl     $4, %esp
   pushl    $0
   call     exit