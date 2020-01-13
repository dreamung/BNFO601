#assignment 6
#!/usr/bin/perl

use strict;
use warnings;

my $dir = './';

opendir(DIR, $dir) or die $!;

while (my $file = readdir(DIR)) {

    # We only want files
    next unless (-f "$dir/$file");

    # Use a regular expression to find files ending in .txt
    next unless ($file =~ m/\.sam$/);
    print "For $file";
    print "\n";
	my $per = system("perl split.pl $file");

	print "\n";

}

closedir(DIR);
exit 0;

