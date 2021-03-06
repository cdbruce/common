#!/usr/bin/perl -w
# original author: Nick Stoler
use strict;

if (@ARGV && $ARGV[0] =~ m/^-?-h/) {
	print "USAGE:
  \$ grep -v '^\@' mapped-reads.sam | $0
or
  \$ samtools view mapped-reads.bam | $0
or
  \$ $0 mapped-no-header.sam
Counts the different tags used in a SAM file.
It won't work on SAM files with a header, so you'll have to remove those lines
yourself if the file contains them.
<> operator: works on stdin or as many filename arguments as you want.\n";
  exit(0);
}

my %tags;
while (<>) {
  chomp();
  my @fields = split("\t");
  @fields = @fields[11..$#fields];
  for my $field (@fields) {
    $tags{substr($field, 0, 2)}++;
  }
}

for my $tag (sort_hash(%tags)) {
  print "$tag: $tags{$tag}\n";
}


# Sort a dictionary by its values (largest to smallest)
# Takes a hash, returns an ordered array of its keys
sub sort_hash {
  my %hash = @_;
  my @keys_unsorted = keys(%hash);
  my @keys_sorted =
    map  { $_->[0] }
    sort { $b->[1] <=> $a->[1] }
    map  { [ $_, $hash{$_} ] }
    @keys_unsorted;
  return @keys_sorted;
}
