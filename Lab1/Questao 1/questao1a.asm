.data

zero: .float 0
dois: .float 2
quatro: .float 4

.text

BHASKARA:

# Colocando parametros de funcao em coprocessador 1, $f0 armazena 'a', $f1 armazena 'b', $f2 armazena 'c', cvt.s.w usados para teste

mtc1 $a0,$f0
cvt.s.w $f0,$f0
mtc1 $a1,$f1
cvt.s.w $f1,$f1
mtc1 $a2,$f2
cvt.s.w $f2,$f2
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

# Caso delta positivo havera duas raizes reais, observe que para o caso de delta zero o codigo salvara na pilha duas raizes reais iguais
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
j exit

# Caso delta positivo havera duas raizes complexas conjulgadas distintas
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
j exit

exit:
