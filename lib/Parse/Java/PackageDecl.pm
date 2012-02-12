package Parse::Java::PackageDecl;

use strict;
use warnings;

use base qw(Parse::Java::Node);

sub identifier {
    my $self = shift;
    return $self->first_child_of_type("Parse::Java::Identifier");
}

1;
__END__

=head1 NAME

Parse::Java::Type - Description

=cut