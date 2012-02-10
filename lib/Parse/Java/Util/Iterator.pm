package Parse::Java::Util::Iterator;

use strict;
use warnings;

use Carp qw(croak);

use overload q{<>} => \&get_next;

sub new {
	my ($pkg, $code) = @_;
	
	return bless $code, $pkg;
}

sub get_next {
	my $self = shift;
	return $self->();
}

1;
__END__

=head1 NAME

Parse::Java::Util::Iterator - Utility-class representing an iterator

=cut