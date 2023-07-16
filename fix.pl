#!/usr/bin/env perl
use warnings;
use strict;
use DBI;
use File::Tail;

my $dsn = "DBI:SQLite:dbname=data/fix_dictionary.db";
my $conn = DBI->connect($dsn, "", "", {RaiseError => 1}) or die $DBI::errstr;
my $log_path = "sample.log";
my $DELIMITER='\|';

print "Successfully connected\n";

sub retrieve_tag_names {
    my @tags = @_;
    my @values;

    foreach my $tag (@tags) {
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

my $file = File::Tail->new(name=>$log_path, maxinterval=>5, interval=>1, tail=>-1);
my %tag_hash;
while(defined(my $line = $file->read)) {
    chomp $line;
    my @fix_tags = split /$DELIMITER/, $line;

    foreach my $tag_value (@fix_tags) {
        my ($tag_number, $value) = split /=/, $tag_value;
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
