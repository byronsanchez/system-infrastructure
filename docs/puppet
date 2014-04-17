This is something that has tripped me up in the past and I want to write it down
to embed this in my memory.

With puppet, don't worry about conforming to the best standards. It's better to
organize your manifests and modules and environments to fit YOUR environment.
When you're just starting out, especially, it can be confusing to find a
"standard approach" much like you can find for other tech stacks.

This is because network infrastructures vary significantly. You may have a
tiered network in an enteprise environment managing hundreds of nodes, or you
may be managing tens or less in a much smaller environment.

The requirements for each infrastructure will vary significantly. It's best to
build SOMETHING that works for your environment, and learn puppet that way,
rather than to stall trying to find the best directory structure and never
implementing anything.

You can always refactor little by little the more you learn.

The strucure I am going to try to build is the one written about in AGLARA:

- modules for building blocks
- patterns for common configurations (patterns use modules)
- nodes use patterns to build the final environment for that node

My own implementation may or may not significantly end up following this 
structure, but the ultimate goal is for it to develop and evolve so that
it best fits my use case in a way that is organized and reusable.

