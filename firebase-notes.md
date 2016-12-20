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
var firebase = require("firebase");
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

The previous example logs you in as a regular user and you are subject to the database access rules you setup.  You can also access Firebase through the admin SDK, which will give you full access irrespective of the database access rules.

```javascript
var admin = require("firebase-admin");
admin.initializeApp({
  credential: admin.credential.cert(".adminServiceAccountKey.json"),
  databaseURL: "https://bookmrks-e4ff5.firebaseio.com"
});
var database = admin.database()
```

[Here are a couple of simple repl scripts](https://gist.github.com/elliotlarson/8e16160c93d58f10646be006243441e7) that launch an interactive Node.js shell with the firebase configs above preloaded.

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

**Note**: This will add the complete hash of bookmarks to the bookmarks variable.

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

#### Grabbing individual values

When you get back a `dataSnapshot` for a collection, you may still want to iterate through them and do something for each.  For example, you may want to translate each into an object.  In this example, we're creating an array of `Bookmark` objects from the returned `dataSnapshot`:

```typescript
let bookmarks: Bookmark[] = [];
database.ref('bookmarks').on('value', function(dataSnapshot) {
  let bookmarksHash = dataSnapshot.val();
  Object.keys(bookmarksHash).forEach((key) => {
    bookmarks.push(Bookmark.fromHash(bookmarksHash[key]));
  });
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

#### Grabbing by key

You are able to grab by a single key in Firebase.  This is essentially like a one off `where` clause, where you can grab a subset of a collection where a child key is equal to something.  For example:

```typescript
var bookmarks = [];
bookmarksRef.orderByChild('uid').equalTo('fn9QGFdlHKMuraGEEGLHjTi3SoW2')
  .once(function(dataSnapshot) {
  dataSnapshot.forEach(function(child) {
    bookmarks.push(child.val());
  });
});
```

#### Getting collection count

There is the [numChildren](https://firebase.google.com/docs/reference/js/firebase.database.DataSnapshot#numChildren) method on the dataSnapshot object:

```javascript
var bookmarksCount = 0;
bookmarksRef.once('value', function(dataSnapshot) {
  bookmarksCount = dataSnapshot.numChildren();
});
```

#### Limiting results

You can limit the number of results you pull back with either [limitToFirst](https://firebase.google.com/docs/reference/js/firebase.database.Query#limitToFirst) or [limitToLast](https://firebase.google.com/docs/reference/js/firebase.database.Query#limitToFirst) methods on the ref.

```javascript
var lastFiveBookmarks = [];
bookmarksRef.limitToLast(5).once('value', function(dataSnapshot) {
  lastFiveBookmarks.push(dataSnapshot.val());
});
```

### Adding data

We can add a new item to a collection by using the [push](https://firebase.google.com/docs/reference/js/firebase.database.Reference#push) method on a collection ref and then using the [set](https://firebase.google.com/docs/reference/js/firebase.database.Reference#set) method to update values.

Notice the use of `firebase.database.ServerValue.TIMESTAMP` to add the current timestamp.  You probably don't want to rely on a value set in your app, so Firebase provides this value.

```javascript
var newBookmarkRef = bookmarksRef.push();
newBookmarkRef.push({
  createdAt: firebase.database.ServerValue.TIMESTAMP,
  title: 'Firebase documentation',
  url: 'https://firebase.google.com/docs/',
  tags: ['firebase', 'nosql']
});
var newBookmark;
newBookmarkRef.once('value', function(dataSnapshot) {
  newBookmark = dataSnapshot.val();
});
```

You can also just call `push` directly if you don't need the ref:

```javascript
bookmarksRef.push({
  createdAt: firebase.database.ServerValue.TIMESTAMP,
  title: 'Firebase documentation',
  url: 'https://firebase.google.com/docs/',
  tags: ['firebase', 'nosql']
});
```

You can also pass an optional callback function as the second argument to the `push` method:

```javascript
let bookmarkData = {
  createdAt: firebase.database.ServerValue.TIMESTAMP,
  title: 'Firebase documentation',
  url: 'https://firebase.google.com/docs/',
  tags: ['firebase', 'nosql']
}
bookmarksRef.push(bookmarkData, (error) => {
  if (error) {
    console.log(`ERROR: ${error}`);
  } else {
    console.log('push successful!');
  }
});
```

### Updating data

First you'll get a ref for a collection item:

```javascript
var bookmarkRef = database.ref('bookmarks/-KWkxBFE0js_G-mdX98Q');
var bookmark;
bookmarkRef.once('value', function(dataSnapshot) {
  bookmark = dataSnapshot.val();
});
```

#### Updating the whole collection item

To update the whole record you can call the [set](https://firebase.google.com/docs/reference/js/firebase.database.Reference#set) method on the collection item's ref:

```javascript
bookmark.title = 'New Title of Awesomeness';
bookmarkRef.set(bookmark);
```

This will update the entire document with what you pass in.  so if you pass in `{ title: 'New Title of Awesomeness' }`, the whole bookmark collection item will be replaced with an object with a single title value.

#### Updating just a field on an item

To update a single field/value for a collection item, you can use the [update](https://firebase.google.com/docs/reference/js/firebase.database.Reference#update) method:

```javascript
bookmarkRef.update({ title: 'New Title of Awesomeness' });
```

### Deleting data

This is as easy as calling the [remove](https://firebase.google.com/docs/reference/js/firebase.database.Reference#remove) method on a collection item's ref (scary):

```javascript
bookmarkRef.remove();
```

### Transactional update

Both `set` and `update` will update the value regardless of the current value.  Usually this is fine, however in the case of a counter increment (imagine Facebook likes) you may not have a current value to increment (imagine lots of people favoriting at the same time).  You can use the [transaction](https://firebase.google.com/docs/reference/js/firebase.database.Reference#transaction) method to deal with this.

```javascript
// say our bookmarks app is social and people can "like" our bookmarks
var bookmarkRef = database.ref('bookmarks/-KWkxBFE0js_G-mdX98Q/favorites');
bookmarkRef.transaction(function(currentFavorites) {
  return currentFavorites + 1;
});
```

## Authentication

### Users and user data

Firebase provides a pre-packaged authentication system for your app.  When using this, users are created in the Firebase system.  However, these user "records" are only for authentication.  You will probably want to store additional user related data in your database.  To do this, you need to create your own users collection and associate collection items with the user records via the user record's uid.

### Seeding a user with Google auth provider

In order for this to work, I had to create a [utility web page](https://gist.github.com/elliotlarson/e73bdcd025f688e4e7a84332b9460300) to call the Google auth popup.  The web page can not just be served from the local filesystem, it has to be served with a web server with the HTTP protocol.

Using the simple python server:

```bash
$ http-serve
```

Then open the web page: `http://localhost:8080/create-app-user.html`

## Rules

The rules system gives you a declarative mechanism to define access privileges and schema validation to your database.

Rules are defined on a per-node basis.

Rules are written in a JSON file.  If you are hosting on Firebase and deploying with the `firebase deploy` command, this file can be stored in revision control and it will be applied on each deploy.

```json
{
  "rules": {
    "foo": {
      ".read": true,
      ".write": false
    }
  }
}
```

In this example, anyone is granted read access to the foo collection, or the `/foo` path, but no one is granted write access.

### Shallower level rules that grant read access override deeper rules

Concider the following example:

```json
{
  "rules": {
    "foo": {
      ".read": true,
      "bar": {
        ".read": false
      }
    }
  }
}
```

Even though we've specified that reading for `bar` is false, the shallower parent node has granted read access.  The highest level rule that grants read access takes precedence.

However, if we reverse this example...

```json
{
  "rules": {
    "foo": {
      ".read": false,
      "bar": {
        ".read": true
      }
    }
  }
}
```

... access is granted for bar, even though it is not granted on the parent.  So, when evaluating if access is granted, Firebase walks down the rule tree looking at each node in the hierarchy.  The first node it encounters that grants access is accepted and the system quits descending the tree.

### If no rule is provided it is assumed to be false

These two examples are the same:

```json
{
  "rules": {}
}
```

```json
{
  "rules": {
    ".read": false,
    ".write": false
  }
}
```

### Only allowing create or delete

`data` and `newData` are from a list of [predefined variables](https://firebase.google.com/docs/database/security/securing-data#predefined_variables) that can be used in your rules.

```json
".write": "!data.exists() || !newData.exists()"
```

## Misc

### Pushkeys

One of the core Angular developers published [this gist](https://gist.github.com/mikelehen/3596a30bd69384624c11) which provides the code for generating pushkeys.  This might be useful if you are creating fake data.

## Modeling data

Here is a [good StackOverflow response](http://stackoverflow.com/questions/16638660/firebase-data-structure-and-url/16651115#16651115) about data modeling in Firebase, written by a Firebase engineer.  He goes over the different tradoffs when doing basic data modeling in different ways with Firebase.
