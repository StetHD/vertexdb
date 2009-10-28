#!/usr/local/bin/io

/*
	select 
		op: keys / values | pairs / rm | counts | json
		before:id
		after:id
		count:max
		whereKey:k, whereValue:v
	rm
	mkdir
	link
	chmod
	chown
	stat
	size

	read
	write mode: set / append

	queuePopTo
	queueExpireTo

	transaction
	login
	newUser

	shutdown
	backup
	collectGarbage
	stats
*/

VDBTest := UnitTest clone do(
	setUp := method(
		url := URL with("http://localhost:8080/?action=transaction")
		result := url post("/?action=select&op=rm
/test/a?action=mkdir
/test/a?action=write&key=_a&value=1
/test/a?action=write&key=_b&value=2
/test/a?action=write&key=_c&value=3
/test/b?action=mkdir
/test/b?action=write&key=_a&value=4
/test/b?action=write&key=_b&value=5
/test/b?action=write&key=_c&value=6
/test/c?action=mkdir
/test/c?action=write&key=_a&value=7
/test/c?action=write&key=_b&value=5
/test/c?action=write&key=_c&value=9")
		if(url statusCode == 500,
			Exception raise("Error in transaction setting up VDBTest: " .. result)
		)
	)
	
	testRead := method(
		assertEquals(URL with("http://localhost:8080/test/a?action=read&key=_a") fetch, "\"1\"")
		assertEquals(URL with("http://localhost:8080/test/a?action=read&key=_b") fetch, "\"2\"")
		assertEquals(URL with("http://localhost:8080/test/a?action=read&key=_c") fetch, "\"3\"")
	)
	
	testSelectKeys := method(
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys") fetch, """["a","b","c"]""")
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys&count=1") fetch, """["a"]""")
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys&after=a") fetch, """["b","c"]""")
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys&before=b") fetch, """["a"]""")
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys&whereKey=_b&whereValue=5") fetch, """["b","c"]""")
		assertEquals(URL with("http://localhost:8080/test?action=select&op=keys&whereKey=_a&whereValue=10") fetch, """[]""")
	)
	
	//assertEquals(URL with("http://localhost:8080/test?action=select&op=values") fetch, """["1","2","3"]""")
)

VDBTest run

/*
assertEquals := method(a, b, 
	if(a != b, 
		Exception raise(call message argAt(0) .. " == " .. a .. " instead of " .. b)
	)
)

URL with("http://localhost:8080/?action=select&op=rm") fetch

// test size

assertEquals(URL with("http://localhost:8080/?action=size") fetch, "0")

// test mkdir, write

URL with("http://localhost:8080/test?action=mkdir") fetch
URL with("http://localhost:8080/test?action=write&key=_a") post("1")
URL with("http://localhost:8080/test?action=write&key=_b") post("2")
URL with("http://localhost:8080/test?action=write&key=_c") post("3")

// test read



// test select keys/values



// test select pairs before/after

assertEquals(URL with("http://localhost:8080/test?action=select&op=pairs") fetch, """[["_a","1"],["_b","2"],["_c","3"]]""")
assertEquals(URL with("http://localhost:8080/test?action=select&op=pairs&after=_a") fetch,  """[["_b","2"],["_c","3"]]""")
assertEquals(URL with("http://localhost:8080/test?action=select&op=pairs&before=_c") fetch, """[["_b","2"],["_a","1"]]""")
assertEquals(URL with("http://localhost:8080/test?action=size") fetch, "3")

// test rm

URL with("http://localhost:8080/test?action=rm&key=_a") fetch
//assertEquals(URL with("http://localhost:8080/test?action=read&key=_a") fetch, null)
assertEquals(URL with("http://localhost:8080/test?action=size") fetch, "2")

// test select rm

URL with("http://localhost:8080/test?action=write&key=_a") post("1")
URL with("http://localhost:8080/test?action=select&op=rm&after=_a") fetch
assertEquals(URL with("http://localhost:8080/test?action=size") fetch, "1")

/*
userId := URL with("http://localhost:8080/?newUser") fetch
c1 := URL with("http://localhost:8080/users/" .. userId .. "/items/unseen?count") fetch
c2 := URL with("http://localhost:8080/public/items?count") fetch
assertEquals(c1, c2)
*/

/*
Object squareBrackets := Object getSlot("list")
Object curlyBrackets := Object getSlot("list")
assertEquals(id1, id2)
*/
*/