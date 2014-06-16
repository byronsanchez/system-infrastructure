#!/bin/sh
#
# Run this TCL script to generate a md page that contains a regular and permuted 
# index of the various documentation files.
#
#    tclsh mkindex.tcl > doc-index.md
#

set doclist {
  backups.md {Backups}
  binhost.md {Binhost}
  ci.md {Continuous Integration}
  memory.md {Memory Allocations}
  names.md {Node Naming Convention}
  network.md {Infrastructure Design}
  pki.md {Public Key Infrastructure}
  puppet.md {Configuration Management with Puppet}
  replication.md {Replication}
  ssh.md {Secure Shell}
  updates.md {Update Guide for Node on the Network}
  versions.md {Versioning Policies}
  vpn.md {VPN}
}

set permindex {}
set regularindex {}
set stopwords {and a in of on the to are about used by for or}
foreach {file title} $doclist {
  set n [llength $title]
  regsub -all {\s+} $title { } title
  lappend permindex [list $title $file]
  lappend regularindex [list $title $file]
  for {set i 0} {$i<$n-1} {incr i} {
    set prefix [lrange $title 0 $i]
    set suffix [lrange $title [expr {$i+1}] end]
    set firstword [string tolower [lindex $suffix 0]]
    if {[lsearch $stopwords $firstword]<0} {
      lappend permindex [list "$suffix &mdash; $prefix" $file]
    }
  }
}
set permindex [lsort -dict -index 0 $permindex]
set out stdout
fconfigure $out -encoding utf-8 -translation lf
puts $out "#Documentation Index"
puts $out {
##Main Docs:

  - [License](../COPYRIGHT.md)

##Regular Index:
}

foreach entry $regularindex {
  foreach {title file} $entry break
  puts $out "  - \[$title\]($file)"
}

puts $out {
##Permuted Index:
}

foreach entry $permindex {
  foreach {title file} $entry break
  puts $out "  - \[$title\]($file)"
}
