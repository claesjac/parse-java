package Parse::Java::Block;

use strict;
use warnings;

use base qw(Parse::Java::Node);

sub label {
    shift->first_child_of_type("Parse::Java::StatementLabel");
}
1;
__END__