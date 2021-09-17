use v5.34;
use strict;
use warnings;
use Term::ANSIColor qw(:constants);

# declare number of tests
use Test::More tests =>  1;

use lib ('custom_modules');
use David::Questions_and_Answers ('getQuestions_and_Answers');

say GREEN, "Test Module David::Questions_and_Answers", RESET;

my $testfile = "tests/SampleData/short_exam_master_file.txt";
my %expected = (
    '1. The name of this class is:'                  => [ '[X] Introduction to Perl for Programmers', '[ ] Introduction to Perl for Programmers and Other Crazy People', '[ ] Introduction to Programming for Pearlers', '[ ] Introduction to Aussies for Europeans', '[ ] Introduction to Python for Slytherins' ],
    '2. The lecturer for this class is:'             => [ '[ ] Dr Theodor Seuss Geisel', '[ ] Dr Sigmund Freud', '[ ] Dr Victor von Doom', '[X] Dr Damian Conway', '[ ] Dr Who' ],
    '3. The correct way to answer each question is:' => [ '[X] To put an X in the box beside the correct answer', '[ ] To put an X in every box, except the one beside the correct answer', '[ ] To put an smiley-face emoji in the box beside the correct answer', '[ ] To delete the correct answer' ]
);

say BLUE, "Test if return has expected hash", YELLOW;
my %got = getQuestions_and_Answers($testfile);
is_deeply(\%got, \%expected);
