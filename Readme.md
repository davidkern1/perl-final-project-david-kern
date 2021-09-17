# Final Project for "Introduction to Perl for Programmers"
### Author:
David Kern <i>(david.kern1@students.fhnw.ch)</i>

#### Table of Content
- [General](#general)
  - [Team](#team)
  - [Solved parts of the assignments](#solved-parts-of-the-assignments)
- [High-Level Overview](#high-level-overview)
  - [Implemented Features](#implemented-features)
  - [Data Structure](#data-structure)
  - [Data Structure](#data-structure)
  - [General Code Structure](#general-code-structure)
  - [Problems](#problems)
- [Usage & Installation](#usage--installation)
  - [(CPAN-)modules Used](#cpan-modules-used)
  - [Running the Scripts](#running-the-scripts)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents
generated with markdown-toc</a></i></small>


---
## General
- This project is an assignment for the perl-course held by Dr. Damian Conway from
  Australia in summer 2020.
- In here, you find perl script for (semi-)automated assessment of a multiple choice
  exam in text format and the creation of ready to use empty exam files generated from a
  'master exam file', with randomized order of the answers.
- See [IntroPerl_project_specification_2020.pdf](IntroPerl_project_specification_2020.pdf)
  for extended project description.

### Team
- Andreas Ambühl - https://github.com/AndiSwiss
- Luca Fluri - https://github.com/lucafluri


### Solved parts of the assignments
- We have solved the following parts of the assignment:
  - Part 1
  - Part 2
  - Part of the tasks of part 3

---

## High-Level Overview

### Implemented Features
- Create empty exams (with randomized order of answers of each question)
- Generate score(s) of the provided exam(s), including analysis and colored output of:
  - Filename (yellow)
  - 'Missing answer' (red)
  - 'Inexact match' (blue)
  - 'score' including correct and answered questions (green)
  - Note: we chose a colored output for easy identification of the various parts
- Statistics:
  - The statistics are generated and printed automatically when calculating the score(s)
    of file(s)

### Data Structure
- We decided to mostly use a nested hash-/array-structure, which we were able to generate
  with the descriptive approach of a regex-grammar shown by Dr. Damian Conway. You can find
  the regex-grammar in our custom module [lib/Andiluca/Exam_Parser.pm](lib/Andiluca/Exam_Parser.pm).
  This main data structure contains the following structured elements:
  - 'exam'
    - an array of 'exam_component', each containing:
      - 'question_and_answers'
        - 'question'
          - 'question_number'
          - 'text' (containing the question-text)
        - an array of 'answer', each containing:
          - 'checkbox' (marked or unmarked)
          - 'text' (containing the answer-text)
      - 'decoration' (basically all lines not containing questions and answers)
- Other elements, such as 'empty_line' are recognized but not saved in the generated
  hash-structure.


### General Code Structure
- The starting points are one of the following options:
  - [src/create.pl](src/create.pl) for creating empty exams with randomized questions.
  - [src/score.pl](src/score.pl) for scoring (multiple) exams and generating statistics.
- For better code-readability and -maintainability, we structured the code in various
  sub-routines. For enhancing, we exported may sub-routines in custom written modules:
  - [lib/Andiluca/Create_Empty_Random_Exam.pm](lib/Andiluca/Create_Empty_Random_Exam.pm)
    - `sub create_empty_random_exam(..)`
  - [lib/Andiluca/Exam_Parser.pm](lib/Andiluca/Exam_Parser.pm)
    - `sub parsing_exam(..)`
  - [lib/Andiluca/Statistics.pm](lib/Andiluca/Statistics.pm)
    - `sub print_statistics(..)`
    - `sub print_one_line(..)`
  - [lib/Andiluca/Understand_Data_Structure.pm](lib/Andiluca/Understand_Data_Structure.pm)
    - `sub understand_data_structure1(..)`
  - [lib/Andiluca/Useful.pm](lib/Andiluca/Useful.pm)
    - `sub assert(..)`
    - `sub title(..)`
  - [lib/Andiluca/Various.pm](lib/Andiluca/Various.pm)
    - `sub parse_header(..)`
    - `sub parse_decoration_divider(..)`
    - `sub get_current_date_time_string()`
    - `sub read_file(..)`
    - `sub save_file(..)`
    - `sub create_new_file_path(..)`
- The exam-files are in the following subfolders:
  - `AssignmentDataFiles/MasterFiles/`
  - `AssignmentDataFiles/SampleResponses/`
- Newly generated empty exam-files (with randomized answers) are saved in the subfolder
  `Generated` where the given master-file resides, e.g.:
  - `AssignmentDataFiles/MasterFiles/Generated/`


### Problems
- At first, it was not easy to understand how to use the nested hash-array data-structure
  which the parser was able to produce. For this, we created our custom module
  [lib/Andiluca/Understand_Data_Structure.pm](lib/Andiluca/Understand_Data_Structure.pm).
  - You can activate/deactivate the use of this module in the file [src/create.pl](src/create.pl)
    by (un-)commenting the line `# understand_data_structure1(\%parsed);`.
- At some points, we had some different behaviour on the macOS-computer of Andreas and the
  linux-computer of Luca. But eventually the problems were solved (not yet clear why, maybe
  just a simple computer reboot).

---
## Usage & Installation

### (CPAN-)modules Used
- We used the following (CPAN-)modules. Please install them on your computer prior to
  use this software:
  - Data::Show
  - Exporter
  - Lingua::StopWords
  - List::Util
  - POSIX
  - Regexp::Grammars
  - Term::ANSIColor
  - Text::Levenshtein::Damerau
- We created custom modules -> in the folder `lib/Andiluca`. If you run the perl scripts
  from the project-root, then these modules should be automatically detected and ready to
  use: For example `perl src/create.pl` should work, after you installed all required
  CPAN-Modules.

### Running the Scripts
- For running the scripts, you need `Perl v 3.8.5` installed with the above mentioned
  CPAN-modules.
- We have successfully tested the scripts on `macOS 10.15.6` and `Linux Ubuntu 18.04`.
- For creating empty exam files (with randomized order of answers of each question), use the
  script [src/create.pl](src/create.pl):
  - If you don't provide an argument, all the *.txt in the folder
    'AssignmentDataFiles/MasterFiles/' are processed for this script: `perl src/create.pl`
  - If you provide one argument, the script runs with the given file. Example:
    `perl src/create.pl AssignmentDataFiles/MasterFiles/short_exam_master_file.txt`
  - The generated empty exams will be created in a subfolder named `/Generated`,
    inside the directory of the provided file. Note: This subdirectory will be created if
    not already present.
- For generating the score of all the files, use the script [src/score.pl](src/score.pl):
  - First parameter: Master-file
  - Second parameter: Student-file(s)
  - Example: `perl src/score.pl AssignmentDataFiles/MasterFiles/FHNW_entrance_exam_master_file_2017.txt AssignmentDataFiles/SampleResponses/*`
  - Note: Calculating the score of many files can take a while, mostly because the
    distance-algorithms take some time.
- The script `statistics_stub.pl` is a helper file:
  - With this, you can quickly try the statistics functionality with some stub exam
    data (no pre-calculations needed)

