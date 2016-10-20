# AWS CLI Notes

**Note:** almost all commands allow a `--dryrun` option that when used will output what would have been done if it was not a dry run.

## S3 Commands

**Documentation**: [S3 sub-command](http://docs.aws.amazon.com/cli/latest/reference/s3)

#### Get a listing of folders in a bucket

```bash
$ aws s3 ls 
```

#### Get a listing of what is in a folder

```bash
$ aws s3 ls myfolder
```

#### Upload a file

```bash
$ aws s3 cp my-local-file.txt s3://mybucket/
```

#### Download a file

```bash
$ aws s3 cp s3://mybucket/the-file.txt ./
```

#### Delete files

To delete a single file:

```bash
$ aws s3 rm s3://mybucket/the-file.txt
```

To remove all files in a bucket:

```bash
$ aws s3 rm s3://mybucket/ --recursive
```

To remove only files that match a glob pattern (note that we're excluding everything and then including just the glob that we want):

```bash
$ aws s3 rm s3://acadia-database-daily-backups --recursive --exclude "*" --include "*.sql.gz"
```

To remove all files except those that match a glob pattern:

```bash
$ aws s3 rm s3://acadia-database-daily-backups --recursive --exclude "*.bak"
```

#### Create a bucket

```bash
$ aws s3 mb s3://mybucket
```

#### Remove a bucket

```bash
$ aws s3 rb s3://mybucket
```

#### Syncing files

To grab everything from a bucket and sync to current directory:

```bash
$ aws s3 sync s3://acadia-database-daily-backups ./
```

To sync only certain files from bucket to local directory:

```bash
$ aws s3 sync s3://acadia-database-daily-backups ./ --exclude "*" --include "acadia-staging*"
```

Sync current local directory to S3:

```bash
$ aws s3 sync ./ s3://mybucket/
```

## EC2 commands

**Documentation**: [EC2 sub-command](http://docs.aws.amazon.com/cli/latest/reference/ec2)
