# Basic Parser

* See Haskell code for basic implementation, Statements, Expressions, etc.

## Language Specifications

### Boolean Haakjes Taal

Raw inputs: 0, 1, (, )
Instructions: AND, OR, NOT

Iterate through token List, when encounter AND/NOT/OR, start effect call to prepare a logical expression. When LEFT_BRACK encountered go to depth 1 and continue. When RIGHT_BRACK encountered and depth is 1, all parsed data
