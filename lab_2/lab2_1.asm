.data

	A: # Matriz A
	.word 1, 2, 3, 0, 1, 4, 0, 0, 1
	.align 2

	B: # Matriz B
	.word 1, -2, 5, 0, 1, -4, 0, 0, 1
	.align 2
	
	T: # Matriz transposta
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0
	.align 2
	
	R: # Matriz resultante
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0
	.align 2
	
.text
	# Armazena endereço de B no $t0
	la $t0, B
	# Armazena endereço de T no $t1
	la $t1, T
	# Armazena tamanho n(3) em $s0
	li $s0, 3
	# Armazena tamanho b(4) em $s1
	li $s1, 4
	
	# for i in range (0, 3)
	li $t2, 0 # i = $t2 = 0
	loop_i:
	beq $t2, $s0, final_i
		# for j in range (0, 3)
		li $t3, 0 # j = $t3 = 0
		loop_j:
		beq $t3, $s0, final_j
			
			# Calculo do endereço de T[i][j]
			mul $t4, $t2, $s0 # EndT = i * 3
			add $t4, $t4, $t3 # EndT = i * 3 + j
			mul $t4, $t4, $s1 # EndT = (i * 3 + j) * 4
			add $t4, $t4, $t1 # EndT = (i * 3 + j) * 4 + BaseT
			
			# Calculo do endereço de B[j][i]	
			mul $t5, $t3, $s0 # EndB = j * 3
			add $t5, $t5, $t2 # EndB = j * 3 + i
			mul $t5, $t5, $s1 # EndB = (j * 3 + i) * 4
			add $t5, $t5, $t0 # EndB = (j * 3 + i) * 4 + BaseB
			
			# T[i][j] = B[j][i]
			lw $t6, 0($t5)
			sw $t6, 0($t4)
			
			addi $t3, $t3, 1 # j++
		j loop_j
		final_j:
	addi $t2, $t2, 1 # i++
	j loop_i
	final_i:
	
	#load address da Base A
	la $s2, A
	#load address da Base R
	la $s3, R
	#load address da Base T
	la $s5, T
	
	# for i in range (0, 3)
	li $t0, 0 # i = $t0 = 0
	loop_k:
	beq $t0, $s0, final_k
		# for j in range (0, 3)
		li $t1, 0 # j = $t1 = 0
		loop_l:
		beq $t1, $s0, final_l
			
			li $t7, 0 #total = $t7 = 0
			
			# for k in range (0, 3)
			li $t2, 0 # k = $t2 = 0
			loop_m:
			beq $t2, $s0, final_m
				
				li $t6, 0 # mult = $t6 = 0
				
				#calculando o endereço A[i][k]
				mul $t4, $t0, $s0 # EndA = i * 3
				add $t4, $t4, $t2 # EndA = i * 3 + k
				mul $t4, $t4, $s1 # EndA = (i * 3 + k) * 4
				add $t4, $t4, $s2 # EndA = (i * 3 + k) * 4 + BaseA
				
				#calculando o endereço B[k][j]
				mul $t5, $t2, $s0 # EndB = k * 3
				add $t5, $t5, $t1 # EndB = k * 3 + j
				mul $t5, $t5, $s1 # EndB = (k * 3 + j) * 4
				add $t5, $t5, $s5 # EndB = (k * 3 + j) * 4 + BaseT
				
				lw $t4, 0($t4) #lw do A[i][k]
				lw $t5, 0($t5) #lw do B[k][j]
				
				mul $t6, $t4, $t5	
				add $t7, $t7, $t6
				
			addi $t2, $t2, 1 # k++	
			j loop_m
			final_m:	
			
		#calculando o endereço R[i][j]
		mul $t8, $t0, $s0 # EndR = i * 3
		add $t8, $t8, $t1 # EndR = i * 3 + j
		mul $t8, $t8, $s1 # EndR = (i * 3 + j) * 4
		add $t8, $t8, $s3 # EndR = (i * 3 + j) * 4 + BaseR
		
		
		sw $t7, 0($t8)
				
		addi $t1, $t1, 1 # j++
		j loop_l
		final_l:
		
	addi $t0, $t0, 1 # i++
	j loop_k
	final_k:
	
	
						
					

	
