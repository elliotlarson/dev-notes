## Tracking down an error

Let's say you get an error in the bug tracker you want to trace:

### look for error

```bash
$ gunzip -c production.log-20181024.gz| grep 'Invalid identifier'
# => F, [2018-10-23T21:55:06.571404 #23865] FATAL -- : [6910b9c1-78dc-4767-973a-8750959bf7f0] RuntimeError (Invalid identifier):
```

### find request ID

Every Rails request has what looks like an MD5 hash associated with it and every log item has this hash prefixing the log entry.

`6910b9c1-78dc-4767-973a-8750959bf7f0`

### trace back to the start of the request, look for the IP address

```bash
$ gunzip -c production.log-20181024.gz| grep -F '6910b9c1-78dc-4767-973a-8750959bf7f0'
# => I, [2018-10-23T21:55:05.905333 #23865]  INFO -- : [6910b9c1-78dc-4767-973a-8750959bf7f0] Started GET "/fx/projects/444334/roof_sections/47/panel_configuration" for 50.233.147.82 at 2018-10-23 21:55:05 +0000
# ... other request lines
```

`50.233.147.82`

The first line of the request log results should have an IP address in it

### grep IP address to find all actions for user

```bash
$ gunzip -c production.log-20181024.gz| grep -F '50.233.147.82'
```

This gives you the starting line of every transaction in the log

You may also want to ignore something like polling requests:

```bash
$ gunzip -c production.log-20181024.gz| grep -F '50.233.147.82' | grep -v '/api/v2/da_deploys?id=latest'
```

You can also save this as a file:

```bash
# Get all requests for IP address and pull out first and last item
$ gunzip -c production.log-20181024.gz| grep -F '50.233.147.82' | grep -v '/api/v2/da_deploys?id=latest' | grep -oE "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" | sed -e 1b -e '$!d' file
# => 3846b156-5347-4c31-be21-1f161819d578
#    a7d4c9cb-e082-4a23-9819-9a4c428dcb7b
# Get the first line number of the first request
$ gunzip -c production.log-20181024.gz| grep -nF '3846b156-5347-4c31-be21-1f161819d578' | head -n 1 | grep -oE "^\d*"
# => 2593680
# Get the last line number of the last request
$ gunzip -c production.log-20181024.gz| grep -nF 'a7d4c9cb-e082-4a23-9819-9a4c428dcb7b' | tail -n 1 | grep -oE "^\d*"
# => 5411944
# Produce a file with the subset of data
$ gunzip -c production.log-20181024.gz| sed -n '2593680,5411944p;5411945q' > relevant-period.txt
# Get only user actions from relevant period
$ grep -f user-request-ids.txt relevant-period.txt > user-requests.txt

# ...or
$ while read line; do grep -F $line relevant_time.txt; done < user_request_ids.txt
```

### Extract out the transaction IDs from these lines and then grep for all

```bash
$ cat user_requests.txt | grep -o -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
```

The `-o` flag tells grep to only return the matching result.  The `-E` flag tells grep to use extended regex.

### Search the file for all lines that include the user's transaction IDs

**Note**: this can be slow (see next item about pulling out a smaller subset of the file)

```bash
$ cat user_requests.txt | grep -o -E "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" | grep -f /dev/stdin production.log-20181024.gz
```

### Grabbing a specific subset of the file

If the log file you are working with is large, you may want to select only the subset of data that is relevant to the user you are looking at requests for.

This amounts to finding the first line number of the first matching request and the last line number of the last matching request.

```bash
# get line number of first request
$
```

## Watching live requests for a user

Do a Google search for your IP address, then tail/grep the log:

```bash
$ tail -f production.log | grep '234.23.23.231'
```

## View a list of requests without the details

Requests in Rails have the word `Started` in them:

```txt
I, [2020-12-15T21:17:14.573081 #24237]  INFO -- : [5bc7f226-ec56-4a3c-aca0-af36bbe356e2] Started GET "/my_projects" for 73.202.254.72 at 2020-12-15 21:17:14 +0000
```

```bash
$ tail -n 100000 staging.log | grep Started
```

If you want to exclude requests you don't care about you can pull them out with:

```bash
$ tail -n 100000 staging.log | grep Started | grep -v /check/all.json
```
