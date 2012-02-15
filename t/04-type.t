#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

use Parser::Java;

my $parser = Parser::Java->new(start => "parse_type");

for my $type (qw(byte short char int long float double boolean)) {
    my $ast = $parser->from_string($type);
    is_deeply($ast, { type => $type });
}

my $ast = $parser->from_string("Foo");
is_deeply($ast, { type => "Foo" });

$ast = $parser->from_string("Foo<String>");
is_deeply($ast, { type => "Foo", args => [{ type => "String" }] });

$ast = $parser->from_string("Foo<? extends String>");
is_deeply($ast, { type => "Foo", args => [{ type => "String", extends => 1 }] });

$ast = $parser->from_string("Foo<? super String>");
is_deeply($ast, { type => "Foo", args => [{ type => "String", super => 1 }] });

$ast = $parser->from_string("Foo<String>.Bar<Long, Double>");
is_deeply($ast, { 
    type => "Foo", 
    args => [{ type => "String" }], 
    subtype => { 
        type => "Bar", 
        args => [{ type => "Long" }, {type => "Double"}],
    }
});

$ast = $parser->from_string("Foo[]");
is_deeply($ast, { type => "Foo", dimensions => 1 });

$ast = $parser->from_string("Foo[][][]");
is_deeply($ast, { type => "Foo", dimensions => 3 });
