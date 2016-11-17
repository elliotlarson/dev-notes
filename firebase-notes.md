# Firebase Notes

## Using JavaScript

### Setup

Install the Firebase node/npm packages.

```bash
$ sudo npm install -g firebase
$ sudo npm install -g firebase-tools
```

### Connecting to the database

In the Firebase interface, you should be able to navigate to the general settings in your project (the gear icon).  From there you should be able to find a link that says something to the effect of "Add Firebase to your web app".  Click this and copy the general connection code:

```javascript
var config = {
  apiKey: "AIzaSyDBASDSDDF23SDVAS_ZmGSfM",
  authDomain: "foo-bar42.firebaseapp.com",
  databaseURL: "https://foo-bar42.firebaseio.com",
  storageBucket: "foo-bar42.appspot.com",
  messagingSenderId: "61922992922259161"
};
firebase.initializeApp(config);

// get a reference to the database service
var database = firebase.database();
```

### Getting data

You can grab a onetime set of data from the database.  The `ref` is the location of the collection.  In this case it's the grabbing the "bookmarks" collection, accessible at this URL: `https://bookmrks-e4ff5.firebaseio.com/bookmarks.json`.

#### Using `once`

[once](https://firebase.google.com/docs/reference/js/firebase.database.Reference#once) returns a [Firebase.Promise](https://firebase.google.com/docs/reference/js/firebase.Promise).  It accepts the event type to listen for.  In this case we're listening for the "value" event, which just means we're looking for the value.  Once listens for exactly one event and then stops listening.  The success callback of the promise passes in a [DataSnapshot](https://firebase.google.com/docs/reference/js/firebase.database.DataSnapshot).  You can then get the data off of this object, with the [val](https://firebase.google.com/docs/reference/js/firebase.database.DataSnapshot#val) method.

```javascript
let bookmarksRef = database.ref('bookmarks');
let bookmarks;
bookmarksRef.once('value', function(dataSnapshot) {
  bookmarks = dataSnapshot.val();
});
```

#### Using `on`

[on](https://firebase.google.com/docs/reference/js/firebase.database.Reference#on) works just like `once` except it is a subscription that will continue to be updated everytime the event ("value" in this case) changes.  This will give your app some real-time-ness.  Since this is essentially a subscription, you will need to call the [off](https://firebase.google.com/docs/reference/js/firebase.database.Reference#off) method to cancel the subscription:

```javascript
let bookmarksRef = database.ref('bookmarks');
let bookmarks;
let onValueChange = bookmarksRef.on('value', function(dataSnapshot) {
  bookmarks = dataSnapshot.val();
});
// then cancel the subscription with
onValueChange.off()
```

#### Child refs

You can get a child of a ref.  Here I'm getting a single bookmark by using a child ref off of the `bookmarksRef` (the "0" is the key of the bookmark):

```javascript
let firstBookmarkRef = bookmarsRef.child('0')
let bookmark;
firstBookmarkRef.once('value', function(dataSnapshot) {
  bookmark = dataSnapshot.val();
});
```

#### Sorting by child value

You can use the [orderByChild](https://firebase.google.com/docs/reference/js/firebase.database.Reference#orderByChild) method on a ref.  This will allow you to sort by a child key of a collection of objects.  

The parent `dataSnapshot.val()` returns a JSON object, where the order is not sorted.  To get the sorted order, you need to loop throught the child refs and build up an array.

The only available order is ascending.  If this is okay, `push` onto an array.  If you want descending `unshift` onto an array.

Also keep in mind that the string sorting is case sensative lexographic, so `Z` comes before `a` in the sort order.  If you need a case insensitive sort, store another child value that is all lower case.  For example, a bookmark could have a `title` and a `title_lower_case`.

```javascript
var bookmarks = [];
bookmarksRef.orderByChild('title').once(function(dataSnapshot) {
  dataSnapshot.forEach(function(child) {
    bookmarks.push(child.val());
  });
});
```
