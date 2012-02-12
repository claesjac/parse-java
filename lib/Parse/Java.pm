package Parse::Java;

require 5.006;

use warnings;
use strict;

use Carp qw(croak);
use File::Spec;
use Parse::Yapp;

our $VERSION = "0.01_01";

BEGIN {
	# Load grammar when we use the module
	my $base_dir = __FILE__;
	$base_dir =~ s/Java\.pm$//;

	open my $grammar_io, "<", File::Spec->catfile($base_dir, 'Java.yp') or die "Failed to open grammar because of: $!";
	my $grammar_src = do { local $/; <$grammar_io>; };
	close $grammar_io;

	# This is a hack we need to testing
	if ($ENV{PARSE_JAVA_START_PRODUCTION}) {
		$grammar_src =~ s/^\%start \w+$/%start $ENV{PARSE_JAVA_START_PRODUCTION}/m;
 	}
	
	my $parser = Parse::Yapp->new(input => $grammar_src);
	my $parser_src = $parser->Output(
		classname => __PACKAGE__,
		standalone => 0,
		linenumbers => 0,
		template => undef,
	);							

	if (!eval $parser_src) {
		# Ohooh.. grammar error.. need to debug
		my ($line) = $@ =~ /line (\d+)/;
		my $first = $line - 3 >= 0 ? $line - 3 : 0;
		my $last = $line + 3;
		my $line_no = 0;

		print STDERR "Got error: $@";
		my @src_lines = split/\n/, $parser_src;
		for my $src_line (@src_lines) {
			$src_line = ($line_no == $line ? '>>' : '  ') . $src_line;
			print STDERR $src_line, "\n", if ($line_no >= $first);
			last if $line_no > $last;
			$line_no++;
		}
	}
	
	if ($ENV{PARSE_JAVA_DEBUG}) {
		my $output = "Java.output";
		my $tmp;

		open my $out, ">", $output or croak "Failed to open $output because of: $!";

		$tmp = $parser->Warnings() || "";
		print $out "Warnings:\n---------\n$tmp\n";
		$tmp = $parser->Conflicts() || "";
		print $out "Conflicts:\n----------\n$tmp\n";
		print $out "Rules:\n------\n";
		print $out $parser->ShowRules()."\n";
		print $out "States:\n-------\n";
		print $out $parser->ShowDfa()."\n";
		print $out "Summary:\n--------\n";
		print $out $parser->Summary();

		close $out;
	}
}

sub parse_file {
	my ($pkg, $file) = @_;

	open my $io, "<", $file || croak $!;
	my $source = do { local $/;  <$io>; };
	close $io;
	
	return $pkg->parse_string($source);
}

sub parse_string {
	my ($pkg, $source) = @_;
	
	my $parser = Parse::Java->new();
	$parser->_set_input($source);
	my $ast = $parser->_run();	

	return $ast;
}

1; # Magic true value required at end of module
__END__
=head1 NAME

Parse::Java - Parser for Java code

=head1 SYNOPSIS

    use Parse::Java;

    my $ast = Parse::Java->parse_file('MyClass.java');
  	
=head1 DESCRIPTION

Parse::Java parses Java code into an Abstract Syntax Tree 
which can be used for many things like writing compilers and stuff.

As this module is currently under development it isn't yet able to 
parse much Java. What's in the t/*.t basically works but not much else.

The lexer should also more or less work fine except expansion of unicode escapes \uNNNN. 

=head1 INTERFACE 

This module uses an object-oriented interface.

=head2 CLASS METHODS

=over

=item parse_file ( $path )

Parses the contents of the file I<$path>. Returns an AST representing the code.

=item parse_string

Parses the source in I<$string>. Returns an AST representing the code.

=back

=head2 INSTANCE METHODS

=over

=item _set_input ( $source )

Sets the input to the lexer. 

=item _next_token

Returns a list with the next token from the stream and its value. 

=back

=head1 BUGS AND LIMITATIONS

PLEASE DO NOT REPORT ANY BUGS AS THIS MODULE IS UNDER DEVELOPMENT.

Please report any bugs or feature requests to
C<bug-parse-java@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Claes Jakobsson  C<< <claesjac@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Claes Jakobsson C<< <claesjac@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

