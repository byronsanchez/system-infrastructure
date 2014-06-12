# notes

notes regarding my build pipeline

environments != servers

environments are different contexts a under which a working copy of an
application is operated on

these notes contain two components: descriptions of environments and description
of the build pipeline

## environments

I define three types of environments that are in the actual build pipeline. they
are development, staging and production

### Env: development

the development environment (in my case) is localized to workstations and is not part of
automated deployment. AKA, I can develop and view changes on my own without
having to push to a centralized server. in situations where software is
developed centralized, then the devel environment is obviously centralized and
there is a single codebase that devs work on simultaneously

one thing should be noted. the development environment is typically a
centralized working code copy used by companies to contain integrated code
committed by multiple developers. it is rapidly updated and has the most recent
changes. this centralized version is sometimes called an integration environment
too. yea, these terms aren't exactly used the same way by every person.

back to how i intend to use dev envs. vagrant will be used to create dev envs
that match staging and production (use the same os, configs, etc.).

docker MAY be used, more research ongoing

uses test databases

### Env: staging

mirrors production environment

uses complete independent copy of the production databases

### Env: production

the production environment will follow the master branch of git projects; this
is simply policy for tagging. in the jenkins build pipeline, the corresponding
build will be promoted to production.

uses production databases

### rolling back

be very careful with rollbacks

is the problem in the code? is a rollback possible (eg. database compatibility
is still in tact after a rollback?). a complete backup reversion may help,
however new data will be lost. choose wisely

if you can't rollback, use a hotfix. but before rolling back because of a
problem, be very aware of whether or not a rollback will cause even more
damage

## build pipeline

so I've mentioned how the environments play a role throughout the build
pipeline, but here is a clear description of the build pipeline itself

Develop on feature branches and then merge them to the development branch. Push
these changes to a repo that the CI server is tracking. the CI server will track
the development branch. Once it notices an update, the CI server will checkout
the latest revision, and run various operations. if all operations are
succesful, the application is then deployed to the staging server.

### commit

a commit is detected on the centralized development branch.
checkout head
prepares environments
compile code
run unit tests
run code quality analysis

if success, manual promotion to staging is possible.

### acceptance

occurs when staging promotion is triggered.

run functional tests (maybe move this to commit phase- depends on how long these
tests take)
deploy to a private testing server if needed
run gui tests
smoke tests
etc- whatever else is required in the context of the app being developed

### manual

if all the previous tests pass, the build is then deployed to a staging server
for manual testing. this is as far as automation goes.

### release

occurs when production promotion is triggered.

after manual testing, the application must be manually deployed to production
(by invoking the deploy command of course)

### deployment

deployment is done using ebuilds and tarballs. jenkins will package all the
necessary contents into a tarball and push that to a central application hosting
the repo of apps. then, installation is invoked depending on the environment
(staging or production). jenkins will invoke installation through mco on the
appropriate nodes.

this will invoke an emerge of the app on each of the nodes

distinguishing between staging and production for package installs? this depends
on how the client nodes are installing the apps. thus, it'd probably be best to
use overlays. i was also thinking keywords, but that seems like it could quickly
get confusing and would be a misuse of the stable vs unstable convention.

how to use overlays and manage them for different environments. a single overlay
and two different distfile sources? or two overlays, one for each environment.
Multiple overlays actually allows for testing the ebuilds as well, so multiple
overlays seems the way to go.

okay, so this is how it will go. if the staging promotion parts are successful,
everything is packaged and deployed to the staging directory of the central app
repo. installation is invoked on testing/staging nodes

manual sanity checks. if all good, manual promotion to production.

the tarball is deployed to the production directory of the central app repo.
installation is invoked on production nodes.

all tarballs are archived either with build number, version number, or both. the
build number is useful since it could give something like a unique id to the
build

### rollback implementation

prior to performing the actual installation/upgrade of an app, the ebuild will
invoke all necessary backup/dump commands.

quickpkg the prior version (if one exists, for idempotency), and store that
somewhere. ideally, get databases and everything in case you are performing any
sort of schema changes. this way, you can be sure that the rollback will work.

and then, if a rollback is necessary, unmerge the old package and install the
binary package

this rollback concept definitely needs improvement.

either way, the rollback mechanism should probably align with the portage way of
doing things

### sensitive data

regarding configuration files containing sensitive data

typically, for application, you'd isolate the sensitive data to a file and
gitignore that file. then you could use a number of different solutions to make
sure the values are available only for the machines or users that should have
them (eg. env vars). thus for the standard app, env vars can be a great solution

for configuration management, there are LOTS of sensitive files for lots of
different applications. to compound that, they may differ for each node!  I
managed to isolate all of them into either a secure directory or in hiera
configuration files

I'd LOVE for it to be okay to encrypt the file and commit them with a high level
of confidence that it can't be decrypted ever. I was looking at git-crypt for
this. This would make deployments SO much easier, since my CI server monitors my
git repos, checks out the code and builds deployment packages as necessary. it
looks like gpg support may be implemented, so that may be a plus.

I still don't know enough about encryption and cryptography to be comfortable
making this sort of decision, so I'll study a lot more on the topic and figure
out whether or not this is a solution I am willing to use. For now, I just
manually scp the sensitive data files to the necessary servers.

