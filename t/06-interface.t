#!/usr/bin/perl

use strict;
use warnings;

use Test::More qw(no_plan);

BEGIN { use_ok("Parse::Java::Interface"); }

require Parse::Java;

{   
    my $doc = Parse::Java->parse_string(<<__END_OF_JAVA__);
public interface Quax {
}
__END_OF_JAVA__

    isa_ok($doc, "Parse::Java::Document");
    
    my $if = ($doc->types)[0];
}