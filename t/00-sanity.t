#!winxed

function main[main]() {
    // Segfault in IMCC
    load_bytecode('rosella/core.pbc');
    (new SanityTest).test_imcc();
}

class SanityTest {
    function test_imcc() {
        var imcc = compreg('PIR');
        var view = imcc.compile(<<:
.sub 'foo'
.end
:>>
        );
    }
}

# vim: se ft=winxed :
