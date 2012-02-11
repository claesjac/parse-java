package Parse::Java::Token::Keyword;

use strict;
use warnings;

use base qw(Parse::Java::Token);

use constant WHITESPACE_BEFORE => 0x1;
use constant WHITESPACE_AFTER  => 0x2;

sub significant {
	return 1;
}

my %Whitespace = (
    'extends' => WHITESPACE_BEFORE | WHITESPACE_AFTER,
);

my @WhitespaceFormater = (
    "%s", " %s", "%s ", " %s "
);

sub to_string {
    my $self = shift;
    my $kw = $self->value;
    
    my $ws = $Whitespace{$kw};
    return $kw unless $ws;
    
    return sprintf $WhitespaceFormater[$ws], $kw;
}

1;
__END__

=head1 NAME

Parse::Java::Token::Keyword - Description

=cut