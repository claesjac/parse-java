#!perl

use Test::More;

use strict;
use warnings;

use File::Spec;
use Parse::Java;

my $java_dir = File::Spec->catdir('t', 'java-src');
opendir(my $java_src_dir, $java_dir) || die $!;
my @files = sort readdir($java_src_dir);
closedir($java_src_dir);

plan tests => scalar @files;

foreach my $file (@files) {
	my $parser = Parse::Java->new();
	
	open(my $java_io, "<", File::Spec->catfile($java_dir, $file)) || die $!;
	$parser->_set_input(do { local $/; <$java_io>; });
	close($java_io);
	
	eval {
		my ($token);
		do {
			($token) = $parser->_next_token();
		} while($token ne '');
	};
	if ($@) {
		print STDERR "$@\n";
		ok(0, "$file failed");
	}
	else {
		ok(1, "$file passed");
	}
}