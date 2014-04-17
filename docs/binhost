It's best to use binpkg-respect-use=y unless you are ABSOLUTELY sure your nodes
will conform to the same USE flags.

This is because if there are deviations, nodes should be able to build their own
packages. Ideally, the binhost would build different versions of the package and
the nodes on the network would simply install them, however this is not
possible. So it is up to the nodes to build their own packages if the binhost
cannot provide a matching package with corresponding use flags.

An example.

If the binhost has a php package available to distribute without the fpm use
flag, and a node expects to provide the fpm service, it is critical that instead
of installing the fpm-less package (binpkg-respect-use=n), the node should build
its own version of the php package with fpm enabled.
