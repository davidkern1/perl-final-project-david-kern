use v5.34;
use strict;
use warnings;
use diagnostics;
use experimental 'signatures';
use Term::ANSIColor qw(:constants);
use List::Compare;
use List::Util 'first';

# import custom modules David from /custom_modules directory
use lib ('custom_modules');
use David::Questions_and_Answers ('getQuestions_and_Answers');
use David::Inexact_Matching ('normalize', 'compare');


# declare variables of the input files
my $master_file;
my @students_files;

# check if solution and exam file exists
if (@ARGV < 2) {
    die RED, ("Solution File and/or Student Exam Files are missing.")
}
# Assign input files to variables
else {
    $master_file = $ARGV[0];
    for my $stud_file (@ARGV[1..((scalar @ARGV)-1)]){
        push(@students_files, $stud_file)
    }
}


#=========================================================================================
# declare functions
#_________________________________________________________________________________________

# Get students exam score
# Parameters:
# - $filename
# - (%) questions and answers of master file
# - (%) questions and answers of student file
# Return:
# - Prints inexact matches, missing questions and answers
# - Prints students filename with correct answers and completed questions
sub score_exam {
    #save parameter to variables
    my $filename = shift;
    my %master_exam = %{(shift)};
    my %stud_exam = %{(shift)};

    #auxiliary variables
    my $score_exam = 0;
    my $completed_questions = 0;

    #formatting output
    say CLEAR, "-----------------------------------------------------------------------------------------------------------------------------------";

    #_________________________________________________________________________________________
    # check for inexact and missing questions
    for my $question_master (keys %master_exam) {
        # get question number from master file for comparison
        my ($question_number) = $question_master =~ /^(\d+\.)/;

        for my $question_stud (keys %stud_exam) {

            # serach for given question number
            if ($question_stud =~ qr/^\Q$question_number\E/mp == 1) {
                my $cf_q = compare($question_master, $question_stud);

                # replace inexact question in students file
                if($cf_q eq "inexact"){
                    $stud_exam{$question_master} = delete $stud_exam{$question_stud};
                    say CYAN, "Missing Question: $question_master";
                    say CYAN, "Used this instead: $question_stud";
                }
                # show missing question in students file
                elsif($cf_q eq "missing"){
                    say YELLOW, "Missing Question: $question_master";
                }
                else {
                    #do nothing
                }
            }
        }
        #_________________________________________________________________________________________
        # check for inexact and missing answers

        # compare list of answers for differences
        my $lc = List::Compare->new(\@{$master_exam{$question_master}}, \@{$stud_exam{$question_master}});
        my @lonly = $lc->get_Ronly;

        for my $answer (@lonly) {
            foreach (@{$master_exam{$question_master}}) {
                my $cf_a = compare($_ =~ s/\[.*\] *//r, $answer =~ s/\[.*\] *//r);

                # replace inexact answers in students file
                if ($cf_a eq "inexact") {
                    for my $replace (@{$stud_exam{$question_master}}) {
                        my ($givenAnswer) = $replace =~ m/\[.*\]/g;
                        $replace = $_ =~ s/\[.*\] /$givenAnswer /r if ($replace eq $answer);
                    }
                    say MAGENTA, "Missing Answer:" . $_ =~ s/\[.*\] */ /r;
                    say MAGENTA, "Used this instead:" . $answer =~ s/\[.*\] */ /r;
                }
                else {
                    #do nothing
                }
            }
        }

        #show Missing Answers after evaluating inexact matching
        my $lc2 = List::Compare->new(\@{$stud_exam{$question_master}}, \@{$master_exam{$question_master}});
        my @missing = $lc2->get_Ronly;
        foreach(@missing){
            say BLUE, "Missing Answer:" . $_ =~ s/\[.*\] */ /r;
        }

        #_________________________________________________________________________________________
        # calculate score of studentsfile
        if (exists($stud_exam{$question_master})) {
            #get answer from master file
            my $correct_answer_master = first {m/\[X].*/p} @{$master_exam{$question_master}};

            # get all checked answers form students file
            my @correct_answer_stud = grep {m/\[X].*/p} @{$stud_exam{$question_master}};

            #if students file has [X] in one answer increment completed question
            if (@correct_answer_stud > 0) {$completed_questions++}

            # check if only one and the correct answer is checked, else the answer is incorrect
            if (@correct_answer_stud == 1 and $correct_answer_master eq $correct_answer_stud[0]) {
                $score_exam++
            }
        }
    }
    #formatting output
    say WHITE, ". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .";
    say GREEN, "$filename => $score_exam/$completed_questions";
    say CLEAR, "-----------------------------------------------------------------------------------------------------------------------------------";
}
#=========================================================================================

#-----------------------------------------------------------------------------------------
# Call functions
#-----------------------------------------------------------------------------------------
# save all Questions (key) and Answers (value) in a hash
my %master_exam = getQuestions_and_Answers($master_file);

for my $sf (@students_files){
    # save all Questions (key) and Answers (value) in a hash
    my %stud_exam = getQuestions_and_Answers($sf);

    # print and calculate score of the students file
    score_exam($sf, \%master_exam, \%stud_exam); #references to hashes
}

