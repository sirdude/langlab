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
other things, stats about code, syntax highlighting or other things as well.

The goals of the language lab is to make it easy to explore and create
a computer langage, making it easy to modify it and to help you evaluate
your changes.

Steps associated with a compiler:
	Define our language.	
	Read in a file and convert it to a tree of chars.
	Convert a tree of chars and convert to tokens.
	Convert tokens to an AST.
	Preform some actons on the AST.
	Output results.


Steps for this project.
	Define our bnf syntax/dialect in English: (grammar.txt)
	Define our bnf syntax in itself: bnf.bnf
	Write a file reader.
	Write a tokenizer that works on our syntax.
	Write a parser for our syntax.
	Print out stats for our grammar.
	Put it all togeather and make a meta parser.
		(Read in our langauge file and output our parser from it.)
		(Show that we can change the langage by changing the file and
		 running the prevous parser on our new file.)
	Load some other languages and compare.
	Identify ways to expand the program to do useful things:
		Identify sub sets.
		Identify troublesome constructs.


Stages for our tool: 01input.pl, 02token.pl, 03astwrite.pl,
	04output.pl, 04stats.pl

	Each stage needs the following:
		read and write current stage files.
		write next stage input.
		defined datastructures.

	01input.pl: read in blah.bnf
		write blah_new.bnf
		write blah.chr
		datastructures used: hash of definitions, chr tree
	02token.pl: read blah.chr
		write blah_new.chr
		write blah.ast
		datastructures used: chr tree, ast tree
	03astwrite.pl: read blah.ast
		write blah_new.ast
		write blah.opt
		datastructures used: ast tree, output_ast tree
	04output.pl: read blah.opt
		write blah_new.opt
		write input.pl, tokenizer.pl astwriter.pl, output.pl, stats.pl
		datastructures used: hash of definitions, output_ast tree
	04stats.pl: read blah.opt
		write blah_new.opt
		write stats.txt
		datastructures used: output_ast tree

To get started using it run:
perl ./template/04output.pl grammar/bnf.bnf
That should create the inital scripts.  Documentation on workflow will come
later once things are more fleshed out.
		
This code is released into the public domain, under the: CC0 License
If you are interested in contributing send me a note.  If you use this
code, I encourage you to improve it and release your work into the public
domain as well so we all can benefit.

				Kent Mein
				mein@umn.edu
