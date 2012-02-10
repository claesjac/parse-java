package Parse::Java::Token::Null;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Token);

sub significant {
	return 0;
}

1;
__END__

=head1 NAME

Parse::Java::Token::Null - Description

=cut