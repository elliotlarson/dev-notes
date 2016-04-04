# Find Notes

#### find ruby files in current directory

	$ find . -name '*.rb'
	
#### find foo file in two different directories

	$ find /tmp /home/deployer/apps/myapp -name foo
	
#### find and print output for passing into xargs

prints the pathname of the current file to standard output, followed by an ASCII NUL character

	$ find config/ -name '*.rb' -print0

#### find file by name ignoring case

	$ find config/ -iname 'application.rb'
	
#### find directories by name

	$ find . -name config -type d
	
#### find with recursion 

	$ find . -name '.*' -maxdepth 1
	
#### find files and pass list to grep for searching

	$ find config -name '*.rb' | xargs grep -n 'Chiponin'
	
