# Haml notes

## Translate HTML to HAML

There is a utility `html2haml` that will translate HTML into HAML.

In a Rails site, after you've added the `haml` gem, you can add the binstub:

```bash
$ bundler binstub html2haml
```

Then you can copy some HTML, like from the TailwindUI site, and translate it into HAML.

This command will take the clipboard, translate it, and then copy the HAML to the clipboard:

```bash
# make sure you have some HTML in the clipboard
$ pbpaste | bin/html2haml | pbcopy
```

This will not produce modern formatting.

In something like VSCode you can find and replace with regular expressions to fix things:

1. find `:(\w*) =>` => replace `$1: ` (fixes hash rocket style)
2. find `\{(\w|")` => replace `{ $1` (adds space after opening `{`)
2. find `(\w|")\}` => replace `$1 }` (adds space before closing `}`)

## Unescaping operator

```haml
= "I feel <strong>!"
!= "I feel <strong>!"
```

compiles to:

```html
I feel &lt;strong&gt;!
I feel <strong>!
```
