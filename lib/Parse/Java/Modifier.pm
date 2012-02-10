package Parse::Java::Modifier;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

sub modifier {
	return $self->children[0];
}

1;
__END__

=head1 NAME

Parse::Java::Modifier - Node representing an identifier

=cut