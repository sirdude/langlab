# Before 'make install' is preformed this script shoud be runnable with
# 'make test'.  After 'make install' it should work as 'perl SWDBI.t'

####################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Test::More tests=> 1;;

BEGIN { use_ok('SWDBI') };

####################

# Insert your test code below, the Test::More module is used here so read
# its man page ( perldoc Test::More ) for help writing this test script.
