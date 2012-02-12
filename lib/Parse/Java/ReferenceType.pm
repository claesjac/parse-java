package Parse::Java::ReferenceType;

use strict;
use warnings;

use base qw(Parse::Java::Type);

sub dimensions {
    return scalar shift->children_with({isa => "Parse::Java::ArrayDecl"});
}

sub vargs {
    my $array = shift->first_child_of_type("Parse::Java::ArrayDecl");
    $array && $array->children->[0]->value eq "...";
}

1;
__END__

=head1 NAME

Parse::Java::ReferenceType - Description

=cut