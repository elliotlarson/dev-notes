# JavaScript Notes

## Executing a typescript file as a node script

To write a typescript and then have node execute it, you need the [ts-node](https://github.com/TypeStrong/ts-node) library.

```bash
$ sudo npm install -g ts-node
```

Then, say you have a small hello world program `hello-world.ts`:

```typescript
import * as console from 'console';
console.log('hello');
```

You can execute this with:

```bash
$ ts-node hello-world.ts
# => hello
```
