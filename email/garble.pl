#!/usr/bin/perl

use strict;
use warnings;


sub getRandomList{
	my$n=shift;
	my%hash=();
	while(1){
		last if ($n)==(scalar keys %hash);
		my$r=int(rand($n));
		$hash{$r}=1 unless $hash{$r};
	}
	return keys %hash;
}

sub garbleWord{
	my$string=shift;
	my $length=length $string;
	return $string if $length < 4;
	my@ids=getRandomList($length-2);
	my@chars=unpack "C*",$string;
	my$f=pop @chars;
	my$l=shift @chars;
	my@newChars;
	push @newChars,pack "C",$l;
	for(@ids){
		push @newChars,(pack "C",$chars[$_]);
	}
	push @newChars,pack "C",$f;
	return join "",@newChars;
}

sub garbleMessage{
	my$message=shift;
	my$copy=$message;
	while($message=~m/(\w+)/g){
		my$g=garbleWord($1);
		$copy=~s/$1/$g/;
	}
	return $copy;
}

while(<>){
	print garbleMessage($_);
}
