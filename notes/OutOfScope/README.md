This Folder contains lofty "rule of cool" ideas -
for potential future functions; 
to be added to a different flake, with which this one could integrate
# From/To "PackageManager"
This would be a conceptual/theoretical "nixified" wrapper/api of sorts. 
Which would not expose every feature of a package manager, but would -
For the same task, execute whichever command is required to perform that task given a package manager. 

## This would allow for... really cool features, like
Adding nix to a computer, determining the native package manager...
Listing all installed packages, 
eg: pacman -Qqs, or apt --list-installed
Iterating over them listing their sources...
Gathering all Metadata...
reinstalling and logging the installation details to get compile flags, if any were added
computing dependency graphs and inter-relations between packages

# Then ultimately... ridiculously
Pulling the url from metadata... 
fetching an archive/git-cloning with that url... 
Creating a list containing all the compile-time options gathered about that software
With buildinputs determined through a generated dependency graph
putting all of that together into a "recursive nix" function outputting a default.nix expression
Replacing every package on a host with a nix expression that builds that package
testing, and building those expressions

Converting 400+ packages to locally-built nix packages, and vice versa... 
Using nix to create metadata/"build files" for a native packaging system
Build that package and archive it, ready for install
