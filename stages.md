# PACT Compiler Stages

This document describe possible stages that get composed together into a
compiler.

## Factories

We may wish to provide factory objects that the core stages use to build
PACT nodes so that HLLs can specific default option or alter nodes at
create to inject custom classes.

## Available Stages

First the obviously needed stages:

* *PAST to POST*: Generates POST tree from PAST
* *POST to CFG*: Generates CFG from POST tree
* *CFG to PIR*: Generates PIR for a given CFG
* *CFG to PBC*: Creates a packfile from a CFG.

Additional stages:

* *NQP Grammar*: Uses NQP's grammar/action classes to generate PACT tree
  from source.
* *Pattern Matcher*: See Tree::Pattern and Tree::Walker<br />
  Calls a method when a given pattern matches in a PACT tree.


### Debug
  
Prints type of each node before passing to wrapped stage.  Design of this
stage drives some general questions about stages.  Should this do some kind
of runtime subclassing of the wrapped stage?  Should we pass the visitor to
each visit function to enable easy chaining?
