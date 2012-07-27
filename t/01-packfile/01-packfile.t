#!winxed

// Tests for PACT.Packfile

$include 't/common.winxed';

function main[main]() {
    Rosella.Test.test(class PackfileTest);
}

class PackfileTest {
    // Test that new Packfile has an empty UUID
    function test_uuid_new() {
        var assert = self.assert;
        :PACT.Packfile pf();
        assert.equal(0,  pf.uuid_type);
        assert.equal('', pf.uuid);
    }

    // Test setting an empty UUID
    function test_uuid_set_empty() {
        var assert = self.assert;
        :PACT.Packfile pf();
        assert.throws_nothing(function () {
            pf.set_uuid(0, '');
        });
        assert.equal(0,  pf.uuid_type);
        assert.equal('', pf.uuid);
    }

    // Test setting an MD5 UUID
    function test_uuid_set_md5() {
        var assert = self.assert;
        string md5 = 'd41d8cd98f00b204e9800998ecf8427e'; // Empty file
        :PACT.Packfile pf();
        assert.throws_nothing(function () {
            pf.set_uuid(1, md5);
        });
        assert.equal(1, pf.uuid_type);
        assert.equal(md5, pf.uuid);
    }
}

# vim: ft=winxed
