component extends="org.lucee.cfml.test.LuceeTestCase" labels="ulid" {
    function testInstalled (){
        var fl = getFunctionList();
        expect( fl ) .toHaveKey( "createULID" );
        var fd = getFunctionData( "createULID" );
        expect( arrayLen( fd.arguments ) ).toBe( 3 );
        createULID();
    }
}