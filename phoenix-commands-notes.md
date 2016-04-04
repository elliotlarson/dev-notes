### list out mix commands
`$ mix help`

### run the console
`iex -S mix`

### create a new phoenix app
`$ mix phoenix.new pxblog`

### generate the database
`$ mix ecto.create`

### generating a migration
`$ mix ecto.gen.migration create_foo_table`

### migrate the database
`$ mix ecto.migrate`

### create and migrate the database
`$ mix do ecto.create, ecto.migrate`

### run the server
`$ iex -S mix phoenix.server`

### generate blog post scaffold
`$ mix phoenix.gen.html Post posts title:string body:string`

### generate model
`$ mix phoenix.gen.model Post posts title:string body:string`

### show the routes for the system
`$ mix phoenix.routes`

### pull in dependencies 
`$ mix deps.get`

### compile the project
`$ mix compile`

### generate a model
`$ mix phoenix.gen.model Post title:string body:string`

### running tests for a project
`$ mix test`

### running specific test file
`$ mix test test/controllers/user_controller_test.exs`

### running a specific line in a test file
`$ mix test test/controllers/user_controller_test.exs:52`