package Parse::Java::TypeDecl;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

sub modifiers {
	my $self = shift;
	
	return $self->children_with(isa => 'Parse::Java::Token::Modifier');
}

1;
__END__

=head1 NAME

Parse::Java::Type - Description

=cut