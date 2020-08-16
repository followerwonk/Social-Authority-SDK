#!/usr/bin/env perl
use 5.12.1;
use warnings;
use HTTP::Thin::UserAgent;
use Getopt::Long;
use Digest::HMAC_SHA1 qw(hmac_sha1_hex);

my $uri = 'https://api.followerwonk.com/social-authority/';

GetOptions(
    'uri=s' => \$uri,
    'id=s'  => \my $id,
    'key=s' => \my $key,
) or die;

die "Must supply --id and --key" unless $id && $key;

my $now       = time;
my $signature = hmac_sha1_hex( "$id\n$now", $key );
my $auth      = "AccessID=$id;Timestamp=$now;Signature=$signature";

while ( my $names = join ',', splice @ARGV, 0, 99 ) {
    say http( GET "$uri?screen_name=$names",
        Authorization => "WonkSigned $auth" )->as_json->response->dump;
}
