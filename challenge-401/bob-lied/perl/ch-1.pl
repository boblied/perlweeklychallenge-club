#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2026, Bob Lied
#=============================================================================
# ch-1.pl Perl Weekly Challenge 401 Task 1  Fractional Addition Subtraction
#=============================================================================
# You are given a string representing an expression of fraction addition
# and substraction.  Write a script that returns the calculation result of
# given expression in string format. If final result is an integer, change
# it to the format of fraction that has a denominator 1.
# Example 1 Input: $expr = "1/2+3/2"
#           Output: "2/1"
# Example 2 Input: $expr = "-5/2-3/2"
#           Output: "-4/1"
# Example 3 Input: $expr = "5/3-5/3"
#           Output: "0/1"
# Example 4 Input: $expr = "10/10-1/10+2/5"
#           Output: "13/10"
# Example 5 Input: $expr = "1/6+1/6+1/6"
#           Output: "1/2"
#=============================================================================

use v5.44;


use Getopt::Long;
my $Verbose = false;
my $DoTest  = false;

GetOptions("test" => \$DoTest, "verbose" => \$Verbose);
my $logger;
{
    use Log::Log4perl qw(:easy);
    Log::Log4perl->easy_init({ level => ($Verbose ? $DEBUG : $INFO ),
            layout => "%d{HH:mm:ss.SSS} %p{1} %m%n" });
    $logger = Log::Log4perl->get_logger();
}
#=============================================================================

exit(!runTest()) if $DoTest;

# Eliminate everything except digits and operators
say task( s![^0-9/+-]!!gr ) for @ARGV;

#=============================================================================
sub task($expr)
{
    use List::Util  qw/any product sum/;
    use Math::Utils qw/gcd/;

    # Isolate the numbers surrounding / with optional negative
    my @f = $expr =~ m/(-?\d*)\/(-?\d+)/g;

    # Numbers are in pairs, even -> numerators, odd -> denominators
    die "Syntax error" if @f == 0 || @f % 2; 
    my @n = @f[ map { $_* 2     } 0 .. $#f/2 ];
    my @d = @f[ map { $_* 2 + 1 } 0 .. $#f/2 ];

    die "Division by 0" if any { $_ == 0 } @d;

    # A Real Programmer(TM) would check for overflow
    my $denominator = product(@d);

    my $numerator = sum( map { $n[$_] * $denominator/$d[$_] } 0 .. $#n );

    return "0/1" if $numerator == 0;

    # Conventional form puts a negative sign on the numerator
    if ( $denominator < 0 )
    {
        $denominator *= -1;
        $numerator   *= -1;
    }
    
    my $gcd = gcd($numerator, $denominator);
    return $numerator/$gcd ."/". $denominator/$gcd;
}

sub runTest
{
    use Test2::V1 -ipP;

    is( task(       "1/2+3/2"),   "2/1", "Example 1");
    is( task(      "-5/2-3/2"),  "-4/1", "Example 2");
    is( task(       "5/3-5/3"),   "0/1", "Example 3");
    is( task("10/10-1/10+2/5"), "13/10", "Example 4");
    is( task(   "1/6+1/6+1/6"),   "1/2", "Example 5");
    is( task(      "5/-3+4/3"),  "-1/3", "One negative denominator");
    is( task(     "5/-3+4/-3"),  "-3/1", "Two negative denominators");

    done_testing;
}
