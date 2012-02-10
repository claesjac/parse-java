package Parse::Java::Interface;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Parse::Java::TypeDecl);

__PACKAGE__->mk_accessors(qw(extends));

1;
__END__

=head1 NAME

Parse::Java::Interface - Description

=cut