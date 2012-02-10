package Parse::Java::Class;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::TypeDecl Parse::Java::LazyNode);

__PACKAGE__->mk_accessors(qw(name extends implements));

sub _load {
	my $self = shift;
	
	return if $self->_loaded();
	
	my $iterator = $self->schild_iterator();
	
	LOAD_ITERATOR:
	while (<$iterator>) {
		if ($_->isa('Parse::Java::Token::Keyword') && $_->value eq 'class') {
			my $name = <$iterator>;
			$self->SUPER::set(name => $name);
			next LOAD_ITERATOR;
		}
		if ($_->isa('Parse::Java::Token::Keyword') && $_->value eq 'extends') {
			my $extends = <$iterator>;
			$self->SUPER::set(extends => $extends);
			next LOAD_ITERATOR;
		}
	}	
	
	$self->_loaded(1);
}

sub name {
	my $self = shift;
	$self->_load();
	return $self->SUPER::get("name");
}

sub extends {
	my $self = shift;
	$self->_load();
	return $self->SUPER::get("extends");
}

1;
__END__

=head1 NAME

Parse::Java::Class - Description

=cut