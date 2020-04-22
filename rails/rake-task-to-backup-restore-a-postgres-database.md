# Rake task to backup/restore a postgres database 

A handy Rake task to backup and restore the postgreSQL database of a Rails app. You can combine it with the [Whenever](https://github/javan/whenever) gem to schedule when and how often the backup task should get done.

The full code contains:

* A `db:dump` task which backups the postgreSQL database to a file in
    `db/backups` by default. It also removes backups older than 7 days. Backups
    format is customizable ;
* A `db:dumps` task to quickly see the list of backups available ;
* A `db:restore` task to restore the database from a backup given a pattern.

These three tasks can take parameters/arguments to, for example, choose the
format of the dump or the file pattern to look for a unique dump to restore.
Feel free to dig the source code to understand how it works.

**Important:** This script was made to be called automatically with cronjobs.
Therefore, it is meant to be run without prompting the user for a database
password. PostgreSQL is looking for the environment variable `PGPASSWORD` to
use `pg_dump` and `pg_restore`. Don't forget to set it before running the
script.

```ruby
# lib/tasks/db.rake
namespace :db do
  desc 'Dumps the database to backups'
  task dump: :environment do
    dump_fmt   = ensure_format(ENV['format'])
    dump_sfx   = suffix_for_format(dump_fmt)
    backup_dir = backup_directory(Rails.env, create: true)
    full_path  = nil
    cmd        = nil
    delete_old_cmd = nil

    with_config do |_app, host, db, user|
      full_path = "#{backup_dir}/#{Time.now.strftime('%Y-%m-%d')}_#{db}.#{dump_sfx}"
      cmd = "pg_dump -F #{dump_fmt} -v -O -o -U '#{user}' -h '#{host}' -d '#{db}' -f '#{full_path}'"
      delete_old_cmd = "find #{backup_dir} -maxdepth 2 -type f -mtime +7 -exec rm -rf \"{}\" \\;"
    end

    puts cmd
    system cmd

    puts ''
    puts "Dumped to file: #{full_path}"
    puts ''

    puts delete_old_cmd
    system delete_old_cmd

    puts ''
    puts 'Deleted backups older than 7 days'
    puts ''
  end

  desc 'Show the existing database backups'
  task dumps: :environment do
    backup_dir = backup_directory
    puts backup_dir.to_s
    system "/bin/ls -ltR #{backup_dir}"
  end

  desc 'Restores the database from a backup using PATTERN'
  task restore: :environment do
    pattern = ENV['pattern']

    if pattern.nil?
      abort('Please specify a file pattern for the backup to restore')
    end

    file = nil
    cmd  = nil

    with_config do |_app, host, db, user|
      backup_dir = backup_directory
      files      = Dir.glob("#{backup_dir}/**/*#{pattern}*")

      case files.size
      when 0
        puts "No backups found for the pattern '#{pattern}'"
      when 1
        file = files.first
        fmt  = format_for_file file

        case fmt
        when nil
          puts "No recognized dump file suffix: #{file}"
        when 'p'
          cmd = "psql -U '#{user}' -h '#{host}' -d '#{db}' -f '#{file}'"
        else
          cmd = "pg_restore -F #{fmt} -v -c -C -U '#{user}' -h '#{host}' -d '#{db}' -f '#{file}'"
        end
      else
        puts "Too many files match the pattern '#{pattern}':"
        puts ' ' + files.join("\n ")
        puts ''
        puts 'Try a more specific pattern'
        puts ''
      end
    end

    unless cmd.nil?
      # kill any postgres session before working on database
      results = ActiveRecord::Base.connection.execute(%{
      SELECT
          pg_terminate_backend(pid)
      FROM
          pg_stat_activity
      WHERE
          -- don't kill my own connection!
          pid <> pg_backend_pid()
          -- don't kill the connections to other databases
          AND datname = '#{ActiveRecord::Base.connection.current_database}'
          ;
      })

      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke

      puts cmd
      system cmd
      puts ''
      puts "Restored from file: #{file}"
      puts ''
    end
  end

  private

  def ensure_format(format)
    return format if %w[c p t d].include?(format)

    case format
    when 'dump' then 'c'
    when 'sql' then 'p'
    when 'tar' then 't'
    when 'dir' then 'd'
    else 'p'
    end
  end

  def suffix_for_format(suffix)
    case suffix
    when 'c' then 'dump'
    when 'p' then 'sql'
    when 't' then 'tar'
    when 'd' then 'dir'
    end
  end

  def format_for_file(file)
    case file
    when /\.dump$/ then 'c'
    when /\.sql$/  then 'p'
    when /\.dir$/  then 'd'
    when /\.tar$/  then 't'
    end
  end

  def backup_directory(suffix = nil, create: false)
    backup_dir = File.join(*[Rails.root, 'db/backups', suffix].compact)
    puts backup_dir
    if create && !Dir.exist?(backup_dir)
      puts "Creating #{backup_dir} .."
      FileUtils.mkdir_p(backup_dir)
    end

    backup_dir
  end

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host],
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
  end
end
```

How to use:

```ruby
rake db:dump

rake db:restore pattern=2020-04-21
```

## `Whenever` gem to schedule backups with cronjobs

First add the gem to your Gemfile:

```ruby
# Gemfile
gem 'whenever', require: false
```

Then run `bundle install`. After installing the gem, you have to run `bundle exec wheneverize .` inside your Rails application folder. This will create an initial `config/schedule.rb` file for you.

Inside this file, you can add this snippet to automatically backup your Rails database every day at night:

```ruby
# config/schedule.rb

# log cronjobs output
set :output, "#{path}/log/cronjobs.log"

# backup postgres database every day
every 1.day, at: '4:30 am' do
  rake 'db:dump'
end
```

**Important:** First, be sure `cron` is installed on your system. This is not often the case with Docker as images are light in term of packages. Secondly, make sure it's running. if not, use `service cron start`. Finally, you have to make `Whenever` update your cronjobs on your system by running:

```bash
whenever --update-crontab
```

You can verify if the task was properly scheduled by typing `crontab -l` and cheek if you see your cronjob related to the backup task.

Don't forget in your dev/production workflow to use this command to update crontabs when starting your application/docker container.

Source: https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90
