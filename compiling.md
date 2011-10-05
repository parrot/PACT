# PACT Compiler Structure

This document describes the "action" half of PACT, the parts responsible
for converting PACT trees from one format to another.

There are several references from this document to the [tree-optimization
project](https://github.com/parrot/tree-optimization).  The design of the
stage system was intended to be similar to that of tree-optimizer.



## Stage

A stage is a single transformation of a PACT tree.  It has a name, input
and output tags, and a new and visit methods.  Given a stage, options, and
a tree, they are intended to be used as follows:

	s = stage.new(options)
	tree = s.visit(tree)

A stage should generally leave the passed in tree intact, so that other
trees can share common sub-trees.

The name of the stage should be human recognizable but simple enough to use
as command line arguments (perhaps something like
`--stage=optimizer=agressive`)

The input and output tags are strings describing the input and output
trees.  Generally this describes a phase of compilation such as "source",
"lex", "past", "post", "pir", etc. so the corresponding class could be used
(e.g. PAST::Node), but a string is used so that arbitrary semantic
information can be attached.  These tags serve two purposes: sanity testing
a stream of stages, and allowing the user to stop output at arbitrary
points.  (Perhaps this should standardized to an array of strings.)

Stages are generally passed around as a kind of proto-object.  Fresh stages
are created at each usage so that object attributes can be used for
context during the stage.  The `new` method is used to get a fresh object
for each use of the stage.

Stages should, wherever possible, be able to start from any size of tree so
that different portions of a tree can be run through different stages and
spliced together.  To enable extensibility, stages should be as lenient as
possible about unknown node types in the tree, passing them through
unmolested when possible.

Some default visit methods may be:

	method visit(PACT::Node node) {
		Array children;
		for n in node.children {
			children.push(visit(n));
		}
		return node.clone().set_children(children)
	}

	method visit(var node) {
		return node;
	}



## Stage Runner

(see Tree::Optimizer)

Contains an array of stages to run.  Performs basic sanity checks like
comparing the input and output adjacent stages.  Provides the `compile`
function from PDD31, including options of stopping at a given phase or at a
kind of output.  (The `target` option from PDD31 likely refers to the
output tag from a stage.)

This class likely will _not_ provide convenience methods for adding and
removing stages, preferring to provide access to the underlying array.



## Compiler

This class provides the full compiler API from PDD31.  It inherits from the
stage runner class, and uses it's compile function to implement eval.  The
module functions (`parse_name`, `load_module`, `get_module`, and
`get_exports`) will throw an exception with a "Unimplemented" message.  New
HLLs will be expected to override these defaults.  A convenience subclass
that implements the default module handling from `HLL::Compiler` will
likely be available.



## REPL

Given a Compiler object, this class handles maintaining an outer context,
interacting with the user, printing results, and catching exceptions.  Each
major portion of this should be abstracted into a method for easy
subclassing.



## Command Line

Given a Compiler object, this class performs some basic command line option
handling, passing options to stages, target to the compiler, saving the
output to a file, etc.  Again, highly separated into methods for easy
extensibility.
