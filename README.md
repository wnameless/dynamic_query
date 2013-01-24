# dynamic_query

dynamic_query is a dynamic generated query gui for ActiveRecord.

Installation:

``` ruby
## Gemfile for Rails 3
gem 'dynamic_query'

## rails generator
rails g dynamic_query

## you may skip this step unless you want to customize your own helper
## Regenerate the helper after upgrade dynamic_query
rails g dynamic_query:helper
```

## Basic usage of dynamic_query

``` ruby
## controller of Rails 3
dq = dynamic_query(:list, :entry) # list models you wish to be queried. e.g. List => :list, AbcDef => :abc_def
@panel = dq.panel(params[:query])
@lists = List.includes(:entries).where(dq.statement(params[:query]))

## render query panel in the view:
<%= dynamic_query @panel %>
```

## Advanced usage of dynamic_query

``` ruby
# columns with name 'id' or name ended with '_id' are hided by default
# :reveal_keys => true reveals those columns in the query panel
dq = dynamic_query(:list, :entry, :reveal_keys => true)

# a white list or a black list can be defined by following options
dq = dynamic_query(:list, :entry, :accept => { :list => [:name], :entry => [:title, :priority] }, :reject => { :entry => [:title] })
# only lists.name and entries.priority can be seen on the query panel because the white list gets higher precedence than the black list

# column display names can be defined by following options
dq = dynamic_query(:list, :entry, :alias => { 'lists.name' =>  'Full Name' })
# those names are used in the html select tag

## query panel is simply a rails form_tag which means it can accept the same hash options
<%= dynamic_query @panel, :remote => true %>
```

# Contributing to dynamic_query
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# Copyright

Copyright (c) 2012 Wei-Ming Wu. See LICENSE.txt for
further details.

