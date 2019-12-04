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

	var email = req.body.email;
	var password = req.body.password;


	//if user has inputed password and email search for the given email
	if (email && password) {
		req.db.query('SELECT * FROM passwords WHERE email = ?', [email], function(err, results, fields) {
			
			if (results.length > 0) {
			
				//confirm password is correct
				if(bcrypt.compareSync(password, results[0].password)){
					req.session.loggedin = true;
					res.redirect('/home'); //send to home
				}else{
									
					//TODO -- add error message saying email or password is wrong
					res.redirect('/login');	//send back to login			

				}

			} else {
				res.redirect('/login'); //send back to login

				//TODO -- add error message saying emai or password is wrong

			}			
			res.end();
		});
	} else {
		//should never get here because email and password are required fields
		res.send('Please enter Email and Password!');
		res.end();
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
	var email = req.body.email;
	let password = bcrypt.hashSync(req.body.password, 10);


	//if user has inputed password and email attempt to insert the data with the hashed password
	if(email && password && name){
		console.log('inserting into database');
		req.db.query('INSERT INTO passwords (email, password, name) VALUES (?, ?, ?)', [email, password, name], function(err, results, fields){

			//if error out, then becuase duplicate 
			if(err){
				
				//TODO -- add error message saying already exist someone with that email
	
				console.log('unsuccessful insert');	
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



/*
 *
 *All of the routings for the generic pages in the webiste
 *
 */
app.get("/home", (req, res) => {
	res.render("home");
});
app.get("/Terms", (req, res) => {
        res.render("Terms");
});
app.get("/Classes", (req, res) => {
	req.db.query('SELECT * FROM Class'), (err, results) => {
		if (err) throw err;
		console.log(results);
		res.render("Classes", {results:results});
		close(req);
	});
});
app.get("/ratings", (req, res) => {
        res.render("ratings");
});
app.get("/login", (req, res) => {
	res.render("login");
});
app.get("/register", (req, res) => {
	res.render("register");
});



/**
 * Handle all of the resources we need to clean up. In this case, we just need 
 * to close the database connection.
 * 
 * @param {Express.Request} req the request object passed to our middleware
 */
function close(req) {
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
