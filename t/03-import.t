#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);
use Test::More qw(no_plan);

use Parser::Java;

my $parser = Parser::Java->new(start => "parse_imports");
my $ast = $parser->from_string("import foo;");
is_deeply($ast, [{import => "foo"}]);

$ast = $parser->from_string("import static foo.bar;");
is_deeply($ast, [{import => "foo.bar", static => 1}]);

$ast = $parser->from_string("import foo.bar.*;");
is_deeply($ast, [{import => "foo.bar.*"}]);

$ast = $parser->from_string("import foo; import bar;");
is_deeply($ast, [{import => "foo"}, {import => "bar"}]);
