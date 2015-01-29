component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		addMatchers( {
			toBePresent : function( expectation, args={} ){ return len(expectation) gte 0; }
		} );

	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("initlizations", function(){
			it("initializes", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				expect(sendgrid).toBeInstanceOf('SendGrid');

			});
			it("sets username and password in intialization", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				expect(sendgrid.apiUsername).toBe('user');
				expect(sendgrid.apiPassword).toBe('pass');
			});
			it("has default url", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				expect(sendgrid.url).toBe('https://api.sendgrid.com/api/mail.send.json')
			});
			it("can set a custom url with url option", function(){
				var options = {
					url = "http://thisisaurlitotallymadeup.com/mail"
				};
				var sendgrid = new models.SendGrid('user', 'pass', options);
				expect(sendgrid.url).toBe('http://thisisaurlitotallymadeup.com/mail')
			});
			it("can set a custom url with url part options", function(){
				var options = {
					"protocol": "http",
					"host": "sendgrid.org",
					"endpoint": "/send",
					"port": "80"
				};
				var sendgrid = new models.SendGrid('user', 'pass', options);
				expect(sendgrid.url).toBe('http://sendgrid.org:80/send')
			});
		});

		describe("Sending email", function(){
			it("gets a response from SendGrid when sending", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				var email = new models.SendGrid.Email();
				var response = {};

				// email.addTo('bar@foo.com');
				// email.setFrom('foo@bar.com');
				// email.setSubject('Foobar subject!');
				// email.setText('This is the body!');

				response = sendgrid.send(email);
				expect(response).toBeTypeOf('struct');
				expect(response.errors[1]).toBe("Bad username / password");
			});

			it( "gets a response from SendGrid with attachment", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				var email = new models.SendGrid.Email();
				var response = {};

				expect(response.errors[1]).toBe("Bad username / password");
			});

			it("gets a response from SendGrid with attachment missing extention", function(){
				var sendgrid = new models.SendGrid('user', 'pass');
				var email = new models.SendGrid.Email();
				var response = {};

				expect(response.errors[1]).toBe("Bad username / password");
			});




// public function testSendResponseWithAttachment() {
//     $sendgrid = new SendGrid("foo", "bar");
//     $email = new SendGrid\Email();
//     $email->setFrom('p1@mailinator.com')->
//             setSubject('foobar subject')->
//             setText('foobar text')->
//             addTo('p1@mailinator.com')->
//             addAttachment('./gif.gif');
//     $response = $sendgrid->send($email);
//     $this->assertEquals("Bad username / password", $response->errors[0]);
//   }
//   public function testSendResponseWithAttachmentMissingExtension() {
//     $sendgrid = new SendGrid("foo", "bar");
//     $email = new SendGrid\Email();
//     $email->setFrom('p1@mailinator.com')->
//             setSubject('foobar subject')->
//             setText('foobar text')->
//             addTo('p1@mailinator.com')->
//             addAttachment('./text');
//     $response = $sendgrid->send($email);
//     $this->assertEquals("Bad username / password", $response->errors[0]);
//   }

		});


		// describe("finder methods", function(){
		// 	it("finds a Film", function(){
		// 		var films = new lib.Films();
		// 		var film = films.find(1);
		// 		expect(film).toBeInstanceOf('Films');
		// 		expect(film.title).toBe('A New Hope');
		// 		expect(film.episode_id).toBe('4');
		// 		expect(film.id).toBe(1);
		// 	});

		// 	it("gets all films", function(){
		// 		var films = new lib.Films();
		// 		var films = films.all();
		// 		expect(films).toBeTypeOf('array');
		// 		expect(films[1]).toBeInstanceOf('Films');
		// 		expect(films[1].title).toBe('A New Hope');
		// 		expect(films[1].episode_id).toBe('4');
		// 	});

		// 	it("404s on non-existent records", function(){
		// 		var films = new lib.Films();
		// 		expect(function(){
		// 			var film = films.find(9999999999999);
		// 		}).toThrow("exception", "Resource not found.")
		// 	});
		// });

		// describe("fetch methods", function(){
		// 	var films = new lib.Films();
		// 	var film = films.find(1);

		// 	it("fetches starships from an array of starship uris", function(){
		// 		var starships = film.fetchStarships();
		// 		expect(starships[1]).toBeInstanceOf('Starships');
		// 	});

		// 	it("fetches species from an array of species uris", function(){
		// 		var species = film.fetchSpecies();
		// 		expect(species[1]).toBeInstanceOf('Species');
		// 	});

		// 	it("fetches planets from an array of planet uris", function(){
		// 		var planets = film.fetchPlanets();
		// 		expect(planets[1]).toBeInstanceOf('Planets');
		// 	});

		// 	it("fetches characters (synonym for people) from an array of people uris", function(){
		// 		var characters = film.fetchCharacters();
		// 		expect(characters[1]).toBeInstanceOf('People');
		// 	});

		// 	it("fetches vehicles from an array of vehicle uris", function(){
		// 		var vehicles = film.fetchVehicles();

		// 		expect(vehicles[1]).toBeInstanceOf('Vehicles');
		// 	});

		// 	it("fetches url, a uri to load", function(){
		// 		var theSameFilm = film.fetchURL();
		// 		expect(theSameFilm).toBeInstanceOf('Films');
		// 	});

		// 	it("it errors when trying to fetch something that doesn't exist", function(){
		// 		expect(function(){
		// 			film.fetchFoobarGoblledyGuck();
		// 		}).toThrow("exception", "There is no resource 'FoobarGoblledyGuck' to fetch.")
		// 	});

		// 	it("it errors when trying to fetch something that isn't a uri", function(){
		// 		expect(function(){
		// 			film.fetchTitle();
		// 		}).toThrow("exception", "Title is not a valid uri to fetch for.")
		// 	});

		// 	it("it errors when a method doesn't exist", function(){
		// 		expect(function(){
		// 			film.SomeJunkIMadeUpThatDoesntExist();
		// 		}).toThrow("exception", "There is no method with the name SomeJunkIMadeUpThatDoesntExist")
		// 	});

		// });

		// describe("Schema", function(){
		// 	it("can gets its schema", function(){
		// 		var films = new lib.Films();
		// 		var response = films.getSchema();
		// 		var schemaJSON = fileRead(getDirectoryFromPath("/tests/resources/") & "/filmsSchema.json");

		// 		expect(response).toBeTypeOf('struct');
		// 		expect(response).toBe(deserializeJSON(schemaJSON));
		// 	});
		// });

	}

}