package Parse::Java::ReferenceType;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Type);

#use overload q{""} => \&to_string;

#sub to_string {
#	my $self = shift;
#	return join "", map { "$_" } @{$self->children};
#}

1;
__END__

=head1 NAME

Parse::Java::ReferenceType - Description

=cut