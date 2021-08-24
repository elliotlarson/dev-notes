# Elixir Phoenix Notes

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
