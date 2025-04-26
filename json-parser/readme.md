# Challenge link

[JSON Parser Challenge](https://codingchallenges.substack.com/p/coding-challenge-2)

## Lexer

Lexical analysis is the process of dividing a sequence of characters into meaningful chunks, called tokens

So basically we have to identify things like 

- curly braces(both)
- keys
- values
- colon in between

## Parser

Syntactic analysis (which is also sometimes referred to as parsing) is the process of analysing the list of tokens to match it to a formal grammar

Here, we have to verify if we have tokens in correct format

- keys should always be a string
- values can be either of string, number, object, array, true, false, null
- all the strings should have double quotes
- for numbers, it can be
  - (-) negative
  - 0
  - digit (1-9)
  - (.) decimal
  - E or e (exponent)

## TODO

- [ ] verify step4 test