use 5.10.3;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Math::Shape::Point',
    AUTHOR           => q{David Farrell <sillymoos@cpan.org>},
    VERSION_FROM     => 'lib/Math/Shape/Point.pm',
    ABSTRACT_FROM    => 'lib/Math/Shape/Point.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Math::Trig'            => 0,
        'Method::Signatures'    => 0,
        'Regexp::Common'        => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Math-Shape-Point-*' },
);
