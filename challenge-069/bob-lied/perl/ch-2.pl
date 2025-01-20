#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu syntax=perl:

package StrFunc;

use strict;
use warnings;
use v5.16;

sub reverse
{
    my @s = split(//, $_[0]);
    return CORE::reverse(@s);
}

sub switch
{
    my @s = split(//, $_[0]);
    return join("", map { $_ == 0 ? 1 : 0 } @s );
}

package main;

my $N = $ARGV[0] || 4;

my @S;
my $sn1 = "0";
my $sn;

for my $n (2..$N)
{
   $sn = "${sn1}0";
   my $rev = StrFunc::reverse($sn1);
   my $sw  = StrFunc::switch($rev);
   $sn .= $sw;

   $sn1 = $sn;
}

#say $sn;
say length($sn);
