use strict;
use warnings;
use ExtUtils::MakeMaker;
			
WriteMakefile(
    NAME                => 'Parse::Java',
    AUTHOR              => 'Claes Jakobsson <claesjac@cpan.org>',
    VERSION_FROM        => 'lib/Parse/Java.pm',
    ABSTRACT_FROM       => 'lib/Parse/Java.pm',
    PL_FILES            => {},
    PREREQ_PM => {
		'Class::Accessor' 	=> 0,
		'Parse::Yapp'   	=> 0,
        'Test::More' 		=> 0,
        'version'    		=> 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Parse-Java-*' },
	test				=> { TESTS => 't/*.t t/parse/*.t' },
);

