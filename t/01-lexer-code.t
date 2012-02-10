#!perl

use Test::More tests => 8;

use strict;
use warnings;

use Parse::Java;

{
	my $parser = Parse::Java->new();
	$parser->_set_input(do { local $/; <DATA>; });
	
	sub next_token {
		return [$parser->_next_token()];
	}
	
	sub pre_token_list {
		return $parser->YYData->{PRE_TOKEN_LIST};
	}
	
	sub skip_tokens {
		my $count = shift;
		next_token for 1..$count;
	}
}

is_deeply(next_token, ['PACKAGE_TK', 'package'], "Package ok");

{
	local $Parse::Java::PreserveWhitespace = 1;
	is_deeply(next_token, ['IDENTIFIER_TK', 'foo'], "Identifier after package ok");
	is_deeply(pre_token_list, [' ']);
	is_deeply(next_token, ['SC_TK', ';'], "Separator ; ok");
}


skip_tokens(3);

is_deeply(next_token, ['OCB_TK', '{'], "Separator { ok");

{
	local $Parse::Java::PreserveComments = 1;
	is_deeply(next_token, ['MODIFIER_TK', 'final'], "/**/ comment single like ok");
	is_deeply(pre_token_list, ['* member ']);
}

# skip 'final statc QUAX'
skip_tokens(2);

# Expect assignment
is_deeply(next_token, ['ASSIGN_TK', '='], "Assignment ok");

__DATA__
package foo;

/* Comment should be ignored */ 

public class Bar {
	/** member */
	final static QUAX = "some stuff";
}