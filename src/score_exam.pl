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



my $master_file;
my @students_files;

# check if solution and exam file exists
if (@ARGV < 2) {
    die RED, ("Solution File and/or Student Exam Files are missing.")
}
else {
    $master_file = $ARGV[0];
    for my $stud_file (@ARGV[1..((scalar @ARGV)-1)]){
        push(@students_files, $stud_file)
    }
}



sub score_exam {
    #save parameter to variables
    my $filename = shift;
    my %master_exam = %{(shift)};
    my %stud_exam = %{(shift)};
    my $score_exam = 0;
    my $completed_questions = 0;


    say CLEAR, "-----------------------------------------------------------------------------------------------------------------------------------";

    for my $question_master (keys %master_exam) {
        my ($question_number) = $question_master =~ /^(\d+\.)/;

        for my $question_stud (keys %stud_exam) {

            #check all questions and~answers
            #if edistance <=10% inexact matches will be replaced
            if ($question_stud =~ qr/^\Q$question_number\E/mp == 1) {
                my $cf_q = compare($question_master, $question_stud);

                if($cf_q eq "inexact"){
                    $stud_exam{$question_master} = delete $stud_exam{$question_stud};
                    print CYAN, "Missing Question: $question_master";
                    print CYAN, "Used this instead: $question_stud";
                }
                elsif($cf_q eq "missing"){
                    print YELLOW, "Missing Question: $question_master";
                }
                else {
                    #do nothing
                }
            }
        }


        my $lc = List::Compare->new(\@{$master_exam{$question_master}}, \@{$stud_exam{$question_master}});
        my @lonly = $lc->get_Ronly;

        for my $answer (@lonly) {
            foreach (@{$master_exam{$question_master}}) {
                my $cf_a = compare($_ =~ s/\[.*\] *//r, $answer =~ s/\[.*\] *//r);
                if ($cf_a eq "inexact") {

                    #replace answer
                    for my $replace (@{$stud_exam{$question_master}}) {
                        my ($givenAnswer) = $replace =~ m/\[.*\]/g;
                        $replace = $_ =~ s/\[.*\] /$givenAnswer /r if ($replace eq $answer);
                    }

                    print MAGENTA, "Missing Answer:" . $_ =~ s/\[.*\] */ /r;
                    print MAGENTA, "Used this instead:" . $answer =~ s/\[.*\] */ /r;
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
            print BLUE, "Missing Answer:" . $_ =~ s/\[.*\] */ /r;
        }



        #
        # if(@lonly > 0){
        #     foreach(@lonly){
        #         print "Missing Answer: $_";
        #     }
        # }

        # print YELLOW, "Missing answer: $answer";


        # for my $master_answer (sort @{$master_exam{$question_master}}){
        #     for my $stud_answer (sort @{$stud_exam{$question_master}}) {
        #         my $cf_a = compare($master_answer =~ s/^\[.*\] *//r, $stud_answer =~ s/^\[.*\] *//r);
        #         if ($cf_a eq "inexact") {
        #             my ($givenAnswer) = $stud_answer =~ /^\[.*\] /;
        #             $stud_answer = $master_answer =~ s/^\[.*\] */\Q$givenAnswer\E/r;
        #             print MAGENTA, "Missing Answer: $master_answer";
        #             print MAGENTA, "Used this instead: $stud_answer";
        #         }
        #         elsif ($cf_a eq "missing") {
        #            # print YELLOW, "Missing Answer: $master_answer";
        #         }
        #         else {
        #             # do nothing
        #         }
        #
        #     }
        # }

        if (exists($stud_exam{$question_master})) {
            #get answer from master file
            my $correct_answer_master = first {m/\[X].*/p} @{$master_exam{$question_master}};

            # get all checked answers form students file
            my @correct_answer_stud = grep {m/\[X].*/p} @{$stud_exam{$question_master}};

            #if students file has [X] in one answer increment completed question
            if (@correct_answer_stud > 0) {$completed_questions++}
            if (@correct_answer_stud == 1 and $correct_answer_master eq $correct_answer_stud[0]) {
                $score_exam++
            }
        }



    }
    say WHITE, ". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .";
    say GREEN, "$filename => $score_exam/$completed_questions";
    say CLEAR, "-----------------------------------------------------------------------------------------------------------------------------------";

}




#------------------------------------------------------------------------------------------------------------------
# Call functions
#------------------------------------------------------------------------------------------------------------------
my %master_exam = getQuestions_and_Answers($master_file);

for my $sf (@students_files){
    my %stud_exam = getQuestions_and_Answers($sf);
    score_exam($sf, \%master_exam, \%stud_exam); #references to hashes

}

