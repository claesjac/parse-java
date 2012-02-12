package Parse::Java::Method;

use strict;
use warnings;

use base qw(Parse::Java::Node);

sub identifier {
    shift->first_child_of_type("Parse::Java::Identifier");
}

1;
__END__
