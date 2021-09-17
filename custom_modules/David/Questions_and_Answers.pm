package David::Questions_and_Answers;
use v5.34;
use strict;
use warnings;
use diagnostics;
use experimental 'signatures';
use Exporter 'import';

# Exported functions
our @EXPORT_OK =  ('getQuestions_and_Answers');

# reads a file and stores the $questions as key and the @answers as value into  %hash
# Parameters:
# - $filepath
# Returns:
# - %hash with question as ($) key, and answers as (@) values
sub getQuestions_and_Answers($filepath) {
    # open file of given filepath
    open my $fh, '<', $filepath or die $_;

    # declare regular expressions
    # $DELIMITER:   beginning of Questions
    # $ANSWER:      get Answers if begins with [*any*]
    # $QUESTION:    get Question if begins with *any_Digits*.
    my $DELIMITER = qr/^_____________+/mp;
    my $ANSWER = qr/^ *\[.*\]/mp;
    my $QUESTION = qr/^ *(\d+\.)/mp;

    #auxiliary variables
    my $startPoint = 0;
    my $active_question = "";
    my %data;

    # read file line by line and search for questions or answers
    while (my $nextline = readline($fh)) {
        #Mark the beginning of Test Questions
        if ($nextline =~ $DELIMITER) {
            $startPoint = 1
        }

        # Get Questions
        if ($startPoint == 1 and $nextline =~ $QUESTION) {
            #set $active_questions to search for answers
            ## delete spaces at the beginning of the question
            chomp($nextline);
            $active_question = $nextline =~ s/^ *//r;
        }

        # Get Answers
        if ($startPoint == 1 and $nextline =~ $ANSWER) {
            #push answer to array and delete spaces at the beginning
            chomp($nextline);
            push @{$data{$active_question}}, $nextline =~ s/^ *//r;
        }
    }

    $startPoint = 0;
    close $fh;

    return %data;
}

1;