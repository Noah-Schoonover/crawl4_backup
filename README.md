READ ME

Copy the entire "000 - Backup Batch File\" folder into the directory you would like the backups 
to be stored in. Example of most common use case:

	"E:\000 - Backup Batch File\"

If you plan to store multiple computers or multiple users on a single hard drive, two copies 
of the  "000 - Backup Batch File\" folder must be present in different directories so that the
backup for one computer/user does not override the backup for another. For example:

	"E:\Computer 1\000 - Backup Batch File\"

	"E:\Computer 2\000 - Backup Batch File\"

The path to the backup folders are stored relative to the location of the batch files:

	If the path to batch file folder is "E:\000 - Backup Batch File\"
	then
	backups for the user will be stored in  "E:\Backups\User\"
	and
	backups for the public will be stored in  "E:\Backups\Public\"

Customize the settings in the 000_config.ini file.

	Things to remember:
		Do NOT put spaces between the equals sign and the key.
		Do NOT put spaces between the equals sign and the value.
		key=value 	(good)
		key =value 	(bad)
		key= value 	(bad)

	1. Set the System Id to your intials. Examples:
		systemId=HSS
		systemId=AAV
		
	2. Set the Verbose Log flag. 
		True to copy log file showing all files backed up to DropBox.
		False to just write log file containing backup date and time to DropBox.
		Example of true:	verboseLog=true
		Example of false:	verboseLog=false
		
	3. Set the path to the public directory to copy. This variable specifies the directories to
		copy from the C:\Users\Public\ directory; the path provided here will be appended to 
		"C:\Users\Public\". Everything inside of the source directory will be copied to the 
		Backups\Public\ folder on the hard drive.
		
		The path you provide MUST end in a backslash.
		
		Examples:

			pathToPublicDirToBackup=Documents\
			Everything inside of C:\Users\Public\Documents\ will be copied to "E:\Backups\Public\Documents\"
		
			OR

			pathToPublicDirToBackup=Documents\Venom\
			Everything inside of C:\Users\Public\Documents\Venom\ will be copied to "E:\Backups\Public\Documents\Venom\"
			
		If you do not wish to copy anything from the Public directory, put "none" for the value:

			pathToPublicDirToBackup=none
			
	4. Set the path to your user's directory to copy. This variable specifies the directories to
		copy from the C:\Users\[username]\ directory; the path provided here will be appended to 
		"C:\Users\[username]\". Everything inside of the source directory will be copied to the 
		Backups\User\ folder on the hard drive.
		
		The path you provide MUST end in a backslash.
		
		Examples (username is Billy):
			pathToUserDirToBackup=Documents\
			Everything inside of C:\Users\Billy\Documents\ will be copied to "E:\Backups\User\Documents\"
		
			pathToUserDirToBackup=Documents\Venom\
			Everything inside of C:\Users\Billy\Documents\Venom\ will be copied to "E:\Backups\User\Documents\Venom\"
			
		If you do not wish to copy anything from the user's directory, put "none" for the value:
			pathToUserDirToBackup=none

	5. Set the DropBox present flag to true or false. If Dropbox is present on the computer, set the value 
		to true; false if not. If set to true, the backup log will be written to
		"C:\Users\[username]\Dropbox (VIS)\VIS Technical Division\Backup Logs"
		
		Example of true:	dropboxPresent=true
		Example of false:	dropboxPresent=false