# Kill all connections except the one we use 

By default, PostgreSQL is picky when it comes to `TRUNCATE` or `DROP` a
database. If there is an active connection to this database, the command will
fail and say:

> database database_name is being accessed by other users

To overcome this problem, you can use this SQL request to kill all sessions
except yours to the database you want to drop:

```sql
SELECT
    pg_terminate_backend(pid)
FROM
    pg_stat_activity
WHERE
    -- don't kill my own connection!
    pid <> pg_backend_pid()
    -- don't kill the connections to other databases
    AND datname = 'DATABASE_NAME'
    ;
}
```

You should be able to DROP/TRUNCATE right after you run this command from your
script.
