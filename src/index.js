/**
 * Node.js Web Application Template
 * 
 * The code below serves as a starting point for anyone wanting to build a
 * website using Node.js, Express, Handlebars, and MySQL. You can also use
 * Forever to run your service as a background process.
 */
const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const exphbs = require('express-handlebars');
const mysql = require('mysql');
const path = require('path');
const bcrypt = require('bcrypt');
const fs = require('fs');


const app = express();

// Configure handlebars
const hbs = exphbs.create({
  defaultLayout: 'main',
  extname: '.hbs'
});

// Configure the views
app.engine('hbs', hbs.engine);
app.set('view engine', 'hbs');
app.set('views', path.join(path.basename(__dirname), 'views'));

// Setup static content serving
app.use(express.static(path.join(path.basename(__dirname), 'public')));


//let express know we are using some of its packages
app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());




/**
 * Create a database connection. This is our middleware function that will
 * initialize a new connection to our MySQL database on every request.
 */
const config = require('./config');
function connectDb(req, res, next) {
  console.log('Connecting to the database');
  let connection = mysql.createConnection(config);
  connection.connect();
  req.db = connection;
  console.log('Database connected');
  next();
}

/**
 * This is the handler for our main page. The middleware pipeline includes
 * our custom `connectDb()` function that creates our database connection and
 * exposes it as `req.db`.
 */
app.get('/', connectDb, function(req, res) {
  console.log('Got request for the home page');

  res.render('home');

  close(req);
});



/*
 *
 *This handler is the post operation once the user has logged in
 *It will authenticate the user and compare the passwords and email
 *If it is a successful login in the user will go back to the home page
 *
 */
app.post('/auth', connectDb, function(req, res) {

	req.session.loggedin = false;
	var username = req.body.username;
	var password = req.body.password;

	//if user has inputed password and email search for the given email
	if (username && password) {
		req.db.query('SELECT * FROM Professor WHERE username = ?', [username], function(err, results, fields) {
			
			if (results.length > 0) {
			
				//confirm password is correct
				if(bcrypt.compareSync(password, results[0].password)){
					req.session.loggedin = true;
					loggedin = true;
					res.redirect('/home'); //send to home
				}else{
									
					req.session.error = true;
					res.redirect('/login');	//send back to login			

				}

			} else {

				req.session.error = true;
				res.redirect('/login');	//send back to login

			}			
			res.end();
		});
	}
});


/**
 *
 *This handler takes is the post operation once a user registers
 *Upon a successful register, it will insert the data into the database and send the user to home page
 *
 */

app.post('/insert', connectDb, function(req, res) {

	var name = req.body.name;
	var username = req.body.username;
	var email = req.body.email;
	var password = req.body.password;

	bcrypt.hash(password, 10, function(err, hash) {

		//if user has inputed password and email attempt to insert the data with the hashed password
		if(email && hash && username && name){
			console.log('inserting into database');
			req.db.query('INSERT INTO Professor (email, password,username, name) VALUES (?, ?, ?, ?)', [email, hash,username, name], function(err, results, fields){

				//if error out, then becuase duplicate 
				if(err){
					
		
					console.log('unsuccessful insert');	
					req.session.error = true;
					res.redirect('/register'); //send back to reg. page			

				}else{
					
					//if successful login, then set variable and send to the home page
					console.log('successful insert');
					req.session.loggedin= true;
					res.redirect('/home');
			
				}

				res.end();
			});
		}else{

			//should never get here becuase ever field is required
			res.end();
			
		}
	});


});

/**
 * 
 * Simple logout out route to remove the status of being logged in
 * 
 */
app.get('/logout', function(req, res) {

	req.session.loggedin = false;
	res.redirect('/home');

});


app.post('/insert-rating', connectDb, function(req, res) {

	console.log(req.body);

	//all of the data to insert into the rating tuple in the db
	var studentID = req.body.studentID;
	var term = req.body.term;
	var courseID = req.body.class;
	var nmbScale = req.body.scale;
	var comment =req.body.comment;

	//random number for submisionID
	var subID = Math.floor(Math.random() * 999999) + 100000;


	//if user has inputed password and email attempt to insert the data with the hashed password
	if(studentID && term && courseID && nmbScale){
		console.log('inserting into database');
		req.db.query('INSERT INTO Rating (comment, number_scale, submissionID, student_id, course_id) VALUES (?, ?, ?, ?, ?)', [comment, nmbScale, subID, studentID, courseID], function(err, results, fields){

			//if error out, then becuase duplicate 
			if(err){
				var errorM = err.message;
				var errorM2 = errorM.slice((errorM.indexOf(":") + 2), errorM.length);

				console.log('unsuccessful insert');	
				req.session.error = true; //record that there was an error
				req.session.errorMessage = errorM2;
				console.log(req.session.errorMessage);
				res.redirect("/addRating"); //send back to reg. page			

			}else{
				
				//if successful insert, then redirect to home
				console.log('successful insert');
				res.redirect('/home');
		
			}

			res.end();
		});
	}else{

		//should never get here becuase ever field is required
		res.end();
		
	}





});	


/*
 *
 *All of the routings for the generic pages in the webiste
 *
 */
app.get("/home", (req, res) => {
	if(req.session.loggedin == true){
		res.render("home", {logStatus: "true"});
	}else{
		res.render("home");
	}	
});




app.get("/Students", connectDb, (req, res) => {
	req.db.query('SELECT * FROM Student', (err, results) => {
	  if (err) throw err;

	  if(req.session.loggedin == true){
			res.render("Students", {logStatus: "true", results:results});
		}else{
			res.render("Students", {results:results});
		}	

	  close(req);
	});
});
app.post("/ratings_student", connectDb, (req, res) => {

	//get course id of class to populate ratings with
	var studentID = req.body.sid;
	console.log(studentID);

	//if user has inputed password and email search for the given email
	if (studentID) {
		req.db.query('SELECT R.student_id, S.name as sname, H.season, H.year, R.course_id,C.name ,R.number_scale,R.comment FROM Rating R, Student S,has H, Professor P, Class C WHERE R.student_id = ? AND S.student_id = ? AND H.course_id = R.course_id AND R.course_id= C.course_id GROUP BY R.course_id;',[studentID, studentID], function(err, results, fields) {
			if(err) throw err;

			if (results.length > 0) {
			
				//get name of student for title
				var title = results[0].sname;
				console.log(title);

				if(req.session.loggedin == true){
					res.render("ratings_student", {logStatus: "true", results:results, title: title});
				}else{
					res.render("ratings_student", {results:results, title: title});
				}	
			
			}

			close(req);
		});
	}
});






app.get("/Classes", connectDb, (req, res) => {
	req.db.query('SELECT * FROM Class', (err, results) => {
		if (err) throw err;

		if(req.session.loggedin == true){
			res.render("Classes", {logStatus: "true", results:results});
		}else{
			res.render("Classes", {results:results});
		}	

		close(req);
	});
});
app.post("/ratings_class", connectDb, (req, res) => {

	//get course id of class to populate ratings with
	var courseID = req.body.cid;
	console.log(courseID);

	//if user has inputed password and email search for the given email
	if (courseID) {
		req.db.query('SELECT R.comment, R.number_scale, R.student_id, R.course_id, S.name, S.student_id, C.name as cname FROM Student S, Rating R, Class C WHERE S.student_id = R.student_id AND C.course_id = ? AND R.course_id = ?;', [courseID, courseID], function(err, results, fields) {
			if(err) throw err;

			if (results.length > 0) {

				//get name of class for title
				var title = results[0].cname;								console.log(title);
				
			
				if(req.session.loggedin == true){
					res.render("ratings_class", {logStatus: "true", results:results, title: title});
				}else{
					res.render("ratings_class", {results:results, title: title});
				}	
			
			}

			close(req);
		});
	}
});






app.get("/ratings", connectDb, (req, res) => {
	req.db.query('SELECT R.student_id, R.submissionID, S.name as sname, H.season, H.year, R.course_id,C.name ,R.number_scale,R.comment FROM Rating R, Student S,has H, Professor P, Class C WHERE R.student_id = S.student_id AND H.course_id = R.course_id AND R.course_id= C.course_id GROUP BY R.submissionID;', (err, results) => {
	  if (err) throw err;

	  if(req.session.loggedin == true){
			res.render("ratings", {logStatus: "true", results: results});
		}else{
			res.render("ratings", {results, results});
		}
	  close(req);
	});
  });







app.get("/login", (req, res) => {
	if(req.session.error){
		res.render("login", {errorMessage: "*Wrong email or password"});
		req.session.error = false;
	}else{
		res.render("login", {errorMessage: ""});
	}
});






app.get("/register", (req, res) => {
	if(req.session.loggedin == true){
		if(req.session.error){
			res.render("register", {logStatus: "true", errorMessage: "*Username already taken"});
			req.session.error = false;
		}else{
			res.render("register", {logStatus: "true", errorMessage: ""});
		}
	}else{
		if(req.session.error){
			res.render("register", {errorMessage: "*Username already taken"});
			req.session.error = false;
		}else{
			res.render("register", {errorMessage: ""});
		}
	}
});






app.get("/addRating", connectDb, (req, res) => {


	req.db.query('SELECT * FROM Term', (err, results) => {
		
		if(err) throw err;
		console.log(results);
		
		//also send logged in data
		if(req.session.loggedin == true){
			if(req.session.error){
				res.render("addRating", {logStatus: "true", Students: results, errorMessage: req.session.errorMessage});
				req.session.error = false;
			}else{
				res.render("addRating", {logStatus: "true", Students: results, errorMessage: ""});
			}
		}else{
			if(req.session.error){
				res.render("addRating", {Students: results, errorMessage: req.session.errorMessage});
				req.session.error = false;
			}else{
				res.render("addRating", {Students: results, errorMessage: ""});
			}
		}

		close(req);

	});
});


/**
 * Handle all of the resources we need to clean up. In this case, we just need 
 * to close the database connection.
 * 
 * @param {Express.Request} req the request object passed to our middleware
 */
function close(req) {
// //delete sesion variable logged in
// req.session.loggedin = false;

if (req.db) {
    req.db.end();
    req.db = undefined;
    console.log('Database connection closed');
  }
}

/**
 * Capture the port configuration for the server. We use the PORT environment
 * variable's value, but if it is not set, we will default to port 3000.
 */
const port = process.env.PORT || 3000;

/**
 * Start the server.
 */
app.listen(port, function() {
  console.log('== Server is listening on port', port);
});
