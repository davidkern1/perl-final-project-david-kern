use v5.34;
use strict;
use warnings;
use diagnostics;
use DateTime;
use File::Basename qw(fileparse);
use Term::ANSIColor qw(:constants);

# variables to randomize answers
my $answerCounter = 0;
my %random;

# Format Date and Time
my $date = DateTime->now(time_zone => 'Europe/Zurich')->format_cldr("YYYYMMdd-kmms");

# Extract current filename from ARGV
my ($fname) = fileparse($ARGV[0], qr/\.txt/);

#create new File
open (newFile, '>', "$date-$fname.txt");

# remove everything within square brackets
sub removeIndicator() {
    s/\[([^\[\]]|(?0))*]/[ ]/;
}

# randomize order of answers
sub randomizeQuestions() {
    #store answers in a hash
    if ($_ =~ m/[ ]/) {
        $random{$answerCounter} = $_;
        $answerCounter++;
    }
    else {
        print newFile $_;
    }
    #check if answers are minimum of length 2 and the next line does not contain another answer
    if ($answerCounter >= 1 and !($_ =~ m/[ ]/)) {
        #index($_, "[ ]") == -1
        #print answers in random order
        for my $answer (keys %random) {
            #if sample answer: replace [ ] with [X]
            if(index($random{$answer}, "This is the correct answer") != -1){
                $random{$answer} =~ s/\[ ]/[X]/i;
                print newFile $random{$answer}
            }
            else {
                print newFile $random{$answer}

            }
        };
        print newFile;

        #reset variables
        $answerCounter = 0;
        undef % random;
    }
}


# read file and call methods
while (readline()) {
    removeIndicator();
    randomizeQuestions();
}

#info message
print GREEN, "Succesfully created empty Exam-File."

