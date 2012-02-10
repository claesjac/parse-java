package Parse::Java::Token::Modifier;

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

Parse::Java::Token::Modifier - Tokens for modifiers

=cut