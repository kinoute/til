# Execute Rake tasks from ruby script 

When creating custom ruby scripts for your Ruby on Rails application, you might
need to call some rake tasks within the script.

Let's say we want to setup our database by calling `rake db:setup` from our ruby
script running in the same environment as our RoR application. To call this
rake task from our script, we can do:

```ruby
# script is located in lib/tasks/custom.rb

# load our RoR environment just like "rails console" does (to access models, not needed)
require File.expand_path('../../config/environment', __dir__)
require 'rake'

Rails.application.load_tasks

# setup database
Rake::Task['db:setup'].invoke
```

We first load our RoR environment to gain access to everything related to our
application (not needed). Then we load and run the rake task `db:setup`.

To run the script: `bundle exec lib/tasks/custom.rb`
