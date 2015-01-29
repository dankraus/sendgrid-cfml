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
				var email = new models.SendGrid.Email();
				expect(email).toBeInstanceOf('Email');
				expect(email.getTos()).toHaveLength(0);
				expect(email.getCCs()).toHaveLength(0);
				expect(email.getBCCs()).toHaveLength(0);
			});
		});

		describe("property setters, getters, and adds", function(){
			it( "adds To email addresses", function(){
				var email = new models.SendGrid.Email();
				email.addTo('p1@foo.com');
				expect(email.smtpapi.to).toBe(['p1@foo.com']);
				email.addTo('p2@foo.com');
				expect(email.getTos()).toBe(['p1@foo.com', 'p2@foo.com']);
				expect(email.smtpapi.to).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it("adds To email addresses with name", function(){
				var email = new models.SendGrid.Email();
				email.addTo('p1@foo.com', 'Person One');
				expect(email.smtpapi.to).toBe(['Person One <p1@foo.com>']);
				email.addTo('p2@foo.com', 'Person Two');
				expect(email.getTos()).toBe(['Person One <p1@foo.com>', 'Person Two <p2@foo.com>']);
				expect(email.smtpapi.to).toBe(['Person One <p1@foo.com>', 'Person 2 <p2@foo.com>']);
			});
			it( "sets To email addressses with an array and replaces all others", function(){
				var email = new models.SendGrid.Email();
				var addresses = ['p1@foo.com', 'p2@foo.com']
				email.addTo('p3@foo.com');
				email.setTos(addresses);
				expect(email.getTos()).toBe(['p1@foo.com', 'p2@foo.com']);
				expect(email.smtpapi.to).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it( "sets/gets From email address", function(){
				var email = new models.SendGrid.Email();
				email.setFrom('p3@foo.com');
				expect(email.getFrom()).toBe('p3@foo.com');
			});
			it( "sets/gets From email address with name", function(){
				var email = new models.SendGrid.Email();
				email.setFrom('p3@foo.com');
				email.setFromName('Han Solo');
				expect(email.getFrom()).toBe('p3@foo.com');
				expect(email.getFrom(true)).toBe({'p3@foo.com': 'Han Solo'});
				expect(email.getFromName()).toBe('Han Solo');
			});
			it( "sets/gets Reply To address", function(){
				var email = new models.SendGrid.Email();
				email.setReplyTo('p@foo.com');
				expect(email.getReplyTo()).toBe('p@foo.com');
			});
			it( "sets/gets Reply To address", function(){
				var email = new models.SendGrid.Email();
				email.setReplyTo('p@foo.com');
				expect(email.getReplyTo()).toBe('p@foo.com');
			});
			it( "sets/gets CC address", function(){
				var email = new models.SendGrid.Email();
				email.setCC('p@foo.com');
				email.setCC('p2@foo.com');
				expect(email.getCCs()).toBe(['p2@foo.com']);
			});
			it( "sets/gets CCs addresses", function(){
				var email = new models.SendGrid.Email();
				var ccS = ['p1@foo.com', 'p2@foo.com'];
				email.setCCs(ccS);
				expect(email.getCCs()).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it( "adds CC addresses", function(){
				var email = new models.SendGrid.Email();
				email.addCC('p1@foo.com');
				email.addCC('p2@foo.com');
				expect(email.getCCs()).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it( "removes CC address", function(){
				var email = new models.SendGrid.Email();
				email.addCC('p1@foo.com');
				email.addCC('p2@foo.com');
				email.removeCC('p1@foo.com');
				expect(email.getCCs()).toBe(['p2@foo.com']);
			});
			it( "sets/gets BCC address", function(){
				var email = new models.SendGrid.Email();
				email.setBCC('p@foo.com');
				email.setBCC('p2@foo.com');
				expect(email.getBCCs()).toBe(['p2@foo.com']);
			});
			it( "sets/gets BBCs addresses", function(){
				var email = new models.SendGrid.Email();
				var bccS = ['p1@foo.com', 'p2@foo.com'];
				email.setBCCs(bccS);
				expect(email.getBCCs()).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it( "adds BCC addresses", function(){
				var email = new models.SendGrid.Email();
				email.addBCC('p1@foo.com');
				email.addBCC('p2@foo.com');
				expect(email.getBCCs()).toBe(['p1@foo.com', 'p2@foo.com']);
			});
			it( "removes BCC address", function(){
				var email = new models.SendGrid.Email();
				email.addBCC('p1@foo.com');
				email.addBCC('p2@foo.com');
				email.removeBCC('p1@foo.com');
				expect(email.getBCCs()).toBe(['p2@foo.com']);
			});
			it( "sets/gets subject", function(){
				var email = new models.SendGrid.Email();
				email.setSubject('Gold Jerry, Gold!');
				expect(email.getSubject()).toBe('Gold Jerry, Gold!');
			});
		});

// public function testSetDate() {
//     $email = new SendGrid\Email();
//     date_default_timezone_set('America/Los_Angeles');
//     $date = date('r');
//     $email->setDate($date);
//     $this->assertEquals($date, $email->getDate());
//   }

//   public function testSetSendAt() {
//     $email = new SendGrid\Email();

//     $email->setSendAt(1409348513);
//     $this->assertEquals("{\"send_at\":1409348513}", $email->smtpapi->jsonString());
//   }

//   public function testSetSendEachAt() {
//     $email = new SendGrid\Email();

//     $email->setSendEachAt(array(1409348513, 1409348514, 1409348515));
//     $this->assertEquals("{\"send_each_at\":[1409348513,1409348514,1409348515]}", $email->smtpapi->jsonString());
//   }

//   public function testAddSendEachAt() {
//     $email = new SendGrid\Email();
//     $email->addSendEachAt(1409348513);
//     $email->addSendEachAt(1409348514);
//     $email->addSendEachAt(1409348515);
//     $this->assertEquals("{\"send_each_at\":[1409348513,1409348514,1409348515]}", $email->smtpapi->jsonString());
//   }
//   public function testSetText() {
//     $email = new SendGrid\Email();
//     $text = "sample plain text";
//     $email->setText($text);
//     $this->assertEquals($text, $email->getText());
//   }
//   public function testSetHtml() {
//     $email = new SendGrid\Email();
//     $html = "<p style = 'color:red;'>Sample HTML text</p>";
//     $email->setHtml($html);
//     $this->assertEquals($html, $email->getHtml());
//   }
//   public function testSetAttachments() {
//     $email = new SendGrid\Email();
//     $attachments =
//       array(
//         "path/to/file/file_1.txt",
//         "../file_2.txt",
//         "../file_3.txt"
//       );
//     $email->setAttachments($attachments);
//     $msg_attachments = $email->getAttachments();
//     $this->assertEquals(count($attachments), count($msg_attachments));
//     for($i = 0; $i < count($attachments); $i++) {
//       $this->assertEquals($attachments[$i], $msg_attachments[$i]['file']);
//     }
//   }
//   public function testSetAttachmentsWithCustomFilename() {
//     $email = new SendGrid\Email();
//     $array_of_attachments =
//       array(
//         "customName.txt" => "path/to/file/file_1.txt",
//         'another_name_|.txt' => "../file_2.txt",
//         'custom_name_2.zip' => "../file_3.txt"
//       );
//     $email->setAttachments($array_of_attachments);
//     $attachments = $email->getAttachments();
//     $this->assertEquals($attachments[0]['custom_filename'], 'customName.txt');
//     $this->assertEquals($attachments[1]['custom_filename'], 'another_name_|.txt');
//     $this->assertEquals($attachments[2]['custom_filename'], 'custom_name_2.zip');
//   }
//   public function testAddAttachment() {
//     $email = new SendGrid\Email();
//     //ensure that addAttachment appends to the list of attachments
//     $email->addAttachment("../file_4.png");
//     $attachments[] = "../file_4.png";
//     $msg_attachments = $email->getAttachments();
//     $this->assertEquals($attachments[count($attachments) - 1], $msg_attachments[count($msg_attachments) - 1]['file']);
//   }
//   public function testAddAttachmentCustomFilename() {
//     $email = new SendGrid\Email();
//     $email->addAttachment("../file_4.png", "different.png");
//     $attachments = $email->getAttachments();
//     $this->assertEquals($attachments[0]['custom_filename'], 'different.png');
//     $this->assertEquals($attachments[0]['filename'], 'file_4');
//   }
//   public function testSetAttachment() {
//     $email = new SendGrid\Email();
//     //Setting an attachment removes all other files
//     $email->setAttachment("only_attachment.sad");
//     $this->assertEquals(1, count($email->getAttachments()));
//     //Remove an attachment
//     $email->removeAttachment("only_attachment.sad");
//     $this->assertEquals(0, count($email->getAttachments()));
//   }
//   public function testSetAttachmentCustomFilename() {
//     $email = new SendGrid\Email();
//     //Setting an attachment removes all other files
//     $email->setAttachment("only_attachment.sad", "different");
//     $attachments = $email->getAttachments();
//     $this->assertEquals(1, count($attachments));
//     $this->assertEquals($attachments[0]['custom_filename'], 'different');
//     //Remove an attachment
//     $email->removeAttachment("only_attachment.sad");
//     $this->assertEquals(0, count($email->getAttachments()));
//   }
//   public function testAddAttachmentWithoutExtension() {
//     $email = new SendGrid\Email();
//     //ensure that addAttachment appends to the list of attachments
//     $email->addAttachment("../file_4");
//     $attachments[] = "../file_4";
//     $msg_attachments = $email->getAttachments();
//     $this->assertEquals($attachments[count($attachments) - 1], $msg_attachments[count($msg_attachments) - 1]['file']);
//   }
//   public function testCategoryAccessors() {
//     $email = new SendGrid\Email();
//     $email->setCategories(array('category_0'));
//     $this->assertEquals("{\"category\":[\"category_0\"]}", $email->smtpapi->jsonString());
//     $categories = array(
//                     "category_1",
//                     "category_2",
//                     "category_3",
//                     "category_4"
//                   );
//     $email->setCategories($categories);
//     // uses valid json
//     $this->assertEquals("{\"category\":[\"category_1\",\"category_2\",\"category_3\",\"category_4\"]}", $email->smtpapi->jsonString());
//   }
//   public function testSubstitutionAccessors() {
//     $email = new SendGrid\Email();
//     $substitutions = array(
//                       "sub_1" => array("val_1.1", "val_1.2", "val_1.3"),
//                       "sub_2" => array("val_2.1", "val_2.2"),
//                       "sub_3" => array("val_3.1", "val_3.2", "val_3.3", "val_3.4"),
//                       "sub_4" => array("val_4.1", "val_4.2", "val_4.3")
//                     );
//     $email->setSubstitutions($substitutions);
//     $this->assertEquals("{\"sub\":{\"sub_1\":[\"val_1.1\",\"val_1.2\",\"val_1.3\"],\"sub_2\":[\"val_2.1\",\"val_2.2\"],\"sub_3\":[\"val_3.1\",\"val_3.2\",\"val_3.3\",\"val_3.4\"],\"sub_4\":[\"val_4.1\",\"val_4.2\",\"val_4.3\"]}}", $email->smtpapi->jsonString());
//   }
//   public function testSectionAccessors()
//   {
//     $email = new SendGrid\Email();
//     $sections = array(
//                       "sub_1" => array("val_1.1", "val_1.2", "val_1.3"),
//                       "sub_2" => array("val_2.1", "val_2.2"),
//                       "sub_3" => array("val_3.1", "val_3.2", "val_3.3", "val_3.4"),
//                       "sub_4" => array("val_4.1", "val_4.2", "val_4.3")
//                     );
//     $email->setSections($sections);
//     $this->assertEquals("{\"section\":{\"sub_1\":[\"val_1.1\",\"val_1.2\",\"val_1.3\"],\"sub_2\":[\"val_2.1\",\"val_2.2\"],\"sub_3\":[\"val_3.1\",\"val_3.2\",\"val_3.3\",\"val_3.4\"],\"sub_4\":[\"val_4.1\",\"val_4.2\",\"val_4.3\"]}}", $email->smtpapi->jsonString());
//   }
//   public function testUniqueArgsAccessors() {
//     $email = new SendGrid\Email();
//     $unique_arguments = array(
//                       "sub_1" => array("val_1.1", "val_1.2", "val_1.3"),
//                       "sub_2" => array("val_2.1", "val_2.2"),
//                       "sub_3" => array("val_3.1", "val_3.2", "val_3.3", "val_3.4"),
//                       "sub_4" => array("val_4.1", "val_4.2", "val_4.3")
//                     );
//     $email->setUniqueArgs($unique_arguments);
//     $this->assertEquals("{\"unique_args\":{\"sub_1\":[\"val_1.1\",\"val_1.2\",\"val_1.3\"],\"sub_2\":[\"val_2.1\",\"val_2.2\"],\"sub_3\":[\"val_3.1\",\"val_3.2\",\"val_3.3\",\"val_3.4\"],\"sub_4\":[\"val_4.1\",\"val_4.2\",\"val_4.3\"]}}", $email->smtpapi->jsonString());
//     $email->addUniqueArg('uncle', 'bob');
//     $this->assertEquals("{\"unique_args\":{\"sub_1\":[\"val_1.1\",\"val_1.2\",\"val_1.3\"],\"sub_2\":[\"val_2.1\",\"val_2.2\"],\"sub_3\":[\"val_3.1\",\"val_3.2\",\"val_3.3\",\"val_3.4\"],\"sub_4\":[\"val_4.1\",\"val_4.2\",\"val_4.3\"],\"uncle\":\"bob\"}}", $email->smtpapi->jsonString());
//   }
//   public function testHeaderAccessors() {
//     // A new message shouldn't have any RFC-822 headers set
//     $message = new SendGrid\Email();
//     $this->assertEquals('{}', $message->smtpapi->jsonString());
//     // Add some message headers, check they are correctly stored
//     $headers = array(
//     'X-Sent-Using' => 'SendGrid-API',
//     'X-Transport'  => 'web',
//     );
//     $message->setHeaders($headers);
//     $this->assertEquals($headers, $message->getHeaders());
//     // Add another header, check if it is stored
//     $message->addHeader('X-Another-Header', 'first_value');
//     $headers['X-Another-Header'] = 'first_value';
//     $this->assertEquals($headers, $message->getHeaders());
//     // Replace a header
//     $message->addHeader('X-Another-Header', 'second_value');
//     $headers['X-Another-Header'] = 'second_value';
//     $this->assertEquals($headers, $message->getHeaders());
//     // Get the encoded headers; they must be a valid JSON
//     $json = $message->getHeadersJson();
//     $decoded = json_decode($json, TRUE);
//     $this->assertInternalType('array', $decoded);
//     // Test we get the same message headers we put in the message
//     $this->assertEquals($headers, $decoded);
//     // Remove a header
//     $message->removeHeader('X-Transport');
//     unset($headers['X-Transport']);
//     $this->assertEquals($headers, $message->getHeaders());
//   }
//   public function testToWebFormatWithDate() {
//     $email    = new SendGrid\Email();
//     date_default_timezone_set('America/Los_Angeles');
//     $date = date('r');
//     $email->setDate($date);
//     $json     = $email->toWebFormat();
//     $this->assertEquals($json['date'], $date);
//   }

//   public function testToWebFormatWithSetSendAt() {
//     $email = new SendGrid\Email();
//     $email->setSendAt(1409348513);
//     $json     = $email->toWebFormat();
//     $xsmtpapi = json_decode($json["x-smtpapi"]);

//     $this->assertEquals(1409348513, $xsmtpapi->send_at);
//   }
//   public function testToWebFormatWithSetSendEachAt() {
//     $email = new SendGrid\Email();
//     $email->setSendEachAt(array(1409348513, 1409348514));
//     $json     = $email->toWebFormat();
//     $xsmtpapi = json_decode($json["x-smtpapi"]);

//     $this->assertEquals(array(1409348513, 1409348514), $xsmtpapi->send_each_at);
//   }

//   public function testToWebFormatWithAddSendEachAt() {
//     $email = new SendGrid\Email();
//     $email->addSendEachAt(1409348513);
//     $email->addSendEachAt(1409348514);
//     $json     = $email->toWebFormat();
//     $xsmtpapi = json_decode($json["x-smtpapi"]);

//     $this->assertEquals(array(1409348513, 1409348514), $xsmtpapi->send_each_at);
//   }
//   public function testToWebFormatWithTo() {
//     $email    = new SendGrid\Email();
//     $email->addTo('foo@bar.com');
//     $email->setFrom('from@site.com');
//     $json     = $email->toWebFormat();
//     $xsmtpapi = json_decode($json["x-smtpapi"]);
//     $this->assertEquals($xsmtpapi->to, array('foo@bar.com'));
//     $this->assertEquals($json['to'], 'from@site.com');
//   }
//   public function testToWebFormatWithToAndBcc() {
//     $email    = new SendGrid\Email();
//     $email->addTo('p1@mailinator.com');
//     $email->addBcc('p2@mailinator.com');
//     $json     = $email->toWebFormat();
//     $this->assertEquals($json['bcc'], array('p2@mailinator.com'));
//     $this->assertEquals($json["x-smtpapi"], '{"to":["p1@mailinator.com"]}');
//   }
//   public function testToWebFormatWithAttachment() {
//     $email    = new SendGrid\Email();
//     $email->addAttachment('./gif.gif');
//     $json     = $email->toWebFormat();
//     // php 5.5 works differently. @filename has been deprecated for CurlFile in 5.5
//     if (class_exists('CurlFile')) {
//       $content = new \CurlFile('./gif.gif', 'gif', 'gif');
//       $this->assertEquals($json["files[gif.gif]"], $content);
//     } else {
//       $this->assertEquals($json["files[gif.gif]"], "@./gif.gif");
//     }
//   }

//   public function testToWebFormatWithAttachmentAndCid() {
//     $email    = new SendGrid\Email();
//     $email->addAttachment('./gif.gif', null, 'sample-cid');
//     $email->addAttachment('./gif.gif', 'gif2.gif', 'sample-cid-2');
//     $json     = $email->toWebFormat();
//     // php 5.5 works differently. @filename has been deprecated for CurlFile in 5.5
//     if (class_exists('CurlFile')) {
//       $content = new \CurlFile('./gif.gif', 'gif', 'gif');
//       $this->assertEquals($json["files[gif.gif]"], $content);
//     } else {
//       $this->assertEquals($json["files[gif.gif]"], "@./gif.gif");
//     }
//     $this->assertEquals($json["content[gif.gif]"], "sample-cid");
//     $this->assertEquals($json["content[gif2.gif]"], "sample-cid-2");
//   }

//   public function testToWebFormatWithSetAttachmentAndCid() {
//     $email    = new SendGrid\Email();
//     $email->setAttachment('./gif.gif', null, 'sample-cid');
//     $json     = $email->toWebFormat();
//     // php 5.5 works differently. @filename has been deprecated for CurlFile in 5.5
//     if (class_exists('CurlFile')) {
//       $content = new \CurlFile('./gif.gif', 'gif', 'gif');
//       $this->assertEquals($json["files[gif.gif]"], $content);
//     } else {
//       $this->assertEquals($json["files[gif.gif]"], "@./gif.gif");
//     }
//     $this->assertEquals($json["content[gif.gif]"], "sample-cid");
//   }
//   public function testToWebFormatWithAttachmentCustomFilename() {
//     $email    = new SendGrid\Email();
//     $email->addAttachment('./gif.gif', 'different.jpg');
//     $json     = $email->toWebFormat();
//     // php 5.5 works differently. @filename has been deprecated for CurlFile in 5.5
//     if (class_exists('CurlFile')) {
//       $content = new \CurlFile('./gif.gif', 'gif', 'gif');
//       $this->assertEquals($json["files[different.jpg]"], $content);
//     } else {
//       $this->assertEquals($json["files[different.jpg]"], "@./gif.gif");
//     }
//   }
//   public function testToWebFormatWithHeaders() {
//     $email    = new SendGrid\Email();
//     $email->addHeader('X-Sent-Using', 'SendGrid-API');
//     $json     = $email->toWebFormat();
//     $headers = json_decode($json['headers'], TRUE);
//     $this->assertEquals('SendGrid-API', $headers['X-Sent-Using']);
//   }
//   public function testToWebFormatWithFilters() {
//     $email    = new SendGrid\Email();
//     $email->addFilter("footer", "text/plain", "Here is a plain text footer");
//     $json     = $email->toWebFormat();
//     $xsmtpapi = json_decode($json['x-smtpapi'], TRUE);
//     $this->assertEquals('Here is a plain text footer', $xsmtpapi['filters']['footer']['settings']['text/plain']);
//   }



	}

}