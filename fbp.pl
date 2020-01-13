open(IN, shift);
@data = <IN>; close(IN); chomp(@data);
$seq1 = $data[1]; $seq2 = $data[3];
#$delta = shift; $eta = shift;
$delta = .2; $eta = .4; $tau = 0;

print "Forward\n";
####### Transition probabilities#####
$BX = $delta; $BY = $delta; $BM = 1 - 2*$delta - $tau;
$MX = $delta; $MY = $delta; $MM = 1 - 2*$delta - $tau;
$XX = $eta; $XY = 0; $XM = 1 - $eta - $tau;
$YY = $eta; $YX = 0; $YM = 1 - $eta - $tau;

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



###### Forward Recurrence ######
@f =();
$f[0][0] = 0;

print("Forward values:\n");

for(my $i=1; $i<=length($seq2); $i++)
{
    for(my $j=1; $j<=length($seq1); $j++)
     {
       $ch1 = substr($seq1, $j-1, 1);
       $ch2 = substr($seq2, $i-1, 1);
       $f[$x][$j] = $ch1;
       $f[$i][$y] = $ch2;
       if($ch1 eq $ch2) {$p = $pm;}
       else             {$p = $pmm;}

       $x = $MM*$M[$i-1][$j-1]; $y = $XM*$X[$i-1][$j-1];
       $z = $YM*$Y[$i-1][$j-1]; $w = $BM*$B[$i-1][$j-1];
       #print "x=$x, p=$p, z=$z, w=$w\n";
       $M[$i][$j] = $p*$x + $p*$y + $p*$z + $p*$w;

       $x = $MX * $M[$i-1][$j]; $y = $XX * $X[$i-1][$j];
       $w = $BX * $B[$i-1][$j];
       $X[$i][$j] = $pgap * $x + $pgap * $y + $pgap * $w;        

       $x = $MY * $M[$i][$j-1]; $y = $YY * $Y[$i][$j-1];
       $w = $BY * $B[$i][$j-1];
       $Y[$i][$j] = $pgap * $x + $pgap * $y + $pgap * $w;

       $f[$i][$j] = $M[$i][$j] + $X[$i][$j] + $Y[$i][$j];

  
       print("i=$i j=$j M[$i][$j]=$M[$i][$j] X[$i][$j]=$X[$i][$j] Y[$i][$j]=$Y[$i][$j]\n");

    }
}

print "\n";
print "Backward\n";

###### Backward Initialize ######
@Bb=(); @Mb=(); @Xb=(); @Yb=(); 

$x = length($seq2);
$y = length($seq1);
$BX = $delta; $BY = $delta; $BM = 1 - 2*$delta - $tau;
$XB = $delta; $YB = $delta; $MB = 1 - 2*$delta - $tau;
$MX = $delta; $MY = $delta; $MM = 1 - 2*$delta - $tau;
$XX = $eta; $XY = 0; $XM = 1 - $eta - $tau;
$YY = $eta; $YX = 0; $YM = 1 - $eta - $tau;

$Bb[$x][$y] = 1; $Bb[$x][$y-1] = 0; $Bb[$x-1][$y] = 0;
$Mb[$x][$y] = 0; $Mb[$x][$y-1] = 0; $Mb[$x-1][$y] = 0;
$Xb[$x-1][$y] = $pgap * $XB * $Bb[$x][$y];
$Yb[$x][$y-1] = $pgap * $YB * $Bb[$x][$y];
$Xb[$x][$y] = 0; $Xb[$x][$y-1] =0;
$Yb[$x][$y] = 0; $Xb[$x-1][$y] =0;


$Mb[$x][$y] = 0;
for(my $i = $x-1; $i >= 0; $i--){ $Mb[$i][$y] = $b[$i][$y] = 0;}
for(my $j = $y-1; $j >= 0; $j--){ $Mb[$x][$j] = $b[$x][$j] = 0;}

$Xb[$x][$y] = 0;
$Xb[$x-1][$y] = $pgap * $BX * $Bb[$x][$y];
for(my $i = $x-2; $i >= 0; $i--){ $Xb[$i][$y]= $pgap * $XX * $Xb[$i+1][$j];}
for(my $j = $y-1; $j >= 0; $j--){ $Xb[$x][$j]= 0;}

$Yb[$x][$y] = 0;
$Yb[$x][$y-1] = $pgap * $BY * $Bb[$x][$y];
for(my $i = $x-1; $i >= 0; $i--){ $Yb[$i][$y]= 0;}
for(my $j = $y-2; $j >= 0; $j--){ $Yb[$x][$j]= $pgap * $YY * $Yb[$x][$j+1];}

###### Backward Recurrence ######
@b =();
$b[$x][$y] = 0;

print("Backward values:\n");

for(my $i= $x - 1; $i>=0; $i--)
{
    for(my $j= $y - 1; $j>=0; $j--)
     {
       $ch1 = substr($seq1, $j, 1);
       $ch2 = substr($seq2, $i, 1);
       $b[$x][$j] = $ch1;
       $b[$i][$y] = $ch2;
       if($ch1 eq $ch2) {$p = $pm;}
       else             {$p = $pmm;}

       $xb = $MM*$Mb[$i+1][$j+1]; $yb = $MX*$Xb[$i+1][$j+1];
       $zb = $MY*$Yb[$i+1][$j+1]; $wb = $MB*$Bb[$i+1][$j+1];
       #print "xb=$xb, pb=$pb, zb=$zb, wb=$wb\n";
       $Mb[$i][$j] = $p*$xb + $p*$yb + $p*$zb + $p*$wb;

       $xb = $XM * $Mb[$i+1][$j]; $yb = $XX * $Xb[$i+1][$j];
       $wb = $XB * $Bb[$i+1][$j];
       $Xb[$i][$j] = $pgap * $xb + $pgap * $yb + $pgap * $wb;        

       $xb = $YM * $Mb[$i][$j+1]; $yb = $YY * $Yb[$i][$j+1];
       $wb = $YB * $Bb[$i][$j+1];
       $Yb[$i][$j] = $pgap * $xb + $pgap * $yb + $pgap * $wb;

       $b[$i][$j] = $Mb[$i][$j] + $Xb[$i][$j] + $Yb[$i][$j];

       
       print("i=$i j=$j M[$i][$j]=$Mb[$i][$j] X[$i][$j]=$Xb[$i][$j] Y[$i][$j]=$Yb[$i][$j]\n");

    }
}



###### Posterior Probability  ########
@p = ();
for(my $i=1; $i<=length($seq2); $i++)
   {
     for(my $j=1; $j<=length($seq1); $j++)
      {
        $p[$i][$j] = $f[$i][$j] * $b[$i-1][$j-1] / $f[$x][$y];
      }
}

print "\n";
print "Matrix f is \n";
for(my $i=0; $i<=length($seq2); $i++)
   {
     for(my $j=0; $j<=length($seq1); $j++)
      {
        print($f[$i][$j]." ");
      }
    print("\n");
   }
 print("\n");


print "Matrix b is \n";
for(my $i=0; $i<=length($seq2); $i++)
   {
     for(my $j=0; $j<=length($seq1); $j++)
      {
        print($b[$i][$j]." ");
      }
    print("\n");
   }
 print("\n");


print "Matrix p is \n";
for(my $i=0; $i<=length($seq2); $i++)
   {
     for(my $j=0; $j<=length($seq1); $j++)
      {
        print($p[$i][$j]." ");
      }
    print("\n");
   }
 print("\n");
