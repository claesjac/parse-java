package Parse::Java::Interface;

use strict;
use warnings;

use base qw(Parse::Java::TypeDecl);

sub methods {
    shift->first_child_of_type("Parse::Java::InterfaceBody")->children_with({isa => "Parse::Java::Method"});
}
1;
__END__

=head1 NAME

Parse::Java::Interface - Description

=cut