# 4-perf

"4-perf" refers to a film frame that fits 4 sprocket holes on 35mm film strip. It is the biggest and most
luxurious frame format.

## Ghwut?

This is a very tiny example Rack application to see when/whether Sprockets 4 finally can do all the stuff that it
has to be doing, sans Rails. Things that will be evaluated:

* SCSS with source maps
* CoffeeScript with source maps
* Babel with source maps
* Compilation of all of the above, with source maps

It is handled in the most manual way possible to demonstrate all the bizarro motions we potentially might
have to go through to make it work.

The goal is to discover what it doesn't do yet, and to dicsover it ASAP before trying to implement this in a live
situation.

## Caveats

Sprockets 4 was merged into master just 2 weeks ago as of this writing. This means there will invariably be
bugs. The Gemfile here links to a specific SHA in Sprockets to make sure we are "talking about the same thing"
so to speak.