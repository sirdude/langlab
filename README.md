# Langlab   -- Language Lab

I've started a number of projects, and I continuously seem to come up with
new things to work on instead of finishing old projects.

I started out wanting to write my own programming language.  I got hung
up on the grammar and realized there were not a lot of tools to explore and
compare grammars of programming languages.  So this is a tool that attempts
to fill that gap.

Many of the tools out there throw away comments and whitespace in the name
of efficiency.  I want a tool that can eventually become a compiler but
will not throw anything away.  The idea being maybe this tool can be used for
other things, syntax highlighting or other things as well.

The goals of the language lab are to parse a language defined by a simple
version of bnf and report various things out about that language so that
we can compare languages and look for deficiencies in a grammar implementation.

Steps:
	Define the minimal bnf syntax/dialect in English
	Define our bnf syntax in itself.
	Write a tokenizer that works on our syntax.
	Write a parser for our syntax.
	Print out stats for our grammar.
	Load some other languages and compare.
	Identify ways to expand the program to do useful things:
		Identify sub sets.
		Identify troublesome constructs.


Stages for a useful tool:
	convert file to chars
	convert chars to tokens
	convert tokens to ast
	process ast and produce output
		(could be another ast or another file, or actions)

3 functions at each stage.
	read_input_from_previous_stage
	read_datafile_for_this_stage
	write_datafile_for_this_stage

If you do the following the output should be the same:
	read_datafile_for_this_stage, write_datafile_for_this_stage

	or

	read an input file working up to this stage and then write out
	the datafile for this stage, vs reading the datafile and then
	writing the datafile.
	

		

This code is released into the public domain, under the: CC0 License
If you are interested in contributing send me a note.  If you use this
code, I encourage you to improve it and release your work into the public
domain as well so we all can benefit.

				Kent Mein
				mein@umn.edu
