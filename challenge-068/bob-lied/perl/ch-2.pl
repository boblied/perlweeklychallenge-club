#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu syntax=perl:

use strict;
use warnings;
use v5.16;

#############
package Node;

use Moo;

has val => (is => 'rw');
has next => (is => 'rw');

sub insert {
    my $self = shift;
    my $node = shift;
    $node->{next} = $self->{next};
    $self->{next} = $node;
    return $node;
}
sub remove {
    my $self = shift; 

    my $gone = $self->{next};
    $self->{next} = undef;
    return $gone;
}
sub length {
    my $self = shift;
    my $n = 1;
    my $p = $self;
    while ( $p = $p->next() ) { $n++ }
    return $n;
}

sub last
{
    my $self = shift;
    my $p = $self;
    while ( $p->next() ) { $p = $p->next() };
    return $p;
}

sub penultimate
{
    my $self = shift;
    my $p = my $prev = $self;
    while ( $p->next() )
    {
        $prev = $p;
        $p = $p->next;
    }
    return $prev;
}

##############
package main;

my @Input = @ARGV;

my $head = Node->new();

my $ptr = $head;
for my $n ( @Input )
{
    $ptr = $ptr->insert( Node->new(val => $n) );
}

sub showList
{
    my ($p) = @_;

    say "Length: ", $p->length();
    my $lst = $p->val();
    ($lst .= ", " . $p->val()) while ( $p = $p->next() );
    say "( $lst )";
}

showList($head->next());

if ( $head->next()->length() <= 2 )
{
    showList($head);
    exit 0;
}

my $fwd = $head->next();
my $bwd = $fwd->penultimate();
my $n = int($head->length() / 2);
while ( $fwd != $bwd )
{
    $bwd = $bwd->remove();
    $fwd = $fwd->insert($bwd)->next();
    $bwd = $fwd->penultimate();
}
showList($head->next());
