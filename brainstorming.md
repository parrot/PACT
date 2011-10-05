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

Use factories to build nodes?  Allows users to specify default options for various types of node, or to hijack some types into others.  (Build HLL's Integer class instead of Parrot's, for instance.)
