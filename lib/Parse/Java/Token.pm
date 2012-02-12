package Parse::Java::Token;

use strict;
use warnings;

use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw(value line_no column));

use overload q{""} => \&to_string, fallback => 1;

sub to_string {
	my $self = shift;
	return $self->value;
}

sub significant {
	return 0;
}

1;
__END__

=head1 NAME

Parse::Java::Token - Description

=cut