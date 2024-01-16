# c-_compiler

University project for subject "Principles of Programming Languages and Compilers"

The goal of this project was to implement the first two steps of the compiler called 'c-' which is lexical and syntax analysis.

## Lexical analysis (1st step):
For implementing the first step we used flex (fast lexical analyzer) which reads tokens from the input files and then prints valid tokens.

How to run (Ubuntu):
```
sudo apt install flex
flex step1.fl
gcc lex.yy.c
./a.out ex1 #example 1
```

## Syntax analysis (2nd step):
For implementing the second step we used bison (syntax analyzer) and flex.
Flex sends tokens to bison which prints the syntax tree of the input file.

How to run (Ubuntu):
```
sudo apt install flex
sudo apt install bison
flex step1.fl
bison -d step2.y
gcc step2.tac.c lex.yy.c -lfl
./a.out ex1 #example 1
```
