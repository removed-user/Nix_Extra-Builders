# untested script (ai gen).
# supposedly outputs json set of compile flags... 
# mostly serves as a reminder to myself; for later usage - in a function which... 
# Runs the proper function to output a list of flags, for whichever build system is used in ./src/

./configure --help | awk '
BEGIN { print "{" }
/^  --/ {
    match($0, /^  --[a-zA-Z0-9-]+/);
    opt=substr($0, RSTART+2, RLENGTH-2);
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
