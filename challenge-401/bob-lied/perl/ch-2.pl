#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2026, Bob Lied
#=============================================================================
# ch-2.pl Perl Weekly Challenge 401 Task 2  Reconstruct Digits
#=============================================================================
# You are given a string containing an out-of-order English representation
# of digits 0-9.  Write a script to return the digits in ascending order.
# Example 1 Input: $str = "zroezerotwotwotwo"
#           Output: "00222"
# Example 2 Input: $str = "sveeneight"
#           Output: "78"
# Example 3 Input: $str = "onenineninefive"
#           Output: "1599"
# Example 4 Input: $str = "zeroonetwothreeeightfivesixsevenninefour"
#           Output: "0123456789"
# Example 5 Input: $str = "ninenineninenine"
#           Output: "9999"
#=============================================================================

use v5.44;


use Getopt::Long;
my $Verbose = false;
my $DoTest  = false;
my $Benchmark = 0;

GetOptions("test" => \$DoTest, "verbose" => \$Verbose, "benchmark:i" => \$Benchmark);
my $logger;
{
    use Log::Log4perl qw(:easy);
    Log::Log4perl->easy_init({ level => ($Verbose ? $DEBUG : $INFO ),
            layout => "%d{HH:mm:ss.SSS} %p{1} %m%n" });
    $logger = Log::Log4perl->get_logger();
}
#=============================================================================

exit(!runTest()) if $DoTest;
exit( runBenchmark($Benchmark) ) if $Benchmark;

say task($_) for @ARGV;

# Look for characters that are unique to a number. Eliminate the
# letters of the number. If we eliminate the even numbers first,
# then the odd numbers have unique characters, so do it in a
# specific order.
sub task($str)
{
state @NumberRecognition = (
    # digit  unique  letter
    [ 0,     'z',   [ qw(  e r o  ) ] ],
    [ 2,     'w',   [ qw(t   o    ) ] ],
    [ 4,     'u',   [ qw(f o   r  ) ] ],
    [ 6,     'x',   [ qw(s i      ) ] ],
    [ 8,     'g',   [ qw(e i   h t) ] ],
    [ 1,     'o',   [ qw(  n e    ) ] ],  # Unique after two and four gone
    [ 3,     'h',   [ qw(t   r e e) ] ],  # unique after eight is gone
    [ 5,     'f',   [ qw(  i v e  ) ] ],  # unique after four is gone
    [ 7,     's',   [ qw(  e v e n) ] ],  # unique after six is gone
    [ 9,     'i',   [ qw(n   n e  ) ] ],  # unique after five six and eight are gone
);
    my @num = ();
    for ( @NumberRecognition )
    {
        my ($digit, $unique, $letter) = $_->@*;

        # Count occurrences of the unique letter
        for ( 1 .. ($str =~ s/$unique//g) )
        {
            push @num, $digit;
            # Eliminate one occurrence of all the letters
            $str =~ s/$_// for ( $letter->@* );
        }
    }
    return join("", sort { $a <=> $b } @num);
}

sub runTest
{
    use Test2::V1 -ipP;

    is( task("zroezerotwotwotwo"),"00222", "Example 1");
    is( task(       "sveeeinght"),   "78", "Example 2");
    is( task(  "onenineninefive"), "1599", "Example 3");
    is( task("zeroonetwothreeeightfivesixsevenninefour"), "0123456789", "Example 4");
    is( task( "ninenineninenine"), "9999", "Example 5");

    done_testing;
}

sub runBenchmark($repeat)
{
    use Benchmark qw/cmpthese/;

    cmpthese($repeat, {
            label => sub { },
        });
}

