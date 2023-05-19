component extends="org.lucee.cfml.test.LuceeTestCase" labels="ulid" {

	variables.rounds = 10000;
	variables.mysql = server.getDatasource("mysql");

	function run( testResults , testBox ) {
		describe( title="Test suite for CreateULID()", body=function() {
			it(title="checking CreateULID() function", body = function( currentSpec ) {
				systemOutput( "", true );
				systemOutput( "sample output", true );
				loop times=10 {
					systemOutput( createULID(), true );
				}
			});

			it(title="checking CreateULID('Monotonic') function", body = function( currentSpec ) {
				systemOutput( "", true );
				systemOutput( "sample Monotonic output", true );
				loop times=10 {
					systemOutput( createULID("Monotonic"), true );
				}
			});

			it(title="checking CreateULID('hash', number, string ) function", body = function( currentSpec ) {
				var once = createULID( "hash", 1, "b" );
				var again = createULID( "hash", 1, "b" );

				expect( once ).toBe( again );
			});

			it(title="checking CreateULID() function perf with #variables.rounds# rows", body = function( currentSpec ) {

				var tbl = createTable( "default" );
				if ( isEmpty( tbl ) ) return;
				timer unit="milli" variable="local.timer" {
					//transaction {
						loop times=#variables.rounds# {
							populateTable( tbl, createULID() );
						}
					//}
				}
				systemOutput( "" , true );
				systemOutput( "inserting #variables.rounds# rows with CreateULID() took " & numberFormat(timer) & "ms", true);

				var r = testJoin( tbl );
				expect( r ).toBe( variables.rounds );
			});

			it(title="checking CreateUUID() function perf with #variables.rounds# rows", body = function( currentSpec ) {

				var tbl = createTable( "uuid" );
				if ( isEmpty( tbl ) ) return;

				timer unit="milli" variable="local.timer" {
					//transaction {
						loop times=#variables.rounds# {
							populateTable( tbl, createUUID() );
						}
					//}
				}

				systemOutput( "" , true );
				systemOutput( "inserting #variables.rounds# rows with CreateUUID() took " & numberFormat(timer) & "ms", true);

				var r = testJoin( tbl );
				expect( r ).toBe( variables.rounds );
			});

			it(title="checking CreateUUID() function perf with #variables.rounds# rows (pre cooked)", body = function( currentSpec ) {

				var tbl = createTable( "uuid_precooked" );
				if ( isEmpty( tbl ) ) return;
				var src = [];
				loop times=#variables.rounds# {
					arrayAppend(src, CreateUUID() );
				}

				timer unit="milli" variable="local.timer" {
					//transaction {
						loop from=1 to=#variables.rounds# index="local.i" {
							populateTable( tbl, src[i] );
						}
					//}
				}

				systemOutput( "" , true );
				systemOutput( "inserting #variables.rounds# rows with CreateUUID() (pre cooked) took " & numberFormat(timer) & "ms", true);
			});

			it(title="checking CreateULID('Monotonic') function perf with #variables.rounds# rows", body = function( currentSpec ) {

				var tbl = createTable( "Monotonic" );
				if ( isEmpty( tbl ) ) return;

				timer unit="milli" variable="local.timer" {
					//transaction {
						loop times=#variables.rounds# {
							populateTable( tbl, CreateULID("Monotonic") );
						}
					//}
				}

				systemOutput( "" , true );
				systemOutput( "inserting #variables.rounds# rows with CreateULID('Monotonic') took " & numberFormat(timer) & "ms", true);

				var r = testJoin( tbl );
				expect( r ).toBe( variables.rounds );
			});

			
			it(title="checking CreateULID('Monotonic') function perf with #variables.rounds# rows (pre cooked)", body = function( currentSpec ) {

				var tbl = createTable( "Monotonic_precooked" );
				if ( isEmpty( tbl ) ) return;
				var src = [];
				loop times=#variables.rounds# {
					arrayAppend(src, CreateULID("Monotonic") );
				}

				timer unit="milli" variable="local.timer" {
					//transaction {
						loop from=1 to=#variables.rounds# index="local.i" {
							populateTable( tbl, src[i] );
						}
					//}
				}

				systemOutput( "" , true );
				systemOutput( "inserting #variables.rounds# rows with CreateULID('Monotonic') (pre cooked) took " & numberFormat(timer) & "ms", true);
			});

			it(title="dump table sizes", body = function( currentSpec ) {
				if ( isEmpty( variables.mysql ) ) return "";
				query name="local.tables" datasource=#variables.mysql# {
					echo("SELECT  TABLE_NAME, ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024) AS SIZE_KB,
								ROUND(DATA_LENGTH / 1024) AS DATA_KB,
								ROUND(INDEX_LENGTH / 1024) AS INDEX_KB
						FROM 	information_schema.TABLES
						WHERE	TABLE_SCHEMA = 'lucee'
								AND TABLE_NAME like 'test_ulid_%'
						ORDER BY(DATA_LENGTH + INDEX_LENGTH) DESC");
				}
				systemOutput("", true);
				systemOutput("Report resulting table sizes", true);
				loop query="tables" {
					systemOutput("#tables.table_name# - data: #numberFormat(tables.DATA_KB)#Kb, index: #numberFormat(tables.INDEX_KB)#Kb, total: #numberFormat(tables.SIZE_KB)#Kb", true);
				}
			});

			it(title="expect CreateULID() to throw on bad/unsupported type", body = function( currentSpec ) {
				expect(function(){
					createULID("uuid");
				}).toThrow();
			});

		});
	}

	private function createTable( prefix ){
		if ( isEmpty( variables.mysql ) ) return "";

		var tbl = "test_ulid_" & prefix;

		query datasource=#variables.mysql# {
			echo("DROP TABLE IF EXISTS #tbl#");
		}
		query datasource=#variables.mysql# {
			echo("CREATE TABLE #tbl# ( id varchar(36) NOT NULL PRIMARY KEY ) ");
		}
		sleep(1000);
		return tbl;
	}

	private function populateTable (tbl, id){
		query datasource=#variables.mysql# params={ id: arguments.id, type="varchar" } {
			echo("INSERT into #arguments.tbl# (id) VALUES (:id) "); 
		}
	}

	private function testJoin(tbl){
		timer unit="milli" variable="local.timer" {
			query name="local.q" datasource=#variables.mysql# {
				echo("select t1.id from #tbl# t1, #tbl# t2 where t1.id=t2.id "); 
			}	
		}

		systemOutput( "join with #tbl# took " & numberFormat(timer) & "ms", true);
		return q.recordcount;
	}
}