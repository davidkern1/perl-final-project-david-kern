package David::Questions_and_Answers;
use v5.34;
use strict;
use warnings;
use diagnostics;
use experimental 'signatures';
use Exporter 'import';

# Exported functions
our @EXPORT_OK =  ('getQuestions_and_Answers');


sub getQuestions_and_Answers($filepath) {
    open my $fh, '<', $filepath or die $!;
    my $DELIMITER = qr/^_____________+/mp;
    my $ANSWER = qr/^ *\[.*\]/mp;
    my $QUESTION = qr/^ *(\d+\.)/mp;

    my $startPoint = 0;
    my $active_question = "";
    my %data;

    while (my $nextline = readline($fh)) {
        #Mark the beginning of Test Questions
        if ($nextline =~ $DELIMITER) {
            $startPoint = 1
        }
        # Get Questions
        if ($startPoint == 1 and $nextline =~ $QUESTION) {
            #remove Question Number and set active question
            #$active_question = $nextline =~ s/^ *(\d+\.) +//r;
            $active_question = $nextline =~ s/^ *//r;

        }
        # Get Answers
        if ($startPoint == 1 and $nextline =~ $ANSWER) {
            #push answer to array and delete spaces at the beginning
            push @{$data{$active_question}}, $nextline =~ s/^ *//r;
        }
    }
    $startPoint = 0;
    close $fh;
    return %data;
}

1;