# Rails with Turbo/Hotwire

Some notes pulled from the Pragmatic Studio Hotwire course: https://pragmaticstudio.com/courses/hotwire-rails

## Turbo drive

This is added in by default and makes all of the requests AJAX instead of traditional requests.

## Turbo frames

Allows sections of the page to be updated individually.

You can wrap a section of a page with a Turbo Frame tag:

```haml
= turbo_frame_tag @project do
  -# ... project markup
```

Assuming project is a model, this pulls the ID off of it.  This is shorthand for `dom_id(@project)`.

When you are responding to a request from a Turbo Frame, you just render a partial that has a Turbo Frame in it, and Turbo will do the work to update that part of the page.

```ruby
class SomeController < ApplicationController
  def create
    # Some creation code
    render @bait
    # This is short for `render partial: "baits/bait", object: @bait`
  end
end
```

### Breaking out of a turbo frame

If you are in a turbo frame tag and you want to link to another page, you need to indicate to turbo that you want to break out of the frame for navigation:

```haml
= link_to image_tag(bait.image), bait, data: { turbo_frame: "_top" }
```

## Turbo Streams

Turbo streams are a way to carry out actions on turbo frames on the page.  They are markup that get sent over the wire that turbo knows how to handle on the front end.

Types of stream actions:

* `append` adds the content to the end of the target element without changing its existing contents. For example, you want to add something to the bottom of a list.
* `prepend` adds the content to the beginning of the target element without changing its existing contents. For example, you want to add something to the top of a list.
* `remove` removes the target element. Boom, gone!
* `replace` completely replaces the target element with the given content. For example, we used it to replace an outdated section of a page (a bait) with updated content.
* `update` only replaces the content of the target element with the given content. For example, we used it to replace a number within a <div> element, but not the entire <div>.
* `before` inserts the given content before the target element. For example, you want to put a high-priority item before a lower-priority item.
* `after` inserts the given content after the target element. For example, you want to put a February item after a January item.

You can have multiple stream tags in a turbo stream template:

```haml
= turbo_stream.replace @bait do
  = render @bait

= turbo_stream.update "tackle_box_items_count" do
  = current_user.tackle_box_items.size
```

If you have just one stream you can render it in the controller:

```ruby
render turbo_stream: turbo_stream.replace(@bait, @bait)
```

## Turbo search

Put the search results in a turbo frame tag:

```haml
= turbo_frame_tag "results" do
  -# some results content
```

Then in your form add a data attribute for the turbo frame:

```haml
= form_with(url: search_path, method: :get, data: { turbo_frame: "results }) do |f|
  -# search form content
```

What this really does is update the `src` attribute of the linked to turbo frame.  When the source is updated Turbo knows to make a request to the backend to update the content.

When a request is initiated from a turbo frame, a header `Turbo-Frame: results` is sent with the request.

To update the URL bar with the results of the form submission, add the `turbo_action: "advance"` data attribute to the form:

```haml
= form_with(url: search_path, method: :get, data: { turbo_frame: "results, turbo_action: "advance" }) do |f|
  -# search form content
```

This adds the URL to the browser history, so you can click the backspace button in the browser to get to previous search pages.

Alternatively, you can add this to the turbo frame tag instead, since it's the one doing the work:

```haml
= turbo_frame_tag "results", data: { turbo_action: "advance" } do
  -# some results content
```
