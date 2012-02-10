package Parse::Java::Document;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(qw(types package imports));

1;
__END__

=head1 NAME

Parse::Java::Document - Description

=cut