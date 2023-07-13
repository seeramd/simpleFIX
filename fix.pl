#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
use DBI;

my $DELIMITER='\|';
sub retrieve_tag_name {
}

my $dsn = "DBI:SQLite:dbname=data/fix_dictionary.db";
my $conn = DBI->connect($dsn, "", "", {RaiseError => 1}) or die $DBI::errstr;
print "Successfully connected\n";
$conn->disconnect();
print "Successfully disconnected\n";

open(my $fh, "<", "sample.log") or die "Could not open imput file: $!";

while(<$fh>) {
    chomp;
    my @pieces = split /$DELIMITER/, $_;
    print Dumper(@pieces);
}
