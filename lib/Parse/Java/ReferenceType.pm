package Parse::Java::ReferenceType;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Type);

use overload q{""} => \&as_string;

sub identifier {
	my $self = shift;
	
	my @identifiers = grep { $_->isa('Parse::Java::Identifier') } @{$self->children};
	return join(".", @identifiers);
}

sub as_string {
	my $self = shift;
	return $self->identifier;
}
1;
__END__

=head1 NAME

Parse::Java::ReferenceType - Description

=cut