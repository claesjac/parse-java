package Parse::Java::LazyNode;

use strict;
use warnings;

use Carp qw(croak);

use Scalar::Util qw(refaddr);

my %Loaded;
sub _loaded {
	my $self = shift;
	
	if ( @_ ) {
		$Loaded{refaddr $self} = shift;
	}
	
	return $Loaded{refaddr $self} || 0;
}

sub _load {
	my $self = shift;
	$self = ref $self || $self;
	croak "Class '$self' does not override _load()";
}

sub DESTROY {
	my $self = shift;
	delete $Loaded{refaddr $self};
}

1;
__END__

=head1 NAME

Parse::Java::LazyNode - Mixin-class for nodes that do lazy loading

=cut