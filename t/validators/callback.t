use strict;
use warnings;

package CB;

sub cb {
    my $value = shift;
    ::ok(1) if grep { $value eq $_ ? 1 : 0 } qw/ 1 0 a /;
    return 1;
}

package main;

use Test::More tests => 5;

use HTML::FormFu;

my $form = HTML::FormFu->new;

$form->element('Text')->name('foo')->validator('Callback')
    ->callback( \&CB::cb );
$form->element('Text')->name('bar')->validator('Callback')->callback("CB::cb");

# Valid
{
    $form->process( {
            foo => 1,
            bar => [ 0, 'a', 'b' ],
        } );

    ok( $form->valid('foo'), 'foo valid' );
    ok( $form->valid('bar'), 'bar valid' );
}
