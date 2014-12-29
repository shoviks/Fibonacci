#public static void main(String args[])
#	{
#		Scanner input = new Scanner(System.in);
#
#		System.out.println("Enter value of t:");
#		int t = input.nextInt();
#		int nonRec = nonRecursive(t);
#		int rec = recursive(t);
#		System.out.println(t+"th value of the series is: "+ nonRec);
#		System.out.println(t+"th value of the series is: "+ rec);
##	public static int nonRecursive(int n)
#	{
#		int i, a = 0, b = 1, c = 0;
#		for(i = 0; i < n - 1; i++) {
#			c = a + b;
#			a = b;
#			b = c;
#		}
#		return c;
#	}
#	public static int recursive(int n)
#	{
#		if(n == 0)
#	        return 0;
#	    else if(n == 1)
#	      return 1;
#	   else
#	      return recursive(n - 1) + recursive(n - 2);
#	}
.data
Enter:
	.asciiz "\Enter a non-negative number to calculate its fibonacci value: "
	
PrintR:
	.asciiz "\Using the recursive method: "

PrintN:
	.asciiz "\Using the nonrecursive method: "

Is:
	.asciiz " is "
	
Newline:
	.asciiz "\n"

.text
.globl main
main:

	#Prints enter message
 	li  $v0, 4 
        la  $a0, Enter
        syscall

        #read an integer from keyboard 
        li $v0, 5
        syscall
         
        move $s0, $v0 #store input integer in $s0 to print after method is called 
        move $a0, $v0  #put the input integer into $a0, the input parameter for nonRec
        
        jal nonRec #calls nonrecursive method
        
        #put return value in $t0
        move $t0, $v0
        
        #Prints that nonrecursive method is being used                
        la $a0, PrintN
        li $v0, 4
        syscall
         
        #prints out the return value of nonRecursive(n)
        move $a0, $t0
        li $v0, 1
        syscall
             
        move $a0, $s0


	jal rec #calls recursive method

	#moves return value to $t0
	move $t0, $v0
        
        #Prints newline
        la $a0, Newline
        li $v0, 4
        syscall
        
        #Prints that recursive method is being used
        la $a0, PrintR
        li $v0, 4
        syscall
         
        #prints out the return value of recursive(n)
        move $a0, $t0
        li $v0, 1
        syscall

	#Returns to operating system
	li $v0,10
	syscall

nonRec:
	#adjust stack for additional items
	addi $sp, $sp, -8
	
	#save registers for use later
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	add $t0, $t0, $zero #i = 0
	add $t1, $t1, $zero #a = 0
	addi $t2, $t2, 1 #b - 1
	add $t3, $t3, $zero # c = 0
	
	subi $a0, $a0, 1 # n = n - 1
	
	j loop 

loop:	
        #branch if i >= n
	bge $t0, $a0, return 
	
	
	addi $t0, $t0, 1 # i++
	
	add $t3, $t1, $t2 # c = a + b
	add $t1, $t2, $zero # a = b
	add $t2, $t3, $zero # b = c
	
	j loop

return:
	#restore registers for caller
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	
	#adjust stack to delete items
	addi $sp, $sp, 8
	
	#make c return variable
	add $v0, $t3, $zero
	jr $ra

rec:
	#adjust stack for more items
	addi $sp,$sp,-12 
	
	#save registers for use later
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)

        # move n value to $s0
	move $s0,$a0
         
        # $t1 = 1 
	addi $t1,$zero,1
	
	#branch to zero if $s0 = 0
	beq $s0,$zero,zero
	
	#branch to one if $s0 = 1
	beq $s0,$t1,one

        # n = n - 1
	addi $a0,$s0,-1

	jal rec

	add $s1,$zero,$v0     # s1 = rec(n-1)

	# n = n - 2
	addi $a0,$s0,-2

	jal rec               # v0 = rec(n-2)

	add $v0,$v0,$s1       # v0 = rec(n-2) + rec(n-1)

recReturn:
	# restore registers for caller
	lw $ra,0($sp)       
	lw $s0,4($sp)
	lw $s1,8($sp)
	
	# adjust stack to delete items
	addi $sp,$sp,12       
	jr $ra
one:
	#v0 = 1
 	addi  $v0, $zero, 1
 	j recReturn
 
zero :     
	#v0 = 0
	addi $v0, $zero, 0
	j recReturn

