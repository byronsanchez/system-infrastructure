# notes

quick notes on the pki infrastructure

pki server
pki cas
pki clients

every node is a pki client. this means they get the base certs installed as well
as any other global pki-based file

some nodes are pki cas - eg. vpn. they get a private key signed by one of the
higher level CAs (system or user). types are denoted by the type variable passed
to the pki pattern

there is one pki server. it contains the systems and user private keys used to
sign all other certificates. it temporarily holds the root private key until the
system and user are created. then the root key is moved to offline media for use
in emergencies

pki cas aren't used to sign csrs. they COULD be, but the current infrastructure
aims at CA management from a single node. so the server will contain all the
keys used on the infrastructure while cas contain only the keys needed for its
application.

csrpuller components are only installed on the server. this could be a point of
extendability in the future if multiple accounts are ever needed to manage CAs
from different nodes

