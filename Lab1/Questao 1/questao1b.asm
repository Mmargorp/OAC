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