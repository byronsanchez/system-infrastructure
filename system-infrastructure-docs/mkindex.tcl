#!/usr/bin/env tclsh
#
# Run this TCL script to generate a MD page that contains a
# permuted index of the various documentation files.
#
#    tclsh mkindex.tcl [> doc-index.md]
#

set doclist {
  backups.md {Backups}
  binhost.md {Binhost}
  bugs.md {Bugs}
  ci.md {Continuous Integration}
  id.md {User ID Mappings}
  infrastructure-design.md {Infrastructure Design}
  infrastructure-upgrade.md {Infrastructure Upgrade}
  memory.md {Memory Allocations}
  names.md {Node Naming Convention}
  nas.md {NAS}
  pki.md {Public Key Infrastructure}
  puppet.md {Configuration Management with Puppet}
  replication.md {Replication}
  ssh.md {Secure Shell}
  updates.md {Update Guide for Node on the Network}
  versions.md {Versioning Policies}
  vpn.md {VPN}
  workstations.md {Workstations}
}

set permindex {}
set stopwords {
   a about against and are as by for fossil from in of on or should the to use
   used with
}
foreach {file title} $doclist {
  set n [llength $title]
  regsub -all {\s+} $title { } title
  lappend permindex [list $title $file 1]
  for {set i 0} {$i<$n-1} {incr i} {
    set prefix [lrange $title 0 $i]
    set suffix [lrange $title [expr {$i+1}] end]
    set firstword [string tolower [lindex $suffix 0]]
    if {[lsearch $stopwords $firstword]<0} {
      lappend permindex [list "$suffix &mdash; $prefix" $file 0]
    }
  }
}
set permindex [lsort -dict -index 0 $permindex]
set out [open permutedindex.html w]
fconfigure $out -encoding utf-8 -translation lf
puts $out \
"<div class='fossil-doc' data-title='Index Of Documentation'>"
puts $out {
<center>
<form action='$ROOT/docsrch' method='GET'>
<input type="text" name="s" size="40" autofocus>
<input type="submit" value="Search Docs">
</form>
</center>
<h2>Primary Documents:</h2>
<ul>
<li> <a href='../README.md'>README.md</a>
<li> <a href='../COPYRIGHT.md'>Copyright Information</a>
<li> <a href='../COPYING'>License</a>
</ul>
<a name="pindex"></a>
<h2>Permuted Index:</h2>
<ul>}
foreach entry $permindex {
  foreach {title file bold} $entry break
  if {$bold} {set title <b>$title</b>}
  if {[string match /* $file]} {set file ../../..$file}
  puts $out "<li><a href=\"$file\">$title</a></li>"
}
puts $out "</ul></div>"
