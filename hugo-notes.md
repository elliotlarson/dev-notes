# Hugo Notes

## Basic structure when you generate a site

You can generate a new site with:

```bash
$ hugo new site my-site
```

This generates the following directory and files:

```text
my-site
├── archetypes
│   └── default.md
├── assets
├── config.toml
├── content
├── data
├── layouts
├── public
├── static
└── themes
```

* `archetypes` - Markdown templates for various types of content used when generating new content
* `assets` - files used for processing assets with Hugo Pipes (asset pre-compilation)
* `config.toml` - sitewide configuration
* `content` - content for your site, potentially organized into directories, like `blog`
* `data` - data, like json, that can be used to generate content.
* `layouts` - templates used as the basis for your site
* `public` - when you generate a production build of hugo the files to in here.  This is what you deploy to your webserver
* `static` - static files like images, stylesheets, javascripts, etc. - these files are just copied over during site build
* `themes` - where you install themes used to provide look and feel for your site

## Layouts

Like Rails, Hugo has a concept of a page template called a layout.  You can have multiple layouts.

The layouts use the Go template language: https://astaxie.gitbooks.io/build-web-application-with-golang/content/en/07.4.html

You can access data in the `config.toml` file with:

```go-template
{{ .Site.Title }}
```

Content templates can have "front matter" or data in the head, using embedded Yaml:

```markdown
---
sup: yo
---
```

You can use this in a template like so:

```go-template
{{ .Page.Sup }}
```

You can render the content of a page in a layout with:

```go-template
{{ .Content }}
```

## Creating content

You can use a command to create content pages.  The pages use archetypes as templates so you don't have to repeatedly add the same things to your page.

For exmaple, checkout the `archetypes/default.md` that gets generated when you first generate your site:


```markdown
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
---
```

This is the default front matter, but it has some Go template enhancements to generate the page title from the file name you used and it places the current datetime.

You can generate a new page with this using a generator command:

```bash
$ hugo new about.md
```

this will generate `/content/about.md` using the `archetypes/default.md` as a template and it will produce:

```markdown
---
title: "About"
date: 2022-11-27T11:44:10-08:00
draft: true
---
```

The `draft: true` line means the page will not be generated when you build the site.  If you remove the line, the file will be generated.

Note that this page will not work without a single page layout (see below).

If you want to view draft pages while developing, you can pass a flag to the hugo server command:

```bash
$ hugo server --buildDrafts
```

### Layout Templates

Hugo has the notion of two main types of page templates and a special case template.

The two main types are `single` and `list`.

If you have content in a directory directly descended from the content directory, Hugo will automatically use the list template to generate content for it.

The list template is meant to list sections/pages of content in that section of the site, providing links to get to them.  Think of a blog articles list page.

The single template is used for all other pages and is meant to be like a details page.

The other special type of page template is the homepage template.  Since it's common to have a unique homepage, if you have an `_index.md` file in the root of your content page and an `index.html` page in your `layouts/_default` directory this will display a unique homepage.

Templates are stored in:

```text
layouts
├── _default
│   ├── baseof.html
│   ├── list.html
│   └── single.html
├── index.html
```

### Block templates

The `baseof.html` template is a block template providing consistent HTML head and footer structure.

It looks something like:

```go-template
<!DOCTYPE html>
<html lang="{{ .Language.Lang }}">
  <head>
    {{ partial "head.html" . }}
  </head>
  <body>
    {{ block "main" . }}{{ end }}
    {{ partial "footer.html" . }}
  </body>
</html>
```

The important part is the `{{ block "main" . }}{{ end }}`.  This allows us to add something like the following in our page templates:

```go-template
{{ define "main" }}
Template specific content.
{{ end }}
```

That way you only have to specify the HTML page structure once.

### Specific page template overrides

By default Hugo will use a list or single page template for a content page, but you can override this with a specific template.

Let's say you want to create a unique contact page design.  You can create a `layouts/_default/contact.html` template with unique HTML and this will get used for the `content/contact.md` content file.

Then in your `content/contact.md` content file, you need to specify the specific template layout override to use in your front matter:

```yaml
layout: contact
```

## Front matter

In addition to a number of predefined front matter items that Hugo uses, you can add your own custom front matter items, like:

```markdown
show_comments: false
```

This can then be accessed in a template with

```go-template
{{ .Params.show_comments }}
```

Note: oddly the first letter of the variable is not case sensitive, so you could also access the show_comments value like this:

```go-template
{{ .Params.Show_comments }}
```

Note that predefined, common font matter variables added by Hugo can be accessed directly with:

```go-template
{{ .Title }}
```

But, custom variables that you add to the front matter need to be accessed with the `.Params` prefix.

You can also create inline variables in your templates:

```go-template
{{ $imagedir := "img/bugs/svg/" }}
{{ $imagename := print .Params.hashid ".svg" }}
{{ $imagefilepath := print $imagedir $imagename }}
<img src="{{ $imagefilepath | relURL }}">
```

### Conditionals

You can conditionally include content if a value is present:

```go-template
{{if .Description }}
<meta name="description" content="{{ .Description }}">
{{ end }}
```

You can also do `else if` statements:

```go-template
{{ if .Title }}
  <title>{{ .Title }}</title>
{{ else if site.Title }}
  <title>{{ site.Title }}</title>
{{ end }}
```

### Functions

The previous `if else` example can be written shorter with the help of the `default` function:

```go-template
{{ $title := default site.Title .Title }}
```

## Site building

You can build a Hugo site and place it in the `public` directory with:

```bash
$ hugo --minify
```

The `--minify` command will remove whitespace from resulting HTML, which speeds things up a bit.

## Themes

You can a number of off the shelf themes to control how your site looks.

You can also generate your own theme with:

```bash
$ hugo new theme basic
```

In order to use this theme, you have to configure Hugo:

```bash
echo "theme = 'basic' >> config.toml
```

To reduce possible duplication between your layouts there is the `baseof.html` file that acts as a kind of layout for your layout.

This file looks like:

```go-template
<!DOCTYPE html>
<html>
  {{- partial "head.html" . -}}
  <body>
    {{- partial "header.html" . -}}
    <div id="content">
      {{- block "main" . }}{{- end }}
    </div>
    {{- partial "footer.html" . -}}
  </body>
</html>
```

Now in an existing layout you can use this with:

```go-template
{{ define "main" }}
  {{ .Content }}
{{ end }}
```

This defines the content section to add to the main section, which is the special variable `.Content`, which contains the content from the content page.

## Templates

You can supress white space before and after a template var is place with dashes:

```go-template
{{- partial "head.html" . -}}
```

Notice the dot after the filename.  That is the context to pull data from.  The dot uses the current page's context.

## Adding Tailwind CSS 3

```bash
$ yarn init
$ yarn add -D tailwindcss autoprefixer postcss postcss-cli
$ npx tailwindcss init
```

Update the resuling `tailwind.config.js` file to look like this:

```javascript
module.exports = {
  content: ["content/**/*.md", "layouts/**/*.html", "themes/my-theme/layouts/**/*.html],
  theme: {
    extend: {},
  },
  plugins: [],
};
```

Add a Post CSS config file `postcss.config.js`:

```javascript
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

In your `package.json` file add the script:

```json
"scripts": {
  "build-tw": "npx tailwindcss -i ./assets/main.css -o ./assets/style.css"
},
```

Then in your head partial you can put:

```go-template
{{ $styles := resources.Get "css/main.scss" | toCSS | minify | fingerprint | postCSS }}

{{ if .Site.IsServer }}
  <link rel="stylesheet" href="{{ $styles.RelPermalink }}"/>
{{ else }}
  {{ $styles := $styles | resources.PostProcess }}
  <link rel="stylesheet" href="{{ $styles.RelPermalink }}" integrity="{{ $styles.Data.Integrity }}"/>
{{ end }}
```

Then you can compile the tailwind main.css with:

```bash
$ npm run build-tw
```

And then you can run the hugo server:

```bash
$ hugo server
```

## Markdown

Hugo disables inline HTML in its markdown by default.


To enable it, you can add this to your `config.yml`:

```yaml
markup:
  goldmark:
    renderer:
      unsafe: true
```

Emojies are also not allowed by default.  You can enable them with:

```yaml
enableEmoji: true
```

With that in place you can add something like `:smile:` to your content.

## Configuration

You can split your configuration into different environments if you want.

Instead of a `config.yml` or `config.toml` you can create a `config` directory:

You can create a `_default` directory with a `config.yml` in it for defaults and then a `development` and `production` directory both with a `config.yml` file in them.

Then you can specify the environment by having a `HUGO_ENV` environment variable set to the appropriate environment, or you can pass the `--environment` flag to the hugo command.
