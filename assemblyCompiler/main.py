# S4i - Projet E2021
# Démonstration d'un compilateur
#
# Ce programme est un exemple de compilation d'un langage simple pour PicoBlaze.
# Il est à noter que la compilation n'est pas complète.
# En fait, ce compilateur s'arrête à la génération du code assembleur PicoBlaze,
# qui lui peut être assemblé avec kpcm6 ou opbasm en un IP VHDL importable dans
# Vivado.
# Si vous voulez compiler le résultat avec opbasm, vous pouvez utiliser ces
# commandes, en supposant que vous avez bien installer opbasm (voir requirements.txt):
#
#   python3 ./main.py test.src > test.psm
#   python3 -m opbasm -6 test.psm
#
# Vous retrouverez ensuite le fichier .vhd à importer. 
#
# Le langage de base est (très) simple : il ne permet que des additions et
# et soustractions, suppose que toutes les variables tiennent sur 8 bits, et n'a pas
# de conditions.
# Cependant, elle fait l'allocation automatique de variables sur le "scratchpad", et
# offre une syntaxe rudimentaire pour l'accès aux ports en entrée et en sortie.
#
#
# Si vous lancez le programme seul (sans arguments), une invite de commande avec
# boucle Read-Eval-Print (REPL) vous permettra de tester la compilation de bouts
# de code.
# Si vous tapez par exemple "y=2+2;$[1]=y;", vous obtiendrez quelque chose comme
# ceci :
#
# eval> y = 2+2; $[1] = y;
# LOAD s0, 2
# LOAD s1, 2
# ADD s0, s1
# STORE s0, 0 ; var y
# FETCH s0, 0 ; var y
# OUTPUT s0, 1
#
# Les deux premières lignes chargent la valeur temporaire 2 dans deux registres
# différents.
# La troisième fait l'addition, et la quatrième enregistre le résultat à l'adresse 0,
# qui a été automatiquement allouée pour la variable y.
# Finalement, les 2 dernières lignes récupèrent le contenu à l'adresse 0 et l'utilise 
# comme sortie au port 1.
#
# Le code suivant est une adaptation des exemples de ply (Python Lex-Yacc).

import ply.lex as lex
import ply.yacc as yacc

import sys

#
# Added function to write a comment in the compiled assembly code for readability
#
def printComment(string):
    print("\n; "  + '-' * 64)
    print("; " + string)
    print('; ' + '-' * 64)

# A simple class to model registers and memory allocation
class Machine:
    def __init__(self):
        self.registers = [False]*10
        self.memmap = {}
        self.next_addr = 0

        pass

    # Get the next available register
    def getRegister(self):
        for i in range(0, len(self.registers)):
            #print("This is i : %d" % i)
            if not self.registers[i]:
                self.registers[i] = True

                return i
        raise("No more registers!")

    # Free a register for usage
    def freeRegister(self, r):
        self.registers[r] = False

    # Free all registers
    def freeAllRegisters(self):
        self.registers = [False]*10

    # Return the scratchpad address for a given symbol (auto-allocates if unknown)
    def getAddress(self, varname):
        # Unknown variable - auto allocate to the next scratch mem address
        # Throws if address is more than 255 (out of mem)
        if not varname in self.memmap:
            if (self.next_addr > 255):
                raise RuntimeError("not enough memory")
            self.memmap[varname] = self.next_addr
            self.next_addr += 1
        return self.memmap[varname]

# AST definitions

class Expr: pass

class BinOp(Expr):
    def __init__(self,left,op,right):
        self.left = left
        self.right = right
        self.op = op

    def eval(self, machine):
        printComment("Addition ou Soustraction")

        ops = {
            "+": "ADD",
            "-": "SUB"
        }
        
        r1 = self.left.eval(machine)
        r2 = self.right.eval(machine)
        print("%s s%i, s%i"%(ops[self.op], r1, r2))
        machine.freeRegister(r2)
        return r1

#
# Added to be able to add and subtract 16 bits
#
class BinOp16(Expr):
    def __init__(self, left, op, right):
        print("left %s, right %s, op %s" % (left, right, op))
        self.left = left
        self.right = right
        self.op = op

    def eval(self, machine):
        #print("sest rendu la avec op = %s" % self.op)
        printComment("Addition ou Soustraction sur 16 bits")

        #r1_1 = self.left.eval(machine)

        r1 = self.left.eval(machine)
        r2 = self.right.eval(machine)

        # if (self.op == "++"):
        #     print("ADD s%i, s%i" % (r1, r2))
        #     print("ADDCY s%i, s%i" % (r1 + 1, r2 + 1))
        # elif (self.op == "--"):
        #     print("SUB s%i, s%i" % (r1, r2))
        #     print("SUBCY s%i, s%i" % (r1 + 1, r2 + 1))

        #print("%s s%i, s%i" % (ops[self.op], r1, r2))
        # machine.freeRegister(r2)
        #print("se termine")
        return r1

#
# Added to be able to divide or multiply by multiples of 2
#
class ShiftOp(Expr):
    def __init__(self, left, op, right):
        self.left = left
        self.right = right
        self.op = op

    def eval(self, machine):
        printComment("Multiplication ou division par 2^%i" % self.right)

        ops = {
            "<<": "SL0",
            ">>": "SR0"
        }

        r1 = self.left.eval(machine)
        r2 = self.right

        for i in range(r2):
            print("%s s%i" % (ops[self.op], r1))
        machine.freeRegister(r2)
        return r1

class AssignOp(Expr):
    def __init__(self, left, right):
        self.varid = left
        self.right = right
    
    def eval(self, machine):
        r1 = self.right.eval(machine)

        print("STORE s%i, %i ; var %s" % (r1, machine.getAddress(self.varid), self.varid))
        machine.freeRegister(r1)
        return 0

class AssignOp16(Expr):
    def __init__(self, left, right):
        self.varid = left
        self.right = right

    def eval(self, machine):
        printComment("Assignation sur 16 bits")
        r1 = self.right.eval(machine)
        print("r1 is %d" % r1)
        r2 = self.right.eval(machine)
        print("STORE s%i, %i ; var %s"%(r1, machine.getAddress(self.varid + "_low"), self.varid))
        print("STORE s%i, %i ; var %s" % (r1, machine.getAddress(self.varid + "_high"), self.varid))
        machine.freeRegister(r1)
        return 0

class Number(Expr):
    def __init__(self,value):
        self.value = value

    def eval(self, machine):

        hexValue = hex(self.value)[2:] # Removing added 0x

        #print("hex number : %s" % hexValue)

        if len(hexValue) <= 2:
            r1 = machine.getRegister()
            # Changes to Hexadecimal magically
            print("LOAD s%i, %X" % (r1, self.value))
        elif len(hexValue) <= 4:
            r1 = machine.getRegister()
            print("LOAD s%i, %s ; partie high" % (r1, hexValue[0:2]))
            r1 = machine.getRegister()
            print("LOAD s%i, %s; partie low" % (r1, hexValue[2:]))
        else:
            print("Erreur: nombre plus grand que 16 bits")

        return r1

class VarID(Expr):
    def __init__(self, varid):
        self.varid = varid
    
    def eval(self, machine):
        r1 = machine.getRegister()
        print("FETCH s%i, %i ; var %s"%(r1, machine.getAddress(self.varid), self.varid))
        return r1

class InputOp(Expr):
    def __init__(self, portnum):
        self.portnum = portnum

    def eval(self, machine):
        printComment("On met la valeur du port %i dans une variable" % self.portnum)

        r1 = machine.getRegister()

        print("INPUT s%i, %i"%(r1, self.portnum))

        return r1

# Function added to store 2 consecutive values of ports to 2 consecutive memory addresses
# class InputOp16(Expr):
#     def __init__(self, portnum):
#         self.portnum = portnum
#
#     def eval(self, machine):
#         printComment("On met la valeur des ports %i et %i dans 2 registres consecutifs" % (self.portnum, self.portnum + 1))
#
#         r1 = machine.getRegister()
#         print("INPUT s%i, %i"%(r1, self.portnum))
#         return r1

class OutputOp(Expr):
    def __init__(self, left, right):
        self.portnum = left
        self.right   = right

    def eval(self, machine):
        printComment("On met la valeur de la variable en sortie au port %s" % self.portnum)

        r1 = self.right.eval(machine)
        print("OUTPUT s%i, %i"%(r1, self.portnum))
        return 0

class Statements():
    def __init__(self, statements):
        self.statements = statements

    def eval(self, obs):
        for s in self.statements:
            s.eval(obs)

class Statement():
    def __init__(self, expr):
        self.expr = expr

    def eval(self, machine):
        self.expr.eval(machine)
        machine.freeAllRegisters()

# List of token names.   This is always required
tokens = (
   'NUMBER',
   'VARID',
   'EQUAL',
   'PLUS',
   'MINUS',
   'LPAREN',
   'RPAREN',
   'LBRACK',
   'RBRACK',
   'PORT',
   'SEMICOLON',
   'LSHIFT',
   'RSHIFT',
)

# Regular expression rules for simple tokens
t_EQUAL   = r'\='
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_LBRACK  = r'\['
t_RBRACK  = r'\]'
t_PORT    = r'\$'
t_SEMICOLON = r'\;'
t_LSHIFT = r'\<<'
t_RSHIFT = r'\>>'
# t_PLUS16    = r'\++'
# t_MINUS16   = r'\--'

# Rule added to handle (ignore) comment lines
def t_COMMENT(t):
    r'\#.*'
    pass

# A regular expression rule with some action code
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

reserved = {}
def t_VARID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'VARID')    # Check for reserved words
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

# Yacc (syntax)

precedence = (
    ('left', 'EQUAL'),
    ('left', 'PLUS', 'MINUS'),
    ('left', 'LSHIFT', 'RSHIFT')
)

# Grammar definition

def p_statements(p):
    '''statements : statement
                  | statements statement'''
    p[0] = Statements(p[1:])

def p_statement(p):
    '''statement : expression SEMICOLON'''
    p[0] = Statement(p[1])

def p_expression_assign(p):
    '''expression : VARID EQUAL expression'''
    p[0] = AssignOp(p[1], p[3])

def p_expression_assign16(p):
    '''expression : VARID EQUAL EQUAL expression'''
    p[0] = AssignOp16(p[1], p[4])

def p_expression_output(p):
    '''expression : portdef EQUAL expression'''
    p[0] = OutputOp(p[1], p[3])

def p_expression_binop(p):
    '''expression : expression PLUS expression
                  | expression MINUS expression'''
    p[0] = BinOp(p[1], p[2], p[3])

def p_expression_16binop(p):
    '''expression : expression PLUS PLUS expression
                  | expression MINUS MINUS expression'''
    p[0] = BinOp16(p[1], ("%c%c" % (p[2],p[3])), p[4])

def p_expression_shiftop(p):
    '''expression : expression LSHIFT NUMBER
                  | expression RSHIFT NUMBER'''
    p[0] = ShiftOp(p[1], p[2], p[3])

def p_expression_term(p):
    '''expression : term'''
    p[0] = p[1]

def p_term_factor(p):
    'term : factor'
    p[0] = p[1]

def p_factor_num(p):
    'factor : NUMBER'
    p[0] = Number(p[1])

def p_factor_id(p):
    'factor : VARID'
    p[0] = VarID(p[1])

def p_factor_expr(p):
    'factor : LPAREN expression RPAREN'
    p[0] = p[2]

def p_factor_port(p):
    'factor : portdef'
    p[0] = InputOp(p[1])

def p_portdef(p):
    'portdef : PORT LBRACK NUMBER RBRACK'
    p[0] = p[3]

# Error rule for syntax errors
def p_error(p):
    print("Syntax error in input!")
    print(p)


# Build the parser
parser = yacc.yacc(debug=True)
machine = Machine()

if __name__=="__main__":
    if len(sys.argv) < 2:    
        # REPL (Read-Eval-Parse Loop):
        while True:
            try:
                s = input('eval> ')
            except EOFError:
                break
            if not s:
                continue
            result = parser.parse(s)
            result.eval(machine)
    else:
        try:
            f = open(sys.argv[1])
            program = f.read()
            result = parser.parse(program)
            result.eval(machine)
        except:
            exit(-1)
        



    