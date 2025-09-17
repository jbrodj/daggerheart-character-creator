import {runSqlFile} from './init-db.js'
import path from 'path'

const MOCK_SQL_DB_PATH = path.join('./db', 'init-db.sql')
// Runs SQL commands from the `init-sql` file to populate the database with game data.
runSqlFile(MOCK_SQL_DB_PATH)