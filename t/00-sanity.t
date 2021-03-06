#!winxed

$include 't/common.winxed';

function main[main]() {
    Rosella.Test.test(class SanityTest);
}

class SanityTest {
    function test_imcc() {
        var assert = self.assert;

        var imcc = compreg('PIR');
        assert.defined(imcc, 'IMCC exists');

        var view = imcc.compile(<<:
.namespace [] # work around for segfault
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
        var assert = self.assert;

        assert.not_null(class PACT.Packfile, 'found Packfile');

        assert.not_null(class PACT.Packfile.Decompile, 'found Decompile');
    }

    function test_compile_decompile() {
        var assert = self.assert;

        var pack = compile(<<:
.namespace [] # work around for segfault
.sub 'test_compile'
.end
:>>
        );

        assert.not_null(pack);
        assert.instance_of(pack, 'Packfile');

        var pact = decompile(pack);
        assert.instance_of(pact, class PACT.Packfile);
    }
}

# vim: se ft=winxed :
