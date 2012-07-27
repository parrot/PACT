#!winxed

// Tests for PACT.Packfile.Constant

$include 't/common.winxed';

function main[main]() {
    Rosella.Test.test(class ConstantTest);
}

class ConstantTest {

    function test_int() {
        var assert = self.assert;
        :PACT.Packfile.Constant c(42);
        assert.equal(PARROT_ARG_INTVAL, c.type);
        assert.equal(42, c.value);
    }

    // Should convert to int
    function test_int_typed() {
        var assert = self.assert;
        :PACT.Packfile.Constant c(PARROT_ARG_INTVAL, '42');
        assert.equal(PARROT_ARG_INTVAL, c.type);
        assert.instance_of(c.value, 'Integer');
        assert.equal(42, c.value);
    }

    function test_string() {
        var assert = self.assert;
        :PACT.Packfile.Constant c('a');
        assert.equal(PARROT_ARG_STRING, c.type);
        assert.equal('a', c.value);
    }

    // Should convert to string
    function test_string_typed() {
        var assert = self.assert;
        :PACT.Packfile.Constant c(PARROT_ARG_STRING, 42);
        assert.equal(PARROT_ARG_STRING, c.type);
        assert.instance_of(c.value, 'String');
        assert.equal('42', c.value);
    }

    function test_float() {
        var assert = self.assert;
        :PACT.Packfile.Constant c(3.14);
        assert.equal(PARROT_ARG_FLOATVAL, c.type);
        assert.equal(3.14, c.value);
    }

    // Should convert to float
    function test_float_typed() {
        var assert = self.assert;
        :PACT.Packfile.Constant c(PARROT_ARG_FLOATVAL, '3.14');
        assert.equal(PARROT_ARG_FLOATVAL, c.type);
        assert.instance_of(c.value, 'Float');
        assert.equal(3.14, c.value);
    }

    function test_var() {
        var assert = self.assert;
        var val = [];
        :PACT.Packfile.Constant c(val);
        assert.equal(PARROT_ARG_PMC, c.type);
        assert.instance_of(c.value, typeof(val));
        assert.equal(0, elements(c.value));
    }

    // Identical to above, but with explicit type
    function test_var_typed() {
        var assert = self.assert;
        var val = [];
        :PACT.Packfile.Constant c(PARROT_ARG_PMC, val);
        assert.equal(PARROT_ARG_PMC, c.type);
        assert.instance_of(c.value, typeof(val));
        assert.equal(0, elements(c.value));
    }

}

# vim: ft=winxed
