package Parser::Java;

use 5.014;
use warnings;

use parent qw(Parser::MGC);

my $QualifiedIdentifier = qr/\w+(?:\.\w+)*/u;
my $QualifiedIdentifierOrStar = qr/\w+(?:\.\w+)*(?:\.\*)?/u;

sub parse_package {
    my $self = shift;
    
    $self->expect("package");
    my $pkg = $self->expect($QualifiedIdentifier);
    $self->expect(";");    
    
    return { package => $pkg };
}

sub parse_import {
    my $self = shift;
    
    $self->expect("import");
    my $is_static = $self->maybe_expect("static");
    my $what = $self->expect($QualifiedIdentifierOrStar);
    $self->expect(";");
    
    return { import => $what, ($is_static ? (static => 1) : ()) };
}

sub parse_imports {
    my $self = shift;
    
    return $self->sequence_of(sub { $self->parse_import });
}

sub parse_type_arguments {
    my $self = shift;
    
    $self->expect("<");

    
    my $types = $self->list_of(",", sub { 
        my $qm = $self->maybe(sub { $self->expect("?"); $self->token_kw(qw(extends super)); });
        my $t = $self->parse_type;
        $t->{extends} = 1 if $qm && $qm eq "extends";
        $t->{super} = 1 if $qm && $qm eq "super";
        return $t;
    });

    $self->expect(">");
    
    return $types;
}

sub parse_complex_type {
    my $self = shift;

    my $identifier = $self->expect($QualifiedIdentifier);
    my $args = $self->maybe(sub { $self->parse_type_arguments });
    my $subtype = $self->maybe(sub { $self->expect("."); $self->parse_complex_type });
    
    my $subscripts = $self->sequence_of(sub { $self->expect("["); $self->expect("]"); 1; });
    
    return { 
        type => $identifier, 
        ($args ? (args => $args) : ()),
        ($subtype ? (subtype => $subtype) : ()),
        (@$subscripts > 0 ? (dimensions => scalar @$subscripts) : ()),
    };
}

sub parse_basic_type {
    my $self = shift;
    
    return { type => $self->token_kw(qw(byte short char int long float double boolean)) };
}

sub parse_type {
    my $self = shift;
    
    return $self->any_of(
        sub { $self->parse_complex_type() },
        sub { $self->parse_basic_type(); }
    );
}

sub parse {
    my $self = shift;
    
    my $tree = {};
        
    $self->maybe(sub { $tree->{package} = $self->parse_package; });
    $self->maybe(sub { $tree->{imports} = $self->parse_imports; });
    
    my @types;
    $self->sequence_of(sub { push @types, $self->parse_type; });
    $tree->{types} = \@types;
    
    return $tree;
}

1;
__END__
=head1 NAME

Parser::Java - Parser for Java code

=head1 SYNOPSIS

    use Parse::Java;

    my $parser = Parser::Java->new();
    my $ast = $parser->from_file('MyClass.java');
  	
=head1 DESCRIPTION

Parser::Java parses Java code into an Abstract Syntax Tree 
which can be used for many things like writing compilers and stuff.

As this module is currently under development it isn't yet able to 
parse much Java. What's in the t/*.t basically works but not much else.

=head1 INTERFACE 

This module uses an object-oriented interface.

=head2 CLASS METHODS

=over

=item from_file

Parses the contents of the file I<$path>. Returns an AST representing the code.

=item from_string

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

