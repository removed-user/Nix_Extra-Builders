builtins.readFileType /etc/passwd
# => "regular"

builtins.readFileType /etc
# => "directory"

builtins.readFileType /etc/static
# => "symlink"
