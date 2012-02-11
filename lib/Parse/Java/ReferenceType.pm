package Parse::Java::ReferenceType;

use strict;
use warnings;

use base qw(Parse::Java::Type);

sub dimensions {
    return scalar shift->children_with({isa => "Parse::Java::ArrayDecl"});
}

1;
__END__

=head1 NAME

Parse::Java::ReferenceType - Description

=cut