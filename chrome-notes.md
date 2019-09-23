# Chrome Notes

## Stop automatic redirect from http to https

I had a site that was auto-redirecting http traffic to https.  When I took a new version of the site live that didn't have https, Chrome was still trying to auto-redirect for me.

To turn this off, navigate to `chrome://net-internals/#hsts`.  Under the "Delete domain security policies" section, add the domain and click the "delete" button.  This should fix it.

pulled from: https://superuser.com/questions/565409/how-to-stop-an-automatic-redirect-from-http-to-https-in-chrome

## Check Version from Command line

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version
```

## Developer Tools Console Output Copy to Paste Ring

1. Right click on value in console output, and click the "Store as Global Variable" menu option
1. This will output something like `temp1`
1. Then type `copy(temp1)`
