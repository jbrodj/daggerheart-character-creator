# Daggerheart RPG Character Creator

This began as a project for CS50 Databases with SQL, and has been migrated here for further use/fun/learning. 

### What is Daggerheart?

A tabletop role-playing game in which players create composable custom characters built from modular options provided by the game system.
Characters are differentiated in the game options by their ancestry, culture, vocation & specialization (class & subclass), equipment (armor & weapons).

### What is this program desined to do?

- Reference game-provided data & mechanics from the various tables representing the respective game topics
- Create a user and new characters associated with that user instance
- Update/archive/delete existing characters
- Track dynamic in-game data that will change as a user plays through a game session

See `db/DESIGN.mg` for further details.

### Technical considerations

Database is built on MySQL @v8

### What's next?

- Consider a UI framework and how to best integrate that with existing database 
  - ie. should this run on a python server with flask or use an api integration on a react UI? 
- Update MySQL syntax to a more recent version
