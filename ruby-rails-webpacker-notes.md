# Rails Webpacker Notes

## Manually Execute Webpack

I needed to troubleshoot a webpack compilation error and found this useful.  The output of `rails assets:precompile` was empty, but calling Webpack directly gave me output that described the issue.

```bash
$ NODE_ENV=production bin/webpack --progress
```
