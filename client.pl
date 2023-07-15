#!/usr/bin/env perl

use strict;
use warnings;
use IO::Socket::INET;

my $server_address = "app.fixsim.com";
my $server_port = 15000;

print "Attempting to connect to $server_address:$server_port\n";
my $socket = IO::Socket::INET->new(
    PeerAddr => $server_address,
    PeerPort => $server_port,
    Proto    => 'tcp'
) or die "Connection error: $!";
print "Successfully connected to $server_address:$server_port\n";

#my $data;
#
#while (1) {
#    $socket->recv($data, 1024);
#}

$socket->close();
print "Connection closed\n";
