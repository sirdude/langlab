This is a fresh start at a new programming language.

The goal of this project is to define a minimal ultimate language,
designed in itself and documented.
write a bootstrapper in perl.
Then extend it to be more robust, through its own language.
Figure out how to support objects, processes, vms, interpreters?
and or other abstracted structures

I've combined all of the stuff from my other projects into this one repository.
Right now its still a little bit of a mess and needs some organization.
There are a bunch of half done things and lots of notes.

Current status is I am working on stage 3 still(see docs/stages.txt) and I am
getting frustrated working in perl trying to figure out
things like how do I compare hashes that have nested structures in them, and
indexing these deep structures is also not very fun.
Originally I was trying to avoid perl modules so that I would only depend on code that
I actually wrote but again I'm getting frustrated.  I had started working on stage 4
because I feel I am far enough along on stage 3 that I can work on trying to actually 
produce some output with our code.
That is still a work in progress but I also want to start working on stage 5.

I think its time to rewrite the bulk of the code in our new language so I can actually 
evaluate if what I'm doing is good or if it still needs work.  Moving forward I'll be
working on both stages with the goal being as soon as both of them are done, I will write
a translator of our new language to c.

If I can get all of that done I'll be able to start using my new language moving forward and
continue to develop code in the new language.  While this is still a ways off I do feel this
is quickly approaching something I can accomplish.

Because of all of this, I have made 2 subdirectories perl and sweet.
perl contains the current binaries, tests and libraries.
sweet will contain the same things written in our new language.
When I get there I'll make a third directory c that will contain the translated code.
For the time being perl is still where the active work is being done but sweet will be the
future version of the same thing.

If this interests you and you want to contribute or just ask me questions please reach out to me.

Kent Mein
mein@umn.edu
