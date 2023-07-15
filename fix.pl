#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
use DBI;

my $dsn = "DBI:SQLite:dbname=data/fix_dictionary.db";
my $conn = DBI->connect($dsn, "", "", {RaiseError => 1}) or die $DBI::errstr;
my $DELIMITER='\|';

print "Successfully connected\n";

sub retrieve_tag_names {
    my @tags = @_;
    my $tag;
    my @values;

    foreach $tag (@tags) {
        my $query = $conn->prepare("SELECT name FROM fix_tags WHERE tag == $tag");
        $query->execute() or die $DBI::errstr;
        if (my @row = $query->fetchrow) {
            push @values, $row[0];
        } 
        else { 
            push @values, "TAG \"$tag\" NOT FOUND";
        }
        $query->finish();
    }
    return @values;
}

open(my $fh, "<", "sample.log") or die "Could not open input file: $!";
my %tag_hash;

while(<$fh>) {
    chomp;
    my @fix_tags = split /$DELIMITER/, $_;

    foreach(@fix_tags) {
        my ($tag_number, $value) = split /=/, $_;
        my @tag_name = retrieve_tag_names($tag_number);
        $tag_hash{$tag_name[0]} = $value;
    }
    foreach(keys %tag_hash) {
        print "$_ => $tag_hash{$_}\n";
    }
    %tag_hash = ();
    print "\n";
}

$conn->disconnect();
print "Successfully disconnected\n";
