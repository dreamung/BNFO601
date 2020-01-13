$true_file = shift; open(IN, $true_file); 
@data = <IN>; chomp(@data);
$t_seq1 = $data[1];
$t_seq2 = $data[3];

open(IN, shift);@data = <IN>;
$c_seq1 = $data[1];
$c_seq2 = $data[3];

%t_hash = (); 
$pos1 = 1;$pos2 = 1; 

for($i=0; $i < length($t_seq1); $i++){
    $ch1 = substr($t_seq1,  $i, 1); 
    $ch2 = substr($t_seq2,  $i, 1);
    if( $ch1 ne "-" && $ch2 ne "-" &&$ch1=~ /[A-Z]/ && $ch2=~/[A-Z]/)
    {
               $t_hash{$pos1} = $pos2; 
    }
    if( substr($t_seq1, $i, 1) ne "-") 
    {
            $pos1++; 
    }
    if( substr($t_seq2, $i, 1) ne "-") 
    {
            $pos2++;
    }
} 

@k = keys(%t_hash); #return keys 
$den =scalar(@k); #length of list
$pos1 = 1; $pos2 = 1; 

for($i=0; $i < length($c_seq1);$i++) { 
        if( substr($c_seq1, $i, 1) ne"-" && substr($c_seq2, $i, 1)ne "-") 
{
                       if( $t_hash{$pos1} == $pos2 ){ $num++; } 
        }
        if( substr($c_seq1, $i, 1) ne "-") {
                   $pos1++; 
        }
        if( substr($c_seq2, $i, 1) ne "-") { 
                   $pos2++;  
        }
}
$accuracy = ($num / $den);

print("$accuracy");
