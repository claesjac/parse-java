package Parse::Java::Token::Identifier;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::Token);

sub significant {
	return 1;
}

1;
__END__

=head1 NAME

Parse::Java::Token::Identifier - Description

=cut