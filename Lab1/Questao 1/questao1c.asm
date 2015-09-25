.data

zero: .float 0
dois: .float 2
quatro: .float 4

string_solicitacao: .asciiz "Dado a representacao de um polinomio de segundo grau: ax^2 + bx +c. Informe os coeficientes a,b,c. Observe que esses coeficientes devem ser reais e nao nulos.\n"
string_pergunta: .asciiz "Deseja efetuar mais calculos?(digite S, se sim)\n"
string_a: .asciiz "a = "
string_b: .asciiz "b = "
string_c: .asciiz "c = "
barra_n: .ascii "\n"

R1: .asciiz "R(1)="
R2: .asciiz "R(2)="
mais: .asciiz "+"

.text


MAIN:

la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

addi $v0,$0,4
la $a0, string_solicitacao
syscall

la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

# Leitura de a
addi $v0,$0,4
la $a0, string_a
syscall
addi $v0,$0,6
syscall
mfc1 $a0,$f0
add $t0,$0,$a0 # salvando $a0 em $t0
la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall 
#

# Leitura de b
addi $v0,$0,4
la $a0, string_b
syscall
addi $v0,$0,6
syscall
mfc1 $a1,$f0
la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

# Leitura de c
addi $v0,$0,4
la $a0, string_c
syscall
addi $v0,$0,6
syscall
mfc1 $a2,$f0
la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall
#

add $a0,$0,$t0 # recupera-se o valor de $a0

jal BHASKARA

add $a0,$v0,$0
jal show

la $a0, string_pergunta
addi $v0,$0,4
syscall

addi $v0,$0,12
syscall
addi $t0,$0,83 # 83 em ASCII corresponde a 'S'
beq $v0,$t0,MAIN

# Saindo do codigo
addi $v0,$0,10
syscall
#


BHASKARA:

# Colocando parametros de funcao em coprocessador 1, $f0 armazena 'a', $f1 armazena 'b', $f2 armazena 'c'

mtc1 $a0,$f0
mtc1 $a1,$f1
mtc1 $a2,$f2
#

# Calculo de delta, $f4 eh utilizado como auxiliar, recebe constantes, $f3 recebe valor de b^2,$f5 recebe delta
mul.s $f3,$f1,$f1
mul.s $f5,$f0,$f2
l.s $f4,quatro
mul.s $f5,$f5,$f4
sub.s $f5,$f3,$f5
#

# Carrega-se 0 em representacao float IEEE e efetua-se comparacao com delta, $f6 recebe -b
l.s $f4,zero
sub.s $f6,$f4,$f1
c.lt.s $f5,$f4
bc1t 0, deltamenos
#

# Caso delta positivo havera duas raizes reais, observe que para o caso de delta zero o codigo salvara na pilha duas raizes reais iguais, cada raiz em uma word da pilha
deltamais:
sqrt.s $f5, $f5
add.s $f3,$f6,$f5
sub.s $f7,$f6,$f5
l.s $f4,dois
mul.s $f4,$f0,$f4
div.s $f3,$f3,$f4
div.s $f7,$f7,$f4
addi,$sp,$sp,-8
swc1 $f3,0($sp)
swc1 $f7,4($sp)
add $v0,$0,1
jr $ra
#

# Caso delta positivo havera duas raizes complexas conjulgadas distintas, salvas na pilha, cada raiz em duas word da pilha
deltamenos:
sub.s $f5,$f4,$f5
sqrt.s $f5,$f5
l.s $f4,dois
mul.s $f4,$f0,$f4
div.s $f3,$f6,$f4
div.s $f7,$f5,$f4
addi,$sp,$sp,-16
swc1 $f3,0($sp)
swc1 $f7,4($sp)
l.s $f4,zero
sub.s $f7,$f4,$f7
swc1 $f3,8($sp)
swc1 $f7,12($sp)
add $v0,$0,2
jr $ra
#

# Recebe $a0 correspondendo a 1 para raizes reais ou 2 para raizes complexas conjugadas 
show:

li $t0,1
beq $a0,$t0,raizes_reais

raizes_complexas:

la $a0, R1
addi $v0,$0,4
syscall

lwc1 $f12,0($sp)
addi $v0,$0,2
syscall

lwc1 $f12,4($sp)

l.s $f1, zero
c.lt.s $f12,$f1
bc1t 0, negativa_1

positiva_1:# observe que se um numero eh positivo o sinal + nao eh colocado ao se mostrar na tela portanto eh necessario inseri-lo caso necessario, essa label eh usada meramente para melhor compreensao do codigo  

la $a0, mais
addi $v0,$0,4
syscall

negativa_1:

addi $v0,$0,2
syscall

addi $a0,$0,105 # 105 consiste na representacao de 'i' em ASCII
addi $v0,$0,11
syscall

la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

la $a0, R2
addi $v0,$0,4
syscall

lwc1 $f12,8($sp)
addi $v0,$0,2
syscall

lwc1 $f12,12($sp)
l.s $f1, zero
c.lt.s $f12,$f1
bc1t 0, negativa_2

positiva_2:# observe que se um numero eh positivo o sinal + nao eh colocado ao se mostrar na tela portanto eh necessario inseri-lo caso necessario, essa label eh usada meramente para melhor compreensao do codigo  

la $a0, mais
addi $v0,$0,4
syscall

negativa_2:

addi $v0,$0,2
syscall

addi $a0,$0,105 # 105 consiste na representacao de 'i' em ASCII
addi $v0,$0,11
syscall

la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

addi $sp,$sp,16
jr $ra

raizes_reais:

lwc1 $f12,0($sp)

la $a0, R1
addi $v0,$0,4
syscall

lwc1 $f12,0($sp)
addi $v0,$0,2
syscall

la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

la $a0, R2
addi $v0,$0,4
syscall

lwc1 $f12,4($sp)
addi $v0,$0,2
syscall

addi $sp,$sp 8
la $a0,barra_n
lw $a0,0($a0)
addi $v0,$0,11
syscall

jr $ra
#