# Elixir Phoenix Notes

## Getting started

Use `asdf` to manage versions of languages by adding a `.tool-versions` file to a directory you want to create your new app in.  We'll copy this into the generated app folder in a second.

```bash
$ vim .tool-versions
```

Add (alter the versions to what is currently appropriate):

```text
erlang 24.0.6
elixir 1.12.3-otp-24
nodejs 14.17.6
```

Figure out most recent versions

To find out what the most recent versions are, ask `asdf`.

Make sure the brew package is updated

```bash
$ brew upgrade asdf
```

List all available plugins for a language:

```bash
$ asdf list all nodejs
```

Install the most recent version of the phx.new command

At this time 1.6.0's first release candidate came out.  Install with:

```bash
$ mix archive.install hex phx_new 1.6.0-rc.0
```

Generate a new site

Create the foo app:

```bash
$ mix phx.new foo
```

Copy the tool versions file into the app directory

```bash
$ cp .tool-versions foo/
```

```bash
$ cd foo
$ co # my alias for opening the app with VSCode
```

## View/Templates

`my_app_web/templates/user/show.html.eex`

```elixir
<b><%= first_name(@user) %></b> (<%= @user.id %>)
```

You can view this rendered in IEX with:

```bash
$ iex -S mix
iex> Phoenix.View.render_to_string(MyAppWeb.UserView, "show.html", user: MyApp.Accounts.get_user("1"))
```
