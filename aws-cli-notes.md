# AWS CLI Notes

**Note:** almost all commands allow a `--dryrun` option that when used will output what would have been done if it was not a dry run.

## Documentation

* [S3 sub-command](http://docs.aws.amazon.com/cli/latest/reference/s3)
* [EC2 sub-command](http://docs.aws.amazon.com/cli/latest/reference/ec2)

## S3 Commands

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

To remove only files that match a glob pattern:

```bash
$ aws s3 rm s3://mybucket/
```
