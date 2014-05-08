# notes

regarding versioning of interpretters

production systems will not use versioning tools. they will use the package
manager to manage interpretters. a node will contain one primary interpretter as
opposed to using multiple interpretter versions. an application using a version
will be deployed to the node whose main interpretter is that version.
dependencies will be installed in application-specific directories

devel systems can run multiple versions of an interpretter concurrently using
tools like rvm and nvm

the ci server must be able to isolate dependencies per application. this can be
achieved with versioning tools and by intentionally installing dependencies in
application-specific directories. I think I'll implement this using rvm for
ruby. nvm may be helpful, but node dependencies are installed in
application-specific directories by default
