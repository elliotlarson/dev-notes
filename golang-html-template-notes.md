# Serving an HTML response with templates

Go has a built in templating library.

Say you have this file `template.html`:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Hello</title>
￼  </head>
  <body>
    {{ . }}
  </body>
</html>
```

You can serve this up with this:

```go
func templateHandler(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("template.html"))
	t.Execute(w, "Hello, World")
}

func main() {
	http.HandleFunc("/", templateHandler)
	http.ListenAndServe(":8088", nil)
}
```

The `{{ . }}` is replaced by the object sent into the template with the `Execute` method.  In this case, the string "Hello, World".

## Working with multiple templates

You can pass multiple templates to the `ParseFiles` method.  If you do this you can execute a specific template with the `ExecuteTemplate` method.

```go
var templates = []string{"template1.html", "template2.html"}
var t = template.Must(template.ParseFiles(templates...))

func template1Handler(w http.ResponseWriter, r *http.Request) {
	t.ExecuteTemplate(w, "template1.html", "Hello, World")
}

func template2Handler(w http.ResponseWriter, r *http.Request) {
	t.ExecuteTemplate(w, "template2.html", "Hello, World")
}

func main() {
	http.HandleFunc("/one", template1Handler)
	http.HandleFunc("/two", template2Handler)
	http.ListenAndServe(":8088", nil)
}
```

## Template conditionals and loops

You can use conditional and looping logic in go templates.  The templates are mostly logicless.  You can't do things like `.PaintType == "oil"`, but you can use the `eq` function.

Say you have a template `template1.html`:

```text
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Template 1</title>
￼  </head>
  <body>
    {{ if eq .PaintType "oil" -}}
    <h1>It's an oil painting</h1>
    {{- else }}
    <h1>It's not an oil painting</h1>
    {{- end }}
    <ul>
    {{ range .Colors -}}
      <li>{{ . }}</li>
    {{ end -}}
    </ul>
  </body>
</html>
```

Notice the dashes `{{-` and `-}}`.  These remove newline characters before and after the line so you don't end up with a slew of empty lines in your template where template logic is used.

And then you render the template with:

```go
type painting struct {
	Colors    []string
	PaintType string
}

func templateHandler(w http.ResponseWriter, r *http.Request) {
	t := template.Must(template.ParseFiles("template1.html"))

	p := &painting{
		Colors:    []string{"red", "green", "blue", "purple", "orange"},
		PaintType: "oil",
	}
	t.Execute(w, p)
}

func main() {
	http.HandleFunc("/", templateHandler)
	http.ListenAndServe(":8088", nil)
}
```

## Including templates

You can include one template into another with the template directive:

```go
type user struct {
	ID    int
	Name  string
	Email string
}

type templateVars struct {
	Users     []*user
	UserCount int
}

var templates = []string{"template.html", "user.html"}
var t = template.Must(template.ParseFiles(templates...))

func templateHandler(w http.ResponseWriter, r *http.Request) {
	user1 := &user{1, "Arum Ahn", "arum@example.com"}
	user2 := &user{2, "Maddie Larson", "maddie@example.com"}
	user3 := &user{3, "Elliot Larson", "elliot@example.com"}
	users := []*user{user1, user2, user3}

	tmplVars := templateVars{
		Users:     users,
		UserCount: len(users),
	}
	t.ExecuteTemplate(w, "template.html", tmplVars)
}

func main() {
	http.HandleFunc("/", templateHandler)
	http.ListenAndServe(":8088", nil)
}
```

Master template `template.html`:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Users</title>
￼  </head>
  <body>
    <h1>Users ({{ .UserCount }})</h1>
    <table>
      <thead>
        <tr>
          <td>Name</td>
          <td>Email</td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        {{- range .Users }}
          {{ template "user.html" . -}}
        {{ else }}
          <tr>
            <td colspan="3">
              <h2>No users were found.</h2>
            </td>
          </tr>
        {{ end -}}
      </tbody>
    </table>
  </body>
</html>
```

Notice the `else` part of the `range` block.  If `.Users` is empty, the `else` section will be executed.

User details template `user.html`:

```html
<tr>
  <td>{{ .Name }}</td>
  <td>{{ .Email }}</td>
  <td>
    <a href="/users/1/edit">edit</a>
    <a href="/users/1/delete">delete</a>
  </td>
</tr>
```

## ParseGlob instead of ParseFiles

You can use a globbing method instead of naming files individually:

```go
var t = template.Must(template.ParseGlob("templates/*.gohtml"))
```

## Formatting output

You can use pipelining to format output in a template:

```go
type Product struct {
	Name  string
	Price float32
}

func templateHandler(w http.ResponseWriter, r *http.Request) {
	product := &Product{
		Name:  "Learning Go Book",
		Price: 35.959,
	}
	t := template.Must(template.ParseFiles("template.html"))
	t.Execute(w, product)
}
```

And, then formatting the price in the template with:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Users</title>
￼  </head>
  <body>
    <h1>{{ .Name }}</h1>
    <p>${{ .Price | printf "%.2f" }}</p>
  </body>
</html>
```

## Using template functions

Go template functions must only return one value, or two if the second value is an error.

To add a function for use in a template, you use the `FuncMap` function.  You need to add the functions to a template before parsing the template file, so you need to use the `template.New()` appraoch.

```go
func formatPrice(price float32) string {
	return fmt.Sprintf("$%.2f", price)
}

func templateHandler(w http.ResponseWriter, r *http.Request) {
	product := &Product{
		Name:  "Learning Go Book",
		Price: 35.959,
	}
	funcMap := template.FuncMap{
		"formatPrice": formatPrice,
	}
	t := template.Must(
		template.New("main").Funcs(funcMap).ParseFiles("template.html"),
	)
	t.ExecuteTemplate(w, "template.html", product)
}
```

And then you can use the function in your template:

```html
<p>{{ .Price | formatPrice }}</p>
```

## Nesting templates

You can nest templates by combining the `define` and `template` directives.

#### Using header and footer templates

With this approach you render the users index template, which includes header and footer templates in it to create a complete html page.

```text
.
├── main.go
└── templates
    ├── layout
    │   ├── footer.gohtml
    │   └── header.gohtml
    └── users
        ├── details.gohtml
        ├── index.gohtml
```

`main.go`

```go
type user struct {
	ID    int
	Name  string
	Email string
}

type tmplContext struct {
	PageTitle string
	Users     []*user
	UserCount int
}

func templateHandler(w http.ResponseWriter, r *http.Request) {
	user1 := &user{1, "Arum Ahn", "arum@example.com"}
	user2 := &user{2, "Maddie Larson", "maddie@example.com"}
	user3 := &user{3, "Elliot Larson", "elliot@example.com"}
	users := []*user{user1, user2, user3}

	context := tmplContext{
		Users:     users,
		UserCount: len(users),
		PageTitle: "Users Title",
	}

	templates := []string{
		"templates/layout/header.gohtml",
		"templates/layout/footer.gohtml",
		"templates/users/index.gohtml",
		"templates/users/details.gohtml",
	}
	t := template.Must(template.ParseFiles(templates...))

	t.ExecuteTemplate(w, "index.gohtml", context)
}

func main() {
	http.HandleFunc("/", templateHandler)
	http.ListenAndServe(":8088", nil)
}
```

`templates/layout/header.gohtml`

```html
{{ define "header" }}
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>{{ .PageTitle }}</title>
￼  </head>
  <body>
{{ end }}
```

`templates/layout/footer.gohtml`

```html
{{ define "footer" }}
  </body>
</html>
{{ end }}
```

`templates/users/index.gohtml`

```html
{{ template "header" . }}
<h1>Users</h1>
<table>
  <thead>
    <tr>
      <td>Name</td>
      <td>Email</td>
      <td></td>
    </tr>
  </thead>
  <tbody>
    {{- range .Users }}
      {{ template "details.gohtml" . -}}
    {{ else }}
      <tr>
        <td colspan="3">
          <h2>No users were found.</h2>
        </td>
      </tr>
    {{ end -}}
  </tbody>
</table>
{{ template "footer" }}
```

`templates/users/details.gohtml`

```html
<tr>
  <td>{{ .Name }}</td>
  <td>{{ .Email }}</td>
  <td>
    <a href="/users/{{ .ID }}/edit">edit</a>
    <a href="/users/{{ .ID }}/delete">delete</a>
  </td>
</tr>
```

#### Using a layout template

With this approach, you render a layout template with a `content` section.  The content section is then defined in the user index template which defines `content`.

```go
type user struct {
	ID    int
	Name  string
	Email string
}

type tmplContext struct {
	PageTitle string
	Users     []*user
	UserCount int
}

func templateHandler(w http.ResponseWriter, r *http.Request) {
	user1 := &user{1, "Arum Ahn", "arum@example.com"}
	user2 := &user{2, "Maddie Larson", "maddie@example.com"}
	user3 := &user{3, "Elliot Larson", "elliot@example.com"}
	users := []*user{user1, user2, user3}

	context := tmplContext{
		Users:     users,
		UserCount: len(users),
		PageTitle: "Users Title",
	}

	templates := []string{
		"templates/layout.gohtml",
		"templates/users/index.gohtml",
		"templates/users/details.gohtml",
	}
	t := template.Must(template.ParseFiles(templates...))

	t.ExecuteTemplate(w, "layout.gohtml", context)
}

func main() {
	http.HandleFunc("/", templateHandler)
	http.ListenAndServe(":8088", nil)
}
```

`templates/layout.gohtml`

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>{{ .PageTitle }}</title>
￼  </head>
  <body>
    {{ template "content" . }}
  </body>
</html>
```

`templates/users/index.gohtml`

```html
{{ define "content" }}
  <h1>Users</h1>
  <table>
    <thead>
      <tr>
        <td>Name</td>
        <td>Email</td>
        <td></td>
      </tr>
    </thead>
    <tbody>
      {{- range .Users }}
        {{ template "details.gohtml" . -}}
      {{ else }}
        <tr>
          <td colspan="3">
            <h2>No users were found.</h2>
          </td>
        </tr>
      {{ end -}}
    </tbody>
  </table>
{{ end }}
```

## Resources

* https://elithrar.github.io/article/approximating-html-template-inheritance/
* http://gohugo.io/templates/go-templates/
* https://jan.newmarch.name/go/template/chapter-template.html
* https://astaxie.gitbooks.io/build-web-application-with-golang/content/en/07.4.html
