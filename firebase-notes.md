# Firebase Notes

## Using Node.js 

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
```
