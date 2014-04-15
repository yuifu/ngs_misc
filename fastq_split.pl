#!/usr/bin/perl -w

use List::Util 'shuffle';
use File::Basename qw/basename dirname/;

chomp(@ARGV);
my ($ifile, $n_split, $seed, $odir) = @ARGV;


# For test
# $ifile = "test.fq"; # $ifile = "test.fastq";
# $n_split = 3;
if(!defined $n_split){
	die "Error: The number of split is not defined!";
}
if(!defined $seed){
	$seed = 1234;	
}
if(!defined $odir){
	$odir = dirname($ifile);
}
# End of For test


srand $seed;


# Opening output filehandles 
$ifile =~ /\.([^.]+?)$/;
my $extension = $1;
my $catin = "cat";
my $catout = "";
if($extension =~ /(gz|gzip)/){
	$ifile =~ /\.([^.]+?\.[^.]+?)$/;
	$extension = $1;
	$catin = "gzip -cd"; # $cat = "zcat";
	$catout = "| gzip -c ";
}
my @fhs = ();
for(my $i = 1; $i <= $n_split; $i++){
	my $ofile = $odir . "/" . basename($ifile, ".$extension") . ".split_${i}_of_${n_split}.$extension";
	print "output: $ofile\n";
	my $fh;	
	open($fh, "$catout > $ofile");
	push(@fhs, *$fh);
}


# Count the number of entries
my $n_entry = 0;
open(I, "$catin $ifile |");
while(<I>){
	$n_entry++;
}
close(I);
$n_entry = $n_entry / 4; # FASTQ record consists of four lines


# Making random numbers
my @ran = shuffle(1..$n_entry);
# print @ran;


# Reading entries and split in a fixed number of files
my $count = 0;
my $residue;
open(I, "$catin $ifile |");
while(<I>){
	# print "!! $ran[$count]\n";
	$residue = $ran[$count] % $n_split;
	print {$fhs[$residue]} $_;
	$_ = <I>;
	print {$fhs[$residue]} $_;
	$_ = <I>;
	print {$fhs[$residue]} $_;
	$_ = <I>;
	print {$fhs[$residue]} $_;
	$count++;
}
close(I);


# Close filehandels
for(my $i = 0; $i < $n_split; $i++){
	close($fhs[$i]);
}
