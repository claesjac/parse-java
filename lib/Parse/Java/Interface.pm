package Parse::Java::Interface;

use strict;
use warnings;

use base qw(Parse::Java::TypeDecl);

sub methods {
    shift->body->children_with({isa => "Parse::Java::Method"});
}

sub method {
    my ($self, $idx) = @_;
    my @methods = $self->body->children_with({isa => "Parse::Java::Method"});
    return $methods[$idx];
}
1;
__END__

=head1 NAME

Parse::Java::Interface - Description

=cut