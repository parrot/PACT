#!winxed

function main[main]() {
    load_bytecode('rosella/core.pbc');
    Rosella.initialize_rosella('test');
    Rosella.Test.test(class DummyTest);
}

class DummyTest {
    function test_dummy() {
    }
}

# vim: se ft=winxed :
