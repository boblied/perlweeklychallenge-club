#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu syntax=perl:
#
# A strobogrammatic number is a number that looks the same when looked at upside down.
# You are given two positive numbers $A and $B such that 1 <= $A <= $B <= 10^15.
# Write a script to print all strobogrammatic numbers between the given two numbers.
# Example
#
# Input: $A = 50, $B = 100
#    Output: 69, 88, 96

use strict;
use warnings;
use v5.30;

my ($A, $B) = @ARGV[0,1];

die "Missing A".usage() unless $A;
die "Missing B".usage() unless $B;

die "A out of range" unless $A >=1 && $A <= 10E15;
die "B out of range" unless $B >=1 && $B <= 10E15;

die "A > B" unless $A <= $B;

my @SmallStrobo = ( 0, 1, 8, 11, 69, 88, 96 );

# Handle easy cases easily
if ( $B < 100 )
{
    grep { $_ >= $A } @SmallStrobo;
}

# From the number of digits in A and B, we can determine the upper and
# lower bounds on the size of possible results.

my $minDig = length($A);
my $maxDig = length($B);

# Build a string from the inside out.  Pick one or a pair of center digits
# and then add combinations to each end.

my @Strob;
$Strob[0] = 0;
$Strob[1] = 1;
$Strob[6] = 9;
$Strob[8] = 8;
$Strob[9] = 6;

sub enStrob
{
    my ($seed, $dig) = @_;
}

for my $seed ( @SmallStrobo )
{
    for my $dig (0 1 6 8 9)
    {
        $seed = enStrob($seed, $dig
    }
}
