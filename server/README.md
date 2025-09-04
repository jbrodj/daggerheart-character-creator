# DCC Server

## General

## Design Notes

This server will be built on ExpressJS.
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