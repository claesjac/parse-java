#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

BEGIN { use_ok("Parse::Java::Interface"); }

$ENV{PARSE_JAVA_START_RULE} = "InterfaceDeclaration";
require Parse::Java;

my $ast = Parse::Java->parse_string(<<__END_OF_JAVA__);
public interface Quax {
}
__END_OF_JAVA__

isa_ok($ast, "Parse::Java::Interface");
isa_ok($ast->children->[0], "Parse::Java::Modifiers");

$ast = Parse::Java->parse_string(<<__END_OF_JAVA__);
interface Test <K> extends List, Queue<K> {
}
__END_OF_JAVA__

$ast = Parse::Java->parse_string(<<__END_OF_JAVA__);
interface Foo {
    public void bar();
    void quax();
}
__END_OF_JAVA__
isa_ok($ast, "Parse::Java::Interface");
is (scalar $ast->methods, 2);