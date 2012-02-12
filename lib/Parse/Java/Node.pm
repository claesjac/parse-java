package Parse::Java::Node;

use 5.010;
use strict;
use warnings;

use List::Util qw(first);

use Parse::Java::Util::Iterator;

use base qw(Parse::Java::Element);

use overload q{""} => \&to_string;

__PACKAGE__->mk_accessors(qw(children));

sub new {
	my $pkg = shift;

	my $self = $pkg->SUPER::new(@_);
	$self->children([]) if ref $self->children ne 'ARRAY';
	return $self;
}

sub schild_iterator {
	my $self = shift;
	
	my $index = 0;
	my $iterator = sub {
		my $value = undef;

		return undef if $index >= @{$self->children};
		
		GET_SCHILD:
		for($self->children->[$index++]) {
			if (defined $_ && $_->isa('Parse::Java::Token') && !$_->significant) {
				redo GET_SCHILD;
			}
			
			$value = $_;
		}

		return $value;
	};
	
	return Parse::Java::Util::Iterator->new($iterator);
}

sub first_child_of_type {
    my ($self, $type) = @_;
    return first { $_->isa($type) } @{$self->children};
}

sub children_with {
	my ($self, $rules) = @_;
	
	my @children = @{$self->children};
	
	if (exists $rules->{isa}) {
		@children = grep { $_->isa($rules->{isa}) } @children;
	}
	
	return @children;
}

sub to_string {
    my $self = shift;
    return join "", map { $_->to_string } @{$self->children};
}

1;
__END__

=head1 NAME

Parse::Java::Node - An abstract element that may contain other elements

=head1 INTERFACE

=head2 INSTANCE METHODS

=over 4

=item children

Returns an array-reference with the children of this node.

=back

=cut