# untested script (ai generated) 
## AWK
> supposedly outputs json set of compile flags... 
> mostly serves as a reminder to myself; for later usage - in a function which... 
> Runs the proper function to output a list of flags, for whichever build system is used in ./src/

which could then dynamically create an attribute set like so...

package-name.compile-flags = builtins.fromJSON (builtins.readFile ./package-name.json);

that could then be used to dynamically create/generate  options for every package across build systems...

To then deal with however you see fit 
For example, a different function could be used to read over that list... and simply complain about any unset values.

Applying that to "core packages" like systemd would allow you to catch when source code changes, and systemd has added yet another feature to disable at compile-time.

Which would help keep your personal package expressions up to date... 


./configure --help | awk '
BEGIN { print "{" }
/^  --/ {
    match($0, /^  --[a-zA-Z0-9-]+/);
    opt==subst($0, RSTART+2, RLENGTH-2);
    desc=substr($0, RLENGTH+3);
    gsub(/^[ \t]+/, "", desc);
    gsub(/\\/, "\\\\", desc);
    gsub(/"/, "\\\"", desc);
    gsub(/'"'"'/, "\\'", desc);
    if (prev != "") print "\"" prev "\": \"" prev_desc "\",";
    prev=opt; prev_desc=desc;
}
END { if (prev != "") print "\"" prev "\": \"" prev_desc "\""; print "}" }
'
