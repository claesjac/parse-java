#!perl

package MyLazyClass;

use Test::More tests => 7;

use strict;
use warnings;

BEGIN { use_ok('Parse::Java::LazyNode'); }

our @ISA = qw(Parse::Java::LazyNode);

eval {
	MyLazyClass->new->_load();
};
ok($@, qr/Class 'MyLazyClass' does not implement _load/);

my $obj = bless {}, 'MyLazyClass';
my $obj2 = bless {}, 'MyLazyClass';

is($obj->_loaded(), 0);

my $value = 0;
*MyLazyClass::_load = sub {
	my $self = shift;
	return if $self->_loaded();
	$value++;
	$self->_loaded(1);
};

$obj->_load();
is($value, 1);
is($obj->_loaded(), 1);
$obj->_load();
is($value, 1);
is($obj2->_loaded(), 0);