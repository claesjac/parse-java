package Parse::Java::ImportDecl;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

sub identifier {
    my $self = shift;
    return $self->first_child_of_type("Parse::Java::Identifier");
}

sub is_static_import {
    my $self = shift;    
    my ($static_modifier) = $self->first_child_of_type("Parse::Java::Token::Modifier");
    return defined $static_modifier;
}
1;
__END__

=head1 NAME

Parse::Java::Type - Description

=cut