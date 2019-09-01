# JavaScript Form Submit Notes

Problem: There is no way to tell in JS if there are events assigned to a DOM element.

Possible solutions:

* If you are using Stimulus, look at the actions on the form and check if submit actions exist
* Add a data attribute to form if event handlers exist `hasHandlers` or something

```javascript
// This causes a double submit
setTimeout(() => {
  form.dispatchEvent(new CustomEvent("submit"));
}, delay);

setTimeout(() => {
  if (form.dataset.remote) {
    Rails.fire(form, "submit");
  } else {
    form.submit();
  }
}, delay);
```
