package Parse::Java::Class;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::TypeDecl);

sub name {
    shift->first_child_of_type("Parse::Java::Identifier");
}

sub extends {
}

1;
__END__

=head1 NAME

Parse::Java::Class - Description

=cut