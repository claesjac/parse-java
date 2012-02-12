package Parse::Java::Parameter;

use strict;
use warnings;

use base qw(Parse::Java::Node);

sub type {
    shift->first_child_of_type("Parse::Java::Type");
}

sub identifier {
    shift->first_child_of_type("Parse::Java::Identifier");
}

sub modifiers {
    shift->first_child_of_type("Parse::Java::Modifiers");
}

sub vargs {
    my $type = shift->type;
    $type->can("vargs") && $type->vargs;
}

1;
__END__
