#!/usr/bin/perl -w

use strict;

# opens a generic .mdp file and replaces the values of
# 'init_lambda_state' with values at increments of 1

unless (@ARGV) {
    die "Usage: $0 input.mdp\n";
}

my $mdp = $ARGV[0];

my @temp = split('\.', $mdp);
my $base = $temp[0];

open(IN, "<$mdp");
my @in = <IN>;
close(IN);

# note we are specifying indices for states, not actual lambda values like in previous versions
for (my $i=0; $i<33; $i++) {

    my $filename = "${base}_${i}.mdp";

    open(OUT, ">$filename");

    foreach $_ (@in) {
        #unless ($_ =~ /^init_lambda_state/ || $_ =~ /^pull_coord1_k/ || $_ =~ /^pull_coord2_k/) {
        #    print OUT $_;
	#}
        unless ($_ =~ /^init_lambda_state/) {
            print OUT $_;
	}
        if ($_ =~ /^init_lambda_state\s*=/) {
            printf OUT "%s %d\n", $&, $i;
        }
        #if ($_ =~ /^pull_coord1_k\s*=/) {
        #    printf OUT "%s %d\n", $&, 4000;
        #}

        #if ($_ =~ /^pull_coord2_k\s*=/) {
        #    printf OUT "%s %d\n", $&, 4000;
        #}
    }

    close(OUT);

}

exit;
