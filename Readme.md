# Final Project for "Introduction to Perl for Programmers"
### Author:
David Kern <i>(david.kern1@students.fhnw.ch)</i>

### Table of Contents
- [General](#general)
  - [Solved assignment tasks](#solved-assignment-tasks)
- [Usage](#usage)
- [Styling](#styling)
- [Structure](#structure)
- [Modules](#modules)
  - [CPAN Modules](#cpan-modules)
  - [Custom Modules](#custom-modules)
- [Testing](#testing)
- [Retrospective](#retrospective)

<a name="general"></a>
## General
- This project is an assignment for the module "Introduction to Perl for Programmers" at the University of Applied Sciences Northwestern Switzerland.
  - Lecturer: Dr. Damian Conway.
- The assignment includes a semi-automatic test check of the single choice introduction test from the Perl module as well as a generation of an unsolved test with randomized answers.


<a name="solved-assignment-tasks"></a>
### Solved assignment tasks
This assignment includes the following tasks:
- Part 1a and 1b
- Part 2

<a name="usage"></a>
## Usage
To generate an empty exam file from a master file, use the script [create_new_test.pl](src/create_new_test.pl). It removes
all correct answers and saves the generated file to the directory `/EmptyTestfiles`.
```
perl src/create_new_test.pl AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt
```

To get the result and achieved score of one (or more) completed tests, the script [score_exam.pl](src/score_exam.pl) is used.
The script expects two arguments. The first argument is the master file with the solutions. The second argument is the student exam(s) to be tested.
```
perl src/score_exam.pl AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt AssignmentDataFiles/SampleResponses/*
```

<a name="styling"></a>
## Styling
Due to the fact that the output of many tests quickly becomes confusing, the different outputs have been differentiated by color. Additional separators with (. . . . , ____) additionally improve the readability and coherence of the output.

|Color  | Meaning|
|--------|------------|
|RED    | incorrect command input due to missing exam files|
|CYAN   | inexact matching question|
|MAGENTA| inexact matching answer|
|YELLOW | missing question|
|BLUE   | missing answer|
|GREEN  | students filename with reached score |
|CLEAR    | separator like . . .  and ____|



<a name="structure"></a>
## Structure
|Folder  | Description|
|--------|------------|
|AssignmentDataFiles    | Files to test the program. Such as Master File and Sample Responses|
|custom_modules         | Created Modules which are used for the main scripts|
|src                    | Scripts to execute the tasks, with usage of the created custom_modules |     
|test                   | Testcases to verify the functionality of the custom modules|


<a name="modules"></a>
## Modules
A wide variety of modules were used for this project. The following is a list of existing modules and what they were used for. After that, the specially created modules and their functions will be discussed.


<a name="cpan-modules"></a>
### CPAN Modules
#### [Experimental](https://metacpan.org/pod/experimental)
for defining functions with parameters


#### [Exporter](https://metacpan.org/pod/Exporter)
for exporting functions from modules


#### [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor)
for printing colored text to console


#### [Lingua::StopWords](https://metacpan.org/pod/Lingua::StopWords)
for eliminating the stop words from a string


#### [Text::Levenshtein::Damerau](https://metacpan.org/pod/Text::Levenshtein::Damerau)
for correction of missmatching answers or questions


#### [List::Util](https://metacpan.org/pod/List::Util)
for searching of the correct answer in master file


#### [List::Compare](https://metacpan.org/pod/List::Compare)
for comparing two arrays and get items which appear (at least once) 


#### [DateTime](https://metacpan.org/pod/DateTime)
for getting current date and time to create new empty exam file


#### [File::Basename](https://metacpan.org/pod/File::Basename)
for extracting basename of input file


<a name="custom-modules"></a>
### Custom Modules

#### [Questions_and_Answers](custom_modules/David/Questions_and_Answers.pm)
Used to extract questions and answers and store into a %hash variable

|Functions  | Description|
|--------|------------|
|`getQuestions_and_Answers`    | takes a filepath as parameter; searches for all questions and answers and stores them into a hash variable|

#### [Inexact_Matching](custom_modules/David/Inexact_Matching.pm)
Used to normalize a string and compares two normalized string if the differ more than 10%

|Functions  | Description|
|--------|------------|
|`normalize`    | takes a string as parameter; removes stop words and whitespace and lowercases string|
|`compare`    | takes two strings as parameters; compares two strings and checks if the difference is <= 10% |

<a name="testing"></a>
## Testing
To test the functionality of the modules, the functions have been checked for correctness. To start the tests, the following commands are required:
```
perl tests/getQuestions_and_Answers.t 
perl tests/inexact_matching.t    
```

<a name="retrospective"></a>
## Retrospective
### Problem saving question and answer in %hash
In the beginning I had a hard time saving the questions and answers into a hash. 
The problem was that under each question (key) all corresponding answers (value in an array) 
should be stored. With the help of an additional auxiliary variable $active_questions this 
could be solved well. As soon as a new question is detected, the answers are stored under 
the newly set $active_question key.

### Problem find completly missing anwers
Another problem was the detection of completely missing answers. First, all answers are compared and possible inaccuracies of less than 10% are replaced with the correct answer (only the original checkbox is not replaced) in the master file.
Using the List::Compare module, the answer arrays of the master file and the student file could be compared. With the function `get_Ronly` those answers could be found which are not contained in the answers of the student file.

### What would I do differently?
instead of manually storing the questions and answers line by line in a hash variable, 
I would use the module [Regexp::Grammers](https://metacpan.org/pod/Regexp::Grammars) 
to parse the files. This would have certainly simplified the whole process. Unfortunately I
found this useful module late in the implementation, so there was not enough time to adapt 
it accordingly. As the saying goes, you learn from your mistakes. There are certainly still 
some improvements to be made so that all kinds of different test scenarios work reliably.


I found the task of a semi-automatic check of exams very exciting and thank you for the detailed tutorials.
