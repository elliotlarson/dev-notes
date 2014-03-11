# VimScript Notes

## Resources

* [Learn Vim Script the Hard Way](http://learnvimscriptthehardway.stevelosh.com/)
* [IBM "Scripting the Vim Editor"](http://www.ibm.com/developerworks/views/linux/libraryview.jsp?end_no=100&lcl_sort_order=asc&type_by=Articles&sort_order=desc&show_all=false&start_no=1&sort_by=Title&search_by=scripting+the+vim+editor&topic_by=All+topics+and+related+products&search_flag=true&show_abstract=true)
* Vim's own documentation: `:help usr_41.txt` and `:help function-list`

## Language Constructs

## Mapping

#### Special keycodes

There are a number of special key codes you can use when creating maps.  Some of the most common are `<leader>` and `<cr>`.  To get a complete list:

    :help keycodes

## Available Interfaces

#### Asking for information in the command prompt

You need to use the input command.  Here's an example that will ask you for some text and then echo it out:

```
function MyMeth()
  let l:myVar = input('yo, say it: ')
  echo myVar
endfunction

noremap <leader><leader>g :call MyMeth()<cr>
```

#### Showing a list of items in the quick fix menu

## Plugin Ideas

#### Change hash access to fetch

In a ruby file change `my_hash[:my_val]` to `my_hash.fetch(:my_val)`

#### Change string keyed hash to symbol hash

Change this:

```
{ 'foo' => 'bar' }
```

to this:

```
{ foo: 'bar' }
```
