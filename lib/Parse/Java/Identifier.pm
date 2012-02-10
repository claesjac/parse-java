package Parse::Java::Identifier;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Node);

use overload q{""} => \&as_string, fallback => 1;

sub identifier {
	my $self = shift;
	my @segments = grep { $_->isa('Parse::Java::Token::Identifier') } @{$self->children};;
	return join(".", @segments);
}

sub as_string {
	my $self = shift;
	return $self->identifier;
}

1;
__END__

=head1 NAME

Parse::Java::Identifier - Node for representing identifiers

=head1 DESCRIPTION

An identifer is a the name of something like a class, a member variable, a package and so forth. 

Identifiers can be either a single word or built up from several separated by a dot.

=head1 INTERFACE

=head2 INSTANCE METHODS

=over 4

=item identfier

Returns a stringified representation of the identifier.

=back

=cut