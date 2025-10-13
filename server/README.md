# DCC Server

## General

## Design Notes

This server will be built on [ExpressJS](https://expressjs.com/en/guide/routing.html).

DB integration will use [`mysql2`](https://www.npmjs.com/package/mysql2?activeTab=readme) - which is intended to be a drop-in replacement for [`mysqljs`](https://github.com/mysqljs/mysql).

### /public
- Serves up static assets like images or documents (ie. html)

### .babelrc
- Contains an object to specify presets for babel compiler. 

### package
- Specifying `modules` type for ES files (vs commonjs)
  #### Scripts
  - Using `nodemon` on our start command to allow automatic restarts on changes to the directory
  - Flagging `--experimental-json-modules` allows us to use json files
  - `exec babel-node index.js` specifies running our entry point file using babel

#### Dependencies:
- Express can use `nodemon` to run scripts to allow automatic restarts when changes are detected in the directory. 
- In order to make Node compatible with the latest ES6 features, we'll likely want to use a compiler - using `Babel` here as dev dep.
  - This also helps ensure support with older browsers.
  - **Note: Babel has several dependencies with vulnerabilities that require updating packages with breaking changes -- further research required**
- [`express-rate-limit`](https://www.npmjs.com/package/express-rate-limit) is a simple token bucket rate limiter that tracks requests per endpoint by client IP and sends a 429 with custom message to the client when the limit is reached. 