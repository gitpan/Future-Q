use strict;
use warnings;
use Test::More;
use Future::Q;


note('--- all constructors should return Future::Q object.');

{
    my $f = new_ok('Future::Q');
    $f->done();
}

{
    my $f = new_ok('Future::Q');
    my $g = $f->new();
    isa_ok($g, 'Future::Q', '(obj)->new() should return Future::Q');
    $f->done; $g->done;
}

foreach my $method (qw(followed_by and_then or_else else then)) {
    my $f = new_ok('Future::Q');
    my $g = $f->$method(sub {
        return Future->new->done()
    });
    isa_ok($g, 'Future::Q', "$method() should return Future::Q");
    $f->done;
}

{
    my $f = new_ok('Future::Q');
    my $g = $f->transform(done => sub { 1 }, fail => sub { 0 });
    isa_ok($g, 'Future::Q', 'transform() should return Future::Q');
    $f->done;
}

foreach my $method (qw(wait_all wait_any needs_all needs_any)) {
    my @subf = map { Future::Q->new } (1..3);
    my $f = Future::Q->$method(@subf);
    isa_ok($f, 'Future::Q', "$method() should return Future::Q");
}

done_testing();
