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

# Normalizes a given string for comparison
# Parameter:
# - $string
# Returns:
# - normalized $string
sub normalize($string) {
    # get all stopwords from Lingua::StopWords module
    my $stopwords = getStopWords('en');

    # lowercase string
    $string = lc $string;

    #remove whitespace and stopwords
    $string = join ' ', grep {!$stopwords->{$_}} split /\s+/, $string;
    $string =~ s/^\s+|\s+$//s;

    return $string;
}

# compares two strings and checks if the difference is <= 10%
# Parameters:
# - $string_master
# - $string_stud
# Returns:
# - "equal" if the strings are identical
# - "inexact" it the strings differ by a maximum of 10%
# - "missing" it the strings differ by a minimum of 11% or more
sub compare($string_master, $string_stud){
    $string_master = normalize($string_master);
    $string_stud = normalize($string_stud);

    #number of possible incorrect characters (10%)
    my $max_distance = int(length( $string_stud) * 0.1);

    # get number of miss matching characters
    my $edistance = edistance($string_master, $string_stud);

    # if distance smaller than max_distance question will be replaced
    if( $edistance == 0){
        return "equal"
    }

    # if $string_stud will be replaced => return "inexact"
    elsif($edistance <= $max_distance){
        return "inexact";
    }

    # if distance of $string_master vs $string_stud is too big => return "missing"
    else {
        return "missing";
    }
}

1;
