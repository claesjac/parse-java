#!/usr/bin/perl

use strict;
use warnings;

use Test::More skip_all => "Parser can't handle class body atm";

BEGIN { use_ok("Parse::Java::Document"); }

require Parse::Java;

my $doc = Parse::Java->parse_string(<<__END_OF_JAVA__);
package Foo;

import Bar;
import static Foo.Bar.*;

public class Quax {
}

class PrivateQuax {
}
__END_OF_JAVA__

isa_ok($doc, "Parse::Java::Document");
isa_ok($doc->package, "Parse::Java::PackageDecl");
is($doc->package->identifier, "Foo", "Package is 'Foo'");

my @imports = $doc->imports;

is(scalar @imports, 2, "Got two imports");

my $import = shift @imports;
is ($import->identifier, "Bar", "First import for 'Bar'");
ok (!$import->is_static_import, "Import isn't static");

$import = shift @imports;
is ($import->identifier, "Foo.Bar.*", "Second import for 'Foo.Bar.*'");
ok ($import->is_static_import, "Import is static");

my @types = $doc->types;
is (scalar @types, 2, "Got two types");

my $type = shift @types;
is ($type->name, "Quax", "First type is Quax");

$type = shift @types;
is ($type->name, "PrivateQuax", "Second type is PrivateQuax");
