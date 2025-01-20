#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu syntax=perl:

use strict;
use warnings;
use v5.14;

use Data::Dumper;

my ($M, $N) = @ARGV;

say "M: $M, N: $N";

sub printM
{
    my ($matrix) = @_;

    say '[ ', join(',', @{$matrix->[$_]}), ' ]' for 0..scalar(@$matrix)-1;
}

# Create an MxN array randomly filled with 0 and 1

my @Matrix;
for my $m ( 0..$M-1 )
{
    $Matrix[$m] = [ map { int(0.9+rand()) } 1..$N ];
}

#say Dumper(\@Matrix);
say "BEGIN WITH: "; printM(\@Matrix);

my (%zeroRow, %zeroCol);
for my $row ( 0..$M-1 )
{
    for my $col ( 0..$N-1 )
    {
        if ( $Matrix[$row][$col] == 0 )
        {
            $zeroRow{$row}++;
            $zeroCol{$col}++;
        }
    }
}

my @NewMatrix;
for my $row ( 0..$M-1 )
{
    if ( $zeroRow{$row} )
    {
        $NewMatrix[$row] = [ (0) x $N ];
    }
    else
    {
        $NewMatrix[$row] = [ @{$Matrix[$row]} ];
    }
}

for my $col ( 0 ..$N-1 )
{
    if ( $zeroCol{$col} )
    {
        $NewMatrix[$_][$col] = 0 for 0..$M-1
    }
}

say "END WITH:"; printM(\@NewMatrix);
