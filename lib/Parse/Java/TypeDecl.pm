package Parse::Java::TypeDecl;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

sub modifiers {
	my $self = shift;
	
	return $self->children_with(isa => 'Parse::Java::Token::Modifier');
}

sub body {
    shift->first_child_of_type("Parse::Java::InterfaceBody");
}

1;
__END__

=head1 NAME

Parse::Java::Type - Description

=cut