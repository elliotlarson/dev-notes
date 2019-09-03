# Redux Immutable Data Modification Patterns

Dan Abramov, the creator of Redux, says "You Might Not Need Redux".

I guess I would counter by saying, "well, but you probably do need Redux".

If you're doing anything non-trivial in React, I have a hard time seeing how you can keep your code maintainable without including some kind of state management library into the mix.

Redux is by far the most popular state management library for React. The other popular option seems to be MobX. (Here's an awesome presentation comparing the two.)

While popularity isn't everything, my take is that there's value in following the well worn path. It's more likely if you have a question or a problem someone else has already addressed it on StackOverflow; and, if you need to get other developers involved in the codebase, a more popular library will likely result in a lower friction onboarding process.

Also, given the creator's status in the React community, it's very likely that Redux is going to be the choice until something totally different like Apollo or Relay matures and replaces it.

However, if you're using Redux, you need to know how to modify your state immutably (without changing it). I found this awkward at first. Every update to your app's state involves creating an entirely new version of it with the changes applied.

## What's the big deal with immutability?

TJ Holowaychuck Tweeted: "my state management library {}".

I read that while I was learning Redux. It cracked me up because using Redux felt like using a bulldozer to do some light gardening. There's so much formality and indirection around managing your state. It seemed unnecessary. I mean, I already spend way too much time shaving yaks.

I still have some complaints about Redux, but I've largely grown to like it at this point. I don't like writing it, but I like what I get as a result. So, it's functionally solid <pun cringe>, but there's maybe a better surface API? [one option]

But, I think part of my problem while learning it was that Redux is not useful in the context of a trivial app, and I mainly started learning Redux by building trivial apps. Redux shines when your app starts to get complicated.

Redux is like an accounting system for your app's data or state. Coupled with the Redux dev-tools, you essentially get a balance sheet that shows you how your data changes over time, which can be remarkably useful when your app starts to do more than just adding an item to a list.

Modifying state immutably is what allows you to keep an accurate accounting of your previous states. If you change your state by mutating it, you essentially make your balance sheet inaccurate by changing its history (Enron Driven Development™).

### Here's a quick example to show you what I mean:

Say we have an array:

```javascript
let characters = ["Walter", "Jeffrey", "Donald"];
```

Let’s keep track of changes to the array:

```javascript
const stateChanges = [characters]; // start with the initial state
```

Now let’s add an element to the array and save the new state in the stateChanges array:

```javascript
characters.push("Maude");
stateChanges.push(characters);
// stateChanges:
// [
//   ["Walter", "Jeffrey", "Donald", "Maude"],
//   ["Walter", "Jeffrey", "Donald", "Maude"],
// ]
```

The problem is that the stateChanges array now has two references to the same array. We’ve lost the previous, initial state of the characters array because we’ve mutated it.

By using immutable state changes, we can save the previous state:

```javascript
const newCharacters = [...characters, "Maude"];
stateChanges.push(newCharacters);
// stateChanges:
// [
//   ["Walter", "Jeffrey", "Donald"],
//   ["Walter", "Jeffrey", "Donald", "Maude"],
// ]
```

Now we’ve stored two different arrays in our stateChanges array and we have an accurate accounting of how the state has changed.

Redux just takes this idea and fleshes it out. With Redux, you can see how your app got into its current state, which can be remarkably helpful when trying to debug how your app got into a weird state.

## Immutable data modification patterns

While digging into Redux I found myself repeatedly saying, “wait, how do I do this immutably, again?”.

So, I set out to catalog the approaches I could use to immutably change the state in my Redux store.

I’ve ended up favoring the mostly vanilla JS approaches, so that’s what I’m including here. But, initially I did some explorations with multiple approaches, like using Ramda.js, Immutable.js, and even a simple utility file of my own. Here’s a gist with those explorations if you’re interested.

### Adding an item to an array:

Let’s start out with an array of character names and work on adding a new character:

```javascript
const characters = ["Walter", "Jeffrey", "Donald"];
const maude = "Maude";
```

Adding “Maude” using the ES6 spread operator (my preferred approach):

```javascript
const newCharacters = [...characters, maude];
```

Using the JavaScript concat method:

```javascript
const newCharacters = characters.concat(maude);
```

You can also copy the array and mutate the copy:

```javascript
// creating a copy with `slice`
const newCharacters = characters.slice();
// you could also just copy with the spread
// const newCharacters = […characters];
newCharacters.push(maude);
```

This may seem silly given the previous options, but sometimes it can be helpful to make a copy and then use normal mutation functions on the copy.

If you’re worried about getting duplicates in the array, you can use the Set data type to ensure uniqueness:

```javascript
// Creates a new array including the new item, turns it into a Set,
// which removes duplicates, and then turns it back to an array
const newCharacters = [...new Set([...characters, "Donald"])];
// Since "Donald" is a non-unique item, newCharacters will be:
// => ["Walter", "Jeffrey", "Donald"]
```

Let’s say you wanted to add “Maude” at a certain position in the array, like just after “Jeffrey”. You can use splice to achieve this:

```javascript

// Adding Maude after Jeffrey at index 2
const newCharacters = [...characters];
newCharacters.splice(2, 0, maude);
// => ["Walter", "Jeffrey", "Maude", "Donald"]
```

### Adding an object key/value:

Let’s start with a collection of character data.

```javascript
const characters = {
  1: { id: 1, firstName: "Jeffrey", lastName: "Lebowski" },
  2: { id: 2, firstName: "Walter", lastName: "Sobchak" },
  3: { id: 3, firstName: "Donald", lastName: "Kerabatsos" }
};
const maude = { id: 4, firstName: "Maude", lastName: "Lebowski" };
```

Adding Maude with the spread operator (my preferred approach):

```javascript
const newCharacters = { ...characters, [maude.id]: maude };
```

Using the object assign method:

```javascript
const newCharacters = Object.assign(characters, { [maude.id]: maude });
```

Creating a copy and then mutating the copy:

```javascript
const newCharacters = { ...characters };
newCharacters[maude.id] = maude;
```

### Updating an item in an array:

Let’s say we want to change “Jeffrey” to “The Dude”.

```javascript
const characters = ["Walter", "Jeffrey", "Donald"];
const oldName = "Jeffrey";
const newName = "The Dude";
```

If you don’t have the index for the array item, you can get it with:

```javascript
const index = characters.findIndex(c => c === oldName);
```

You can alter the item with the spread operator:

```javascript
const newCharacters = [
  ...characters.slice(0, index), // all the items before the update item
  newName, // add the newName in place of the old name
  ...characters.slice(index + 1) // all the items after the update item
];
```

You can use the map function (my preferred approach):

```javascript

const newCharacters = characters.map(c => (c === oldName ? newName : c));
// or without the ternary
const newCharacters = characters.map(c => {
  if (c === oldName) {
    return newName;
  }
  return c;
});
```

You could copy the array and mutate the copy:

```javascript
const newCharacters = [...characters];
newCharacters[index] = newName;
```

### Updating an object key/value:

Let’s update the characters object from above:

```javascript
const updateId = 1;
const updatedCharacter = { id: 1, firstName: "The", lastName: "Dude" };
```

Using the spread operator (my preferred approach):

```javascript
const newCharacters = { ...characters, [updateId]: updatedCharacter };
```

Using the object assign method:

```javascript
const newCharacters = Object.assign(characters, {
  [updateId]: updatedCharacter
});
```

Or, you could copy the object and mutate the copy:

```javascript
const newCharacters = { ...characters };
newCharacters["1"] = newCharacter;
```

### Deleting an item from an array:

Let’s remove Donald from the characters list (so sad):

```javascript
const characterToRemove = "Donald";
const index = characters.findIndex(c => c === characterToRemove);
```

Using the spread operator and the slice method:

```javascript
const newCharacters = [
  ...characters.slice(0, index),
  ...characters.slice(index + 1)
];
```

Using the filter method (my preferred approach):

```javascript
const newCharacters = characters.filter(c => c !== characterToRemove);
```

### Deleting an object key/value:

Let’s remove Donald from the characters object literal above:

```javascript
const deleteId = 3;
```

Using the spread operator and destructuring (my preferred approach):

```javascript
// You don't need to type cast the integer `deleteId` to a string in the
// browser, but when running Jest specs, I found that I had to cast to a
// string. Maybe this is a difference between browser JS and Node, which
// the tests run in?
const { [`${deleteId}`]: deleted, ...newCharacters } = characters;
```

You can use the reduce method:

```javascript
const newCharacters = Object.keys(characters).reduce((obj, id) => {
  if (id !== `${deleteId}`) {
    return { ...obj, [id]: characters[id] };
  }
  return obj;
}, {});
```

Lodash also has a nice utility method omit:

```javascript
import omit from "lodash/omit";
const newCharacters = omit(characters, deleteId);
```

## Applying the immutable modification patterns in a Redux example

The Redux folks recommend normalizing your state and keeping it in flat structures, which allows you to treat it like a database. Let’s apply this approach to the character data and use our immutable data modification patterns in a Redux example.

I’m using a kind of slightly modified ducks pattern, keeping types, actions and reducers in a single file:

I usually create a store directory in my src directory where I put my duck-like files.

```javascript
// `src/store/characters.js`

import uuid from "uuid/v4";

export const types = {
  CREATE: "CHARACTERS_CREATE",
  UPDATE: "CHARACTERS_UPDATE",
  DELETE: "CHARACTERS_DELETE"
};

const DEFAULT_STATE = { byId: {}, allIds: [] };

export const reducer = (state = DEFAULT_STATE, action) => {
  switch (action.type) {
    case types.CREATE:
      return createReducer(state, action);
    case types.UPDATE:
      return updateReducer(state, action);
    case types.DELETE:
      return deleteReducer(state, action);
    default:
      return state;
  }
};

const createReducer = (state, action) => {
  const characterData = action.payload;
  // if an ID is passed in, use it, otherwise create a UUID
  const id = characterData.id || uuid();
  return {
    ...state,
    byId: { ...state.byId, [id]: characterData },
    allIds: [...state.allIds, id]
    // if you're worried about duplicates, use this instead to ensure uniqueness
    // allIds: [...new Set([...state.allIds, id])]
  };
};

const updateReducer = (state, action) => {
  const characterData = action.payload;
  const id = characterData.id;
  return { ...state, byId: { ...state.byId, [id]: characterData } };
};

const deleteReducer = (state, action) => {
  const deleteId = action.payload;
  const { [`${deleteId}`]: deleted, ...byId } = state.byId;
  const allIds = state.allIds.filter(id => id !== deleteId);
  return { ...state, byId, allIds };
};

const createAction = newCharacter => ({
  type: types.CREATE,
  payload: newCharacter
});

const updateAction = updateCharacter => ({
  type: types.UPDATE,
  payload: updateCharacter
});

const deleteAction = id => ({ type: types.DELETE, payload: id });

export const actions = {
  create: createAction,
  update: updateAction,
  delete: deleteAction
};
```

If you’re interested, I would test this file like this.

However, I think the recommendation is to create separate reducers for managing state changes to byId and allIds. I don’t often do this because I find the multiple switch statements unappealing, but it simplifies the reducer logic a bit, which is a win.

The changes would look like this:

```javascript
import { combineReducers } from "redux";

const byId = (state = {}, action) => {
  switch (action.type) {
    case types.CREATE:
    case types.UPDATE:
      // Note: create and update are the same now so we can let the case for
      // create fall through to the case for update
      const characterData = action.payload;
      return { ...state, [id]: characterData };
    case types.DELETE:
      const { [`${deleteId}`]: deleted, ...newState } = state;
      return newState;
    default:
      return state;
  }
};

const allIds = (state = [], action) => {
  switch (action.type) {
    case types.CREATE:
      const { id } = action.payload;
      return [...state, id];
    // Note: we don't need an update here since the ID doesn't change
    case types.DELETE:
      const deleteId = action.payload;
      return state.filter(id => id !== deleteId);
    default:
      return state;
  }
};

export const reducer = combineReducers({ byId, allIds });

// Note: we'll have to do the UUID work here instead of in the reducer
// so both create reducers have access to the same ID
const createAction = newCharacter => {
  // if an ID is passed in, use it, otherwise create a UUID
  const id = newCharacter.id || uuid();
  return {
    type: types.CREATE,
    payload: { ...newCharacter, id }
  };
};
```

## Other immutable options

I’m mostly using vanilla JS for immutable state changes at this point, but there’s a couple of libraries that have caught my eye.

I’ve looked briefly at Immutable.js. It makes working with immutable data easier and more efficient, but adds another library and level of abstraction to your code. My initial reaction to it was that I would probably use it in the future, but I wanted to work with vanilla JavaScript for awhile. I figured this would allow me to better understand the pain points that Immutable.js was trying to solve. I definitely think that since JavaScript is not an immutable language by default, having a library that provides strictly immutable data structures is useful.

I also find the Redux ORM library very compelling. Most of my backend application servers are developed with the help of an ORM, like ActiveRecord in Rails. So, it feels natural to have an ORM to manage my data on the front-end. When I started with React, I lamented that Ember data wasn’t easily usable as a standalone library. That still would be awesome, but you can get something in the ballpark with Redux and Redux ORM. And, using the Redux ORM API makes immutable state changes look a little nicer than using vanilla JS.

If you’re still here, thanks for reading! ❤️ 🙏

If you’re interested, here’s a repo with some code from this article.
