package Math::Shape::Point;

use strict;
use warnings;
use Method::Signatures;
use Math::Trig ':pi';
use Regexp::Common;

our $VERSION = 0.01;

=head1 NAME

Math::Shape::Point - a 2d point object in cartesian space with utility angle methods 

=head1 DESCRIPTION

This module is designed to provide some useful 2d functions for manipulating point shapes in cartesian space. Apart from storing its location and direction and providing the usual get/set methods, the point object can rotate around another point, calculate the distance to and the angle to another point. The module uses cartesian coordinates and radians throughout.

=head1 SYNOPSIS

    use Math::Shape::Point;
    use Math::Trig ':pi';

    my $p0 = Math::Shape::Point->new(0, 0, 0);
    my $p1 = Math::Shape::Point->new(5, 5, 0);
    $p0->rotateAboutPoint($p1, pip2);
    $p0->getAngleToPoint($p1);
    $p0->getDistanceToPoint($p1);


=head1 METHODS

=head2 new

Instantiates a new point object. Requires the x and y cartesian coordinates and the facing direction in radians.

=cut

func new ($class, $x where { $_ =~ /$RE{num}{real}/ }, $y where { $_ =~ /$RE{num}{real}/ }, $r where { $_ =~ /$RE{num}{real}/ }) {
    my $self = { 
        x => $x,
        y => $y,
        r => $r,
    };
    return bless $self, $class;
}

=head2 getLocation

Returns an arrayref containing the point's location in cartesian coordinates.

=cut

method getLocation () {
    return [$self->{x}, $self->{y}];
}


=head2 setLocation

Sets the point's location in cartesian coordinates. Requires two numbers as inputs for the x and y location.

=cut

method setLocation ($x where { $_ =~ /$RE{num}{real}/ }, $y where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{x} = $x;
    $self->{y} = $y;
}


=head2 getDirection

Returns the current facing direction in radians.

=cut

method getDirection () {
    return $self->{r};
}


=head2 setDirection

Sets the current facing direction in radians.

=cut

method setDirection ($r where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{r} = $self->normalizeRadian($r);
}


=head2 advance

Requires a numeric distance argument - moves the point forward that distance in Cartesian coordinates towards the direction it is facing.

=cut

method advance ($distance where { $_ > 0 } where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{x} += int(sin($self->{r}) * $distance);
    $self->{y} += int(cos($self->{r}) * $distance);
}


=head2 rotate

Updates the point's facing direction by radians.

=cut

method rotate ($r where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{r} = $self->{r} + $self->normalizeRadian($r);
}


=head2 rotateAboutPoint

Rotates the point around another point of origin. Requires a point object and the angle in radians to rotate. This method updates the facing direction of the point object, as well as it's location.

=cut

method rotateAboutPoint (Math::Shape::Point $origin, $r where { $_ =~ /$RE{num}{real}/ } ) {
    $r = $self->normalizeRadian($r);
    $self->{x} = $origin->{x} + int(cos($r) * ($self->{x} - $origin->{x}) - sin($r) * ($self->{y} - $origin->{y}));
    $self->{y} = $origin->{y} + int(sin($r) * ($self->{x} - $origin->{x}) + cos($r) * ($self->{y} - $origin->{y}));
    $self->rotate($r);
}


=head2 getDistanceToPoint

Returns the distance to another point object. Requires a point object as an argument.

=cut

method getDistanceToPoint (Math::Shape::Point $p) {
    return sqrt ( abs($self->{x} - $p->{x}) ** 2 + abs($self->{y} - $p->{y}) ** 2);
}


=head2 getAngleToPoint

Returns the angle of another point object. Requires a point as an argument.

=cut

method getAngleToPoint (Math::Shape::Point $p) {
    my $atan = atan2($p->{y} - $self->{y}, $p->{x} - $self->{x});
    if ($atan <= 0) { # lower half
        return abs($atan) + pip2;
    }
    elsif ($atan <= pip2)  { # upper right quadrant
        return abs($atan - pip2);
    }
    else { # upper left quadrant
        return pi2 - $atan + pip2;
    }
}

=head2 normalizeRadian

Takes a radian argument and returns it between 0 and PI2. Negative numbers are assumed to be backwards (e.g. -1.57 == PI + PI / 2)

=cut

method normalizeRadian ($radians) {
    my $piDecimal = ($radians / pi2 - int($radians / pi2));
    return $piDecimal < 0 ? pi2 + $piDecimal * pi2 : $piDecimal * pi2;
}

1;
__END__

