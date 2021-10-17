# Herve runs Forth !

Using [A minimal Forth compiler in ANSI C](https://gist.github.com/lbruder/10007431) by [Leif Bruder](https://github.com/lbruder)
which I modified just enougth to run under herve :

```
$ ../herve -i lbForth.elf
Configuration error: DCELL_SIZE != 2*CELL_SIZE
 OK
 1 1 + .
2  OK
2 2 * .
4  OK
123 456 +
 OK
.
579  OK

5 2 + 10 * .
70  OK



: foo  100 + ;
 OK
1000 foo
 OK
.
1100  OK
10 foo foo foo .
310  OK


1 2 3 dup
 OK
. . . .
3 3 2 1  OK

1 2 3 4 swap
 OK
. . . .
3 4 2 1  OK


: print-stack-top  cr dup ." The top of the stack is " .
  cr ." which looks like '" dup emit ." ' in ascii  " ;
48 print-stack-top OK
 OK


The top of the stack is 48
which looks like '0' in ascii   OK

.
48  OK
.
? Stack underflow


 OK
: (fibo-iter) ( n n - n n) swap over + ;
 OK
: th-fibo ( n - n) >r 1 dup r> 2 - 0 do (fibo-iter) loop nip ;
 OK
10 th-fibo .
55  OK

4 th-fibo .
3  OK
12 th-fibo .
144  OK
14 th-fibo .
377  OK


```
