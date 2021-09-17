use v5.34;
use strict;
use warnings;
use Term::ANSIColor qw(:constants);


# declare number of tests
use Test::Simple tests =>  5;
use lib ('custom_modules');
use David::Inexact_Matching ('compare', 'normalize');

say GREEN, "Test Module David::Inexact_Matching", RESET;


say BLUE, "Test equality of two strings", YELLOW;
ok(compare("Test", "TEST") eq "equal");
ok(compare("This is a long testing example.", "ThIs iS a LOng TesTing exAmpLe.") eq "equal");

say BLUE, "Test inexact matching of two strings", YELLOW;
ok(compare("This is a long testing example for inexact matching.", "ThIs iS a LOng TesTing exAmpLe for ineXact MatchNG.") eq "inexact");
ok(compare("This is a long testing example for inexact matching.", "This is a long testing example for ineact matching.") eq "inexact");



say BLUE, "Test elemination of stop words", YELLOW;
ok(normalize("This is a TEST to check the elimination of stopwords.") eq "test.txt check elimination stopwords.")