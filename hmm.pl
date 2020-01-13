open(IN, shift);
@data = <IN>; close(IN); chomp(@data);
$seq1 = $data[1]; $seq2 = $data[3];
$delta = shift; $eta = shift;

####### Transition probabilities#####
$BX = $delta; $BY = $delta; $BM = 1 - 2*$delta;
$MX = $delta; $MY = $delta; $MM = 1 - 2*$delta;
$XX = $eta; $XY = 0; $XM = 1 - $eta;
$YY = $eta; $YX = 0; $YM = 1 - $eta;

###### Emission probabilities #####
$pgap = 1; $pm = 0.6; $pmm = 1 - $pm;

###### Initialize B ###### 
$B[0][0] = 1; $B[0][1] = 0; $B[1][0] = 0;
for(my $i=1; $i<=length($seq2); $i++)
{
  for(my $j=1; $j<=length($seq1); $j++)
      {$B[$i][$j] = 0;}
}

###### Initialize M ######
$M[0][0] = 0;
for(my $i=1; $i<=length($seq2); $i++)
      {$M[$i][0] = 0;}
for(my $j=1; $j<=length($seq1); $j++)
      {$M[0][$j] = 0;}

###### Initialize X ######
$X[0][0] = 0;
$X[1][0] = $pgap * $BX * $B[0][0];
for(my $i=2; $i<=length($seq2); $i++)
      {$X[$i][0] = $pgap * $XX * $X[$i-1][0];}
for(my $j=1; $j<=length($seq1); $j++)
      {$X[0][$j] = 0;}

###### Initialize Y ######
$Y[0][0] = 0;
$Y[0][1] = $pgap * $BY * $B[0][0];
for(my $i=1; $i<=length($seq2); $i++)
      {$Y[$i][0] = 0;}
for(my $j=2; $j<=length($seq1); $j++)
      {$Y[0][$j] = $pgap * $YY * $Y[0][$j-1];}

###### Initialize T ######
for(my $i=1; $i<=length($seq2); $i++)
      {$T[$i][0] = 'U';}
for(my $j=1; $j<=length($seq1); $j++)
      {$T[0][$j] = 'L';}


###### Recurrence ######
for(my $i=1; $i<=length($seq2); $i++)
{
    for(my $j=1; $j<=length($seq1); $j++)
     {
       $ch1 = substr($seq1, $j-1, 1);
       $ch2 = substr($seq2, $i-1, 1);
       if($ch1 eq $ch2) {$p = $pm;}
       else            {$p = $pmm;}

       $x = $MM*$M[$i-1][$j-1]; $y = $XM*$X[$i-1][$j-1];
       $z = $YM*$Y[$i-1][$j-1]; $w = $BM*$B[$i-1][$j-1];
       if($x >= $y && $x >= $z && $x >= $w) {$M[$i][$j]=$p*$x;}
       elsif($y >= $x && $y >= $z && $y >= $w) {$M[$i][$j]=$p*$y;}
       elsif($z >= $y && $z >= $x && $z >= $w) {$M[$i][$j]=$p*$z;}
       elsif($w >= $y && $w >= $z && $w >= $x) {$M[$i][$j]=$p*$w;}

       $x = $MX * $M[$i-1][$j]; $y = $XX * $X[$i-1][$j];
       $w = $BX * $B[$i-1][$j];
       if($x >= $y && $x >= $w) {$X[$i][$j] = $pgap * $x;}
       elsif($y >= $x && $y >= $w) {$X[$i][$j] = $pgap * $y;}
       elsif($w >= $y && $w >= $x) {$X[$i][$j] = $pgap * $w;}

       $x = $MY * $M[$i][$j-1]; $y = $YY * $Y[$i][$j-1];
       $w = $BY * $B[$i][$j-1];
       if($x >= $y && $x >= $w) {$Y[$i][$j] = $pgap * $x;}
       elsif($y >= $x && $y >= $w) {$Y[$i][$j] = $pgap * $y;}
       elsif($w >= $y && $w >= $x) {$Y[$i][$j] = $pgap * $w;}

      # if($M[$i][$j] >= $X[$i][$j] && $M[$i][$j] >= $Y[$i][$j]) {$T[$i][$j] = 'D';}
       if($X[$i][$j] >= $M[$i][$j] && $X[$i][$j] >= $Y[$i][$j]) {$T[$i][$j] = 'U';}
       elsif($Y[$i][$j] >= $M[$i][$j] && $Y[$i][$j] >= $X[$i][$j]) {$T[$i][$j] = 'L';}
       elsif($M[$i][$j] >= $X[$i][$j] && $M[$i][$j] >= $Y[$i][$j]) {$T[$i][$j] = 'D';}

    }
}


=pod

print "\n";
print "Matrix X is \n";
for(my $i=1; $i<length($seq1)+1; $i++)
   {
     for(my $j=1; $j<length($seq2)+1; $j++)
      {
        print($X[$i][$j]." ");
      }
    print("\n");
   }
 print("\n");


print "Matrix Y is \n";
for(my $i=1; $i<length($seq1)+1; $i++)
   {
     for(my $j=1; $j<length($seq2)+1; $j++)
      {
        print($Y[$i][$j]." ");
      }
    print("\n");
   }
 print("\n");

=cut

########## Traceback ########
$alnseq1="";
$alnseq2="";
$i=length($seq2);
$j=length($seq1);

while(!($i == 0 && $j == 0))
{
  if($T[$i][$j] eq "L")
    {
      $alnseq1=substr($seq1, $j-1, 1).$alnseq1;
      $alnseq2="-".$alnseq2; $j=$j-1;
    }
  elsif($T[$i][$j] eq "U")
    {
      $alnseq1="-".$alnseq1;
      $alnseq2=substr($seq2, $i-1,1).$alnseq2; $i=$i-1;
    }
  elsif($T[$i][$j] eq "D")
    {
      $alnseq1=substr($seq1, $j-1, 1).$alnseq1;
      $alnseq2=substr($seq2, $i-1, 1).$alnseq2;
      $i=$i-1;  $j=$j-1;
    }
}

print "$data[0]\n";
print "$alnseq1\n";
print "$data[2]\n";
print "$alnseq2\n";

