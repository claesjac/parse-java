package Parse::Java::Parameters;

use strict;
use warnings;

use base qw(Parse::Java::Node);

sub count {
    return scalar shift->children_with({ isa => "Parse::Java::Parameter" });
}

sub parameter {
    my ($self, $index) = @_;
    my @children = $self->children_with({ isa => "Parse::Java::Parameter" });
    return $children[$index];
}
1;
__END__

=head1 NAME

Parse::Java::Parameters - Description

=cut