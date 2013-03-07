# dynamic_query

dynamic_query is a dynamic generated query gui for ActiveRecord.

Installation:

``` ruby
## Gemfile for Rails 3
gem 'dynamic_query'

## you may skip this step unless you want to customize your own helper
## Regenerate the helper after upgrade dynamic_query
rails g dynamic_query:helper
```

## Basic usage of dynamic_query

``` ruby
## controller of Rails 3
dq = dynamic_query(List, Entry) # put models you wish to be queried here.

@panel = dq.panel(params[:query])
@lists = List.includes(:entries).where(dq.statement(params[:query])).all

## render query panel in the view:
<%= dynamic_query @panel %>

## render query result in the view:
<%= dynamic_result @lists %>
```

## Advanced usage of dynamic_query

``` ruby
# columns with name 'id' or name ended with '_id' are hided by default
# :reveal_keys => true reveals those columns in the query panel
dq = dynamic_query(List, Entry, :reveal_keys => true)

# a white list or a black list can be defined by following options
dq = dynamic_query(List, Entry, :accept => { List => [:name], Entry => [:title, :priority] }, :reject => { Entry => [:title] })
# only lists.name and entries.priority can be seen on the query panel because the white list gets higher precedence than the black list

# column display names can be defined by following options
dq = dynamic_query(List, Entry, :alias => { 'lists.name' =>  'Full Name' })
# those names are used in the html select tag

## join tables with arbitrary columns and query
dq = dynamic_query(Model1, Mode2)
@panel = dq.panel(params[:query])
@records = Model1.
  select(all_columns_in(Model1, Model2)).
  # all_columns_in is a method to help user select all columns within models
  # you must select columns of tables you joined, otherwise columns won't show in the result
  joins(tables_joined_by(Model1, [Model2, [:col1, :col1], [:my_col, :your_col], :col3, :col4])).
  # tables_joined_by is a method to help user build inner join SQL statement between tables
  # this demonstrates how to join two tables by following correspondence columns
  # :col1 -> :col1, :my_col -> :your_col, :col3 -> :col3, :col4 -> :col4
  # if columns have the same name in 2 tables, you can simply only enter there common name
  where(dq.statement(params[:query])).all
  
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

