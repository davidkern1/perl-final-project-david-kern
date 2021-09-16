package David::Inexact_Matching;
use v5.34;
use strict;
use warnings;
use diagnostics;
use experimental 'signatures';
use Exporter 'import';

use Lingua::StopWords qw( getStopWords );
use Text::Levenshtein::Damerau qw/edistance/;
use Term::ANSIColor qw(:constants);


# Exported functions
our @EXPORT_OK =  ('normalize', 'compare');

sub normalize($string) {
    my $stopwords = getStopWords('en');
    # lowercase text
    $string = lc $string;
    #remove whitespace and stopwords
    $string = join ' ', grep {!$stopwords->{$_}} split /\s+/, $string;
    $string =~ s/^\s+|\s+$//s;

    return $string;
}

sub compare($string_master, $string_stud){
    $string_master = normalize($string_master);
    $string_stud = normalize($string_stud);

    #number of possible incorrect characters (10%)
    my $max_distance = int(length( $string_stud) * 0.1);
    my $edistance = edistance($string_master, $string_stud);

    # calculate distance if smaller than max_distance question will be replaced
    # - If Question replaced => return 1
    # - If distance is too big => return 0
    if( $edistance == 0){
        return "equal"
    }
    elsif($edistance <= $max_distance){
        return "inexact";
    }
    else {
       # say RED, "$string_master vs. $string_stud";

        return "missing";

    }
}

1;

# @lonly = grep {$_ != $answer};
#
# if(@lonly > 0){
#     foreach(@lonly){
#         print "Missing Answer: $_";
#     }
# }