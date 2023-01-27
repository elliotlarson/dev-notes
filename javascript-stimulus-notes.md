# Stimulus Notes

## Outlets

You can communicate between controllers with outlets:

```javascript
// misc/foo_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static outlets = ["misc--bar"];

  sayHiFromBar(event) {
    event.preventDefault();
    this.miscBarOutlet.sayHi();
  }

  sayHi() {
    console.log("hello from Foo controller")
  }
}
```

```javascript
// misc/bar_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static outlets = ["misc--foo"];

  sayHiFromFoo(event) {
    event.preventDefault();
    this.miscFooOutlet.sayHi();
  }

  sayHi() {
    console.log("hello from Bar controller")
  }
}
```

```haml
%div{ data: { controller: "misc--foo", misc__foo_misc__bar_outlet: "[data-controller='misc--bar']" } }
  %h3 This is Foo
  = link_to "Say from Bar" "#", data: { action: "misc--foo#sayHiFromBar" }
%div{ data: { controller: "misc--bar", misc__bar_misc__foo_outlet: "[data-controller='misc--foo']" } }
  %h3 This is Bar
  = link_to "Say from Foo" "#", data: { action: "misc--foo#sayHiFromFoo" }
```
