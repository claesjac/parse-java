package Parse::Java::Document;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

sub package {
    return shift->first_child_of_type("Parse::Java::PackageDecl");
}

sub imports {
    return shift->children_with({isa => "Parse::Java::ImportDecl"});
}

sub types {
    return shift->children_with({isa => "Parse::Java::TypeDecl"});
}

1;
__END__

=head1 NAME

Parse::Java::Document - Description

=cut