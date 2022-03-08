# Crawl4 Backup

A backup utility for Windows that facilitates `robocopy` calls from an `ini` file.

## How to use (2 steps)

1. Modify and save your `__config.ini` file. Example contents:

```
[BackupConfig]

systemID=noah_msi

sourcePath=C:\Users\noah\Documents\resume\
sourcePath=C:\Users\noah\Documents\important
sourcePath=C:\Users\noah\Desktop
```

- The `[BackupConfig]` header is required.
- The `systemID` value is required.
- Specify any number of `sourcePath` directories. Avoid nested directories as they will be
	redundantly copied.
- Superfluous whitespace should be avoided, particularly surrounding the `=` signs, as it will
	likely cause errors.
- All source paths must be absolute, beginning with C:\

2. Run `_backup EVERYTHING.bat` or `_backup MODIFIED`

- The backup will be generated in the utility's parent directory.
- `_backup EVERYTHING` will blindly copy all source paths to their destinations.
- `_backup MODIFIED` will only copy modified files by checking the `archive bit`.
- In some cases, you may have to run the script with administrative privileges.

## Notes

-
