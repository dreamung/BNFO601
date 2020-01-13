open(IN,shift);
@l=<IN>;

@a = ();
@b = ();
@s = ();
$aligned = 0;
$unmapped = 0;
$incorrected = 0;

#print "List\n";
for(my $i=2; $i<scalar(@l); $i++)
{
	@s = split(/:/, $l[$i]);
	@m = split(/\s+/, $l[$i]);
	$a[$i] = $s[1];
	$b[$i] = $m[3];
        $c = $a[$i] - $b[$i];
	#print "$a[$i] $b[$i]\n";
	if($c >= -100 && $c <= 100)
        {
		$aligned+=1;
	}
	elsif($b[$i] == 0)
        {
                $unmapped+=1;
	}
        else
        {       $incorrected+=1;
        }           
}

print ("The score of correctly aligned reads is ", $aligned);
print "\n";
$per1 = $aligned/(scalar(@l)-2) *100;
print ("The Percentage of correctly aligned reads is ",$per1);
print "\n";
print "\n";

print ("The score of incorrectly aligned reads is ", $incorrected);
print "\n";
$per2 = $incorrected/(scalar(@l)-2) *100;
print ("The Percentage of incorrectly aligned reads is ",$per2);
print "\n";
print "\n";

print ("The score of unmapped reads is ", $unmapped);
print "\n";
$per3 = $unmapped/(scalar(@l)-2) *100;
print ("The Percentage of unmapped reads is ",$per3);
print "\n";
print "\n";