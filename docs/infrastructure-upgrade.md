The first iteration of the network infrastructure is almost complete. There is
obviously a lot of things that can and will be improved, and these will get
addressed over the next several years.

I wanted to outline information regarding the 2.0 upgrade.

The 2.0 upgrade has a single goal- to build a viable infrastructure for
location-independent professional software development. The current
infrastructure does this well enough, however I want to improve on what
currently exists, and this being my first attempt at managing an entire
infrastructure, I am sure I will learn lots of ways to improve the network.

Here are some current possible ideas. More will be added as I think of them. If
I decide to seriously pursue listed options, a new ticket will be created for
that task to track that task's progress.

Docker deployments for webapps - This is not set in stone at the moment. Docker
just had their 1.0.0 release a while ago and there are still many pain points in
terms of large scale deployments that will need to be solved (eg. how to manage
horizontal scaling of containers within a single host as well as across
multiple hosts while being able to serve content within each container over the
public internet AND how to manage communications between containers within a
host and across hosts). There are no simple answers to these challenges and
larger companies have been deploying their own solutions. Many want theirs to
be the defacto standard. When standard practices begin to become clear, and
whether or not docker proves to be a long-term solution for deployments, will
be seen in the future. This all needs to be kept in mind for the 2.0 upgrade of
the network.

Segmented Network - There must be a segmented network setup. There would be a
demilitarized zone containing nodes that should be accessible over the public
internet, and a private network that will not be accessible over the public
internet. This DMZ will be used for actually hosting, in-house, all the webapps
developed on the network (at least my own ventures; if I end up pursuing
building a client-base, I will probably give them a choice of in-house hosting,
or cloud hosting via a third-party service).

Data Mining - There must be organized data mining for all nodes throughout the
network. This will begin with centralized logging and good log analysis. This
will expand as needed, introducing analytics for webapps and will ideally
evolve into useful tooling for improving each of the developed applications.

