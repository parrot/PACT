#!winxed

class PACT.Packfile;
class PACT.Packfile.Decompile;

function main[main]() {
    load_bytecode('rosella/core.pbc');
    Rosella.initialize_rosella('test');
    Rosella.Test.test(class SanityTest);
}

class SanityTest {
    function test_imcc() {
        var assert = self.assert;

        var imcc = compreg('PIR');
        assert.defined(imcc, 'IMCC exists');

        var view = imcc.compile(<<:
.sub 'test_imcc_1'
.end
:>>
        );
        assert.defined(view, 'got something from IMCC');
        assert.instance_of(view, 'PackfileView');

        var packfile = new 'Packfile'(view);
        assert.instance_of(packfile, 'Packfile');
    }

    function test_loading() {
        load_bytecode('pact/packfile.pbc');
        assert.not_null(class PACT.Packfile, 'found Packfile');

        load_bytecode('pact/packfile/decompile.pbc');
        assert.not_null(class PACT.Packfile.Decompile, 'found Decompile');
    }
}

# vim: se ft=winxed :
