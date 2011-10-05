## Compiler object

registered via compreg.

PACT::Compiler has PDD31 functions

* compile runs a set of PACT::Stages
* target is based on 'output' tag of stage
* module functions throw NYI

PACT::ModuleCompiler adds default module handlers ala PCT::HLLCompiler

----------

## PACT::StageRunner

(see Tree::Optimizer)

stages() gets/sets a RPA of Stages

does _not_ provide add/remove stage functions

provides compile() function

Compiler isa StageRunner that adds eval, etc.

----------

## PACT::Stage

name, input, output

input/output are string tags describing input or output

* not class type, so that it can carry semanitic information

visit methods: visit(visitor, node)

Used by s = stage.new(options); s.visit(code)

default visit(PACT::Node) iterates over children

* sets children to return values

default visit(_) returns node

----------

## PACT::DebugStage: Prints type of each node before passing to wrapped stage

Runtime subclass of stage?  Pass top level visitor to visit function?

----------

## PACT::PatternStage: Walks tree and calls method when pattern matches

See Tree::Pattern/Tree::Walker

----------

## PACT::NQPGrammar: Uses NQP Grammar/Action structure to generate PAST

----------

## Stages of compilation

Currently: Parse - PAST - POST - PIR

Want: Parse - PAST - POST - Register Alloc/Etc - PIR/Bytecode

POST = Control Flow Graph?

Keep tree structure until very late, let a single register allocator deal with flattening.

----------

## PACT from the Bottom Up

One of the motivations for PACT is the hoops needed to move POST from generating PIR to generating bytecode.  Much of the information that would be useful at the bytecode level has been converted to text before it got to POST.  So I'm trying to consider PACT starting from square one: what actually runs on the VM.

* Build a set of classes that mirror packfile layout.
    * Populated with PACT classes like Sub, Op, etc instead of PackfileConstantTable
* Make that able to produce bytecode and PIR
    * Register allocation
    * Stage structure
* Build assembly language on top of that
    * assembler and disassembler
* Build control-flow graph IR
* Build tree-like POST (optional, POST may only be CFG level)
* Build PAST
* Build simple language that exposes PAST very directly (or convert existing)

Share as much across layers as possible.  Maintain as much type information as possible.

After that, start building top-down.  Add features to PAST and see if any additional POST/CFG/bytecode features are needed to support it.

----------

## PACT::Node: Base node type

* type information (VINSP, class if P)
    * class information optional
    * At very low level, all ops will be V
    * How to handle ops that have multiple return types?
* children
* source location (file/pos)
* name

----------

SymbolTable? Statement?  Scope?  Want, coersions?

Use factories to build nodes?  Allows users to specify default options for various types of node, or to hijack some types into others.  (Build HLL's Integer class instead of Parrot's, for instance.)
