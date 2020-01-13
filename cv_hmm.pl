$train_file = shift;
open (IN,$train_file);
@train = <IN>;

@D = (.1, .15, .2, .25, .3, .35, .4, .45, .5);
@E = (.2, .25, .3, .35, .4, .45, .5, .55, .6);

my %H;

for(my $i = 0; $i <scalar(@D); $i++) {
  for(my $j = 0; $j < scalar(@E); $j++){
    $H{$D[$i]}{$E[$j]} = 0;
  }
}

my @error = ([(0)*scalar(@D)],[(0)*scalar(@E)]);

for(my $i=0;$i<scalar(@train);  $i++) 
  { 
	$unaligned = $train[$i];
	chomp($unaligned);
	$aligned = $unaligned;
	$aligned =~ s/.unaligned//g;
      print "unaligned=$unaligned, aligned=$aligned\n";

	for (my $j=0;$j<scalar(@D);$j++) #for go value 
	{
		for (my $k=0;$k<scalar(@E);$k++) # for ge value
		{
			$data=$unaligned; #Let data = unaligned data 
				$delta=$D[$j]; #Let delta=D[j]
				$eta=$E[$k]; #lET eta=E[k]
	system("perl hmm.pl $data $delta $eta > hmm"); #call NW(g).pl on 
        $err = `perl alignment_accuracy3.pl $aligned hmm` ;
        
	$error[$j][$k] += $err; 
	$sum = $error[$j][$k];
	$ave = 1 - $sum/scalar(@train);
	#$H{$D[$j]}{$E[$k]} = $ave;
	#print "\n$delta, $eta, $ave\n";
		}
	}
}

for(my $i=0; $i<scalar(@D); $i++){
	for(my $j =0; $j<scalar(@E); $j++){
    $avgAccuracy = $error[$i][$j]/scalar(@train);
    $H{$D[$i]}{$E[$j]} = (1 - $avgAccuracy)*100;
    print $H{$D[$i]}{$E[$j]};
  }
}

print "\n";
print "\n HMM errors sorting:\n";
print "The parameters combination are: delta,  eta, and the training error \n";
print "\n";
for my $keypair(
        sort {$H{$b->[0]}{$b->[1]} <=> $H{$a->[0]}{$a->[1]} }
        map { my $intKey=$_; map [$intKey, $_], keys %{$H{$intKey}} } keys %H
    ) {
    printf( "delta = {%f} & eta = {%f} => %g\n", $keypair->[0], $keypair->[1], $H{$keypair->[0]}{$keypair->[1]} );
}

