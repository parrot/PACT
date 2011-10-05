# PACT TODO List

## Short Term

* Clean up brainstorming into real design docs
* But don't get caught up designing things we aren't implementing
* Build framework: Makefile, test harness, etc
* Sketch (design and/or code) out lowest level compiler

## Long Term

One of the main motivations of PACT is generating bytecode.  Instead of
starting at the top and trying to ensure we keep everything we'll need
around, starting from the bytecode and working our way up seems far more
useful.  The implementation plan looks a little like this:

* Build a set of classes that mirror packfile layout.
	* Populated with PACT classes like Sub, Op, etc instead of
	  PackfileConstantTable
* Make that able to produce bytecode and PIR
    * Register allocation
    * Stage structure
* Build assembly language on top of that
    * assembler and disassembler
* Build control-flow graph IR
* Build tree-like POST (optional, POST may only be CFG level)
* Build PAST
* Build simple language that exposes PAST very directly (or convert existing)

Share as much across layers as possible.  (We want only one
implementation/type for things like registers, variables, symbol
tables, location information, etc.)

Maintain as much type information as possible.  If we start off with an
integer constant, remember that all the way down to the bytecode.

After that, start building top-down.  Add features to PAST and see if any
additional POST/CFG/bytecode features are needed to support it.
