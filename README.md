# spdk_sideworks
Repo for collaborative dev work related to the SPDK.

## find_depend.sh
Here's a copy of the shell script that I put in $SPDK_ROOT_DIR/build/lib
and run it there via ./find_depends.sh.  It walks each libspdk_* and
identifies the references therein which are not resolved and then scans
all the other spdk shared libs (other than itself and libspdk.so) to find
where that symbol is defined.
