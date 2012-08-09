#!winxed

$include 't/common.winxed';

function main[main]() {
    Rosella.Test.test(class EmptySubTest);
}

class EmptySubTest {
    // This has a variety of tests based on compiling an empty sub
    // Most of what is "expected" was simply tested experimentally
    // These may change based on changes in IMCC
    function test_empty_sub() {
        var assert = self.assert;

        // Get a PACT.Packfile
        var pact = decompile(compile(<<:
.namespace [] # workaround for IMCC bug
.sub 'empty_sub'
.end
:>>
        ));

        // Some simple tests
        assert.is_null(pact.main, 'no main');
        assert.equal(0,  pact.uuid_type, 'no UUID type');
        assert.equal('', pact.uuid,      'no UUID');

        // No floats
        assert.equal(0, elements(pact.floats), 'no floats');

        // Two PMCs: 1 sub (empty_sub), 1 empty FIA for PCC
        assert.equal(2, elements(pact.pmcs), '2 PMCs');
        var fia;
        var sub;
        for (var pmc in pact.pmcs) {
            switch(typeof(pmc)) {
            case 'FixedIntegerArray':
                fia = pmc;
                break;

            case 'PACT;Packfile;Subroutine':
                sub = pmc;
                break;

            default:
                assert.fail('Unexpected PMC Constant');
            }
        }

        assert.not_null(fia, 'got FIA');
        assert.equal(0, elements(fia), 'FIA is empty (PCC)');

        assert.not_null(sub, 'got Sub');
        assert.equal('empty_sub', sub.name);

        // 4 strings: filename, subname, empty, 'parrot'
        assert.equal(4, elements(pact.strings), '4 strings');
        var strings = {};
        int nulls;
        for (string s in pact.strings) {
            if(s == null)
                ++nulls; // hashes complain about storing nulls
            else
                strings[s] = 1;
        }
        assert.equal(1, nulls, '1 null string'); // XXX: Why?
        assert.equal(1, strings['parrot'],         'HLL namespace name');
        assert.equal(1, strings['empty_sub'],      'sub name');
        assert.equal(1, strings['(file unknown)'], 'file name');

        // 1 oplib: core_ops
        assert.equal(1, elements(pact.oplibs), '1 oplib');
        var core_ops = pact.oplibs['core_ops'];
        assert.not_null(core_ops, 'have core_ops');
        assert.instance_of(core_ops, 'OpLib', 'core_ops is OpLib');

        // Check namespaces
        assert.instance_of(pact.root, class PACT.Packfile.Namespace);
        assert.equal(1, elements(pact.root.contents), '1 object in root');

        var parrot = pact.root.contents['parrot'];
        assert.not_null(parrot, 'have a parrot');
        assert.instance_of(parrot, class PACT.Packfile.Namespace);
        assert.equal(1, elements(parrot.contents), '1 object in parrot');

        // Check sub
        var empty_sub = parrot.contents['empty_sub'];
        assert.not_null(empty_sub, 'have an empty_sub');
        assert.instance_of(empty_sub, class PACT.Packfile.Subroutine);
        assert.equal('empty_sub', empty_sub.name);

        // Check ops
        assert.equal(5, elements(empty_sub.ops));
        var op;
        var arg;

        // Debug w/ filename
        op = empty_sub.ops[0];
        assert.instance_of(op, class PACT.Packfile.Debug, 'got debug');
        assert.equal('(file unknown)', op.filename, 'have filename');

        // Label for PC 0
        op = empty_sub.ops[1];
        assert.instance_of(op, class PACT.Packfile.Label, 'got Label 1');
        assert.equal('_0', op.name, 'is PC 0 label');

        // set_returns []
        op = empty_sub.ops[2];
        assert.instance_of(op, class PACT.Packfile.Op, 'got Op 1');
        assert.equal('set_returns', op.name, 'PCC set_returns');
        assert.equal(1, elements(op.args), 'set_returns has 1 arg');
        arg = op.args[0];
        assert.instance_of(arg, class PACT.Packfile.Constant.Reference,
                'set_returns uses a constant');
        assert.equal(PARROT_ARG_PMC, arg.type, 'set_returns uses PMC const');
        arg = pact.pmcs[arg.value];
        assert.instance_of(arg, 'FixedIntegerArray', 'set_returns uses FIA');
        assert.equal(0, elements(arg), 'set_returns FIA empty');

        // Label for PC 2
        op = empty_sub.ops[3];
        assert.instance_of(op, class PACT.Packfile.Label, 'got Label 2');
        assert.equal('_2', op.name, 'is PC 2 label');

        // returncc
        op = empty_sub.ops[4];
        assert.instance_of(op, class PACT.Packfile.Op, 'got Op 2');
        assert.equal('returncc', op.name, 'PCC returncc');
        assert.equal(0, elements(op.args), 'returncc has no args');
    }
}

# vim: se ft=winxed :
