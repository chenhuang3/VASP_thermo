#!/usr/bin/perl 
use File::Basename; 
use Getopt::Long; 
use Tie::File; 
#$squeue = `squeue &> outcar`; 
#@squeue = `showq -u adearden &> outcar`; 
#$outcar = queue_file;
$outcar = OUTCAR; 
open (INFILE, "<$outcar") or die "Could not open the OUTCAR file.\n"; 
tie my @infile, "Tie::File", "$outcar"; 
$modes=0; 
LINE: while($Line = <INFILE>){ 
	if ($Line=~/f  = /){ 
		chomp $Line; 
		@parsedline= split " ", $Line; 
		$freq[$modes]=$parsedline[7]; 
		$mev[$modes]=$parsedline[9]; 
		$modes++; 
#print $Line,"\n"; 
#print "frequency in cm^-1: ",$freq,"\n"; 
#print "energy in meV: ",$mev,"\n"; 
#print "number of modes: ",$modes,"\n"; 
	} 
#	if ($Line=~/ eligible job/){ 
#		chomp $Line; 
#		@parsedline= split " ", $Line; 
#		$numeligible=$parsedline[0]; 
#	} 
#        if ($Line=~/ blocked job/){
#                chomp $Line;
#                @parsedline= split " ", $Line;
#                $numblocked=$parsedline[0];
#        }
#	if ($Line=~/ active job/){ 
#		chomp $Line; 
#		@parsedline= split " ", $Line; 
#		$numactive=$parsedline[0]; 
#	} 
}
#print "Total number of jobs: ", $numjobs,"\n"; 
#print "Active jobs: ", $numactive,"\n"; 
#print "Eligible jobs: ", $numeligible,"\n"; 
#print "Blocked jobs: ", $numblocked,"\n"; 
close(INFILE); 
$mevsum=0.0; 
$Svib=0.0; 
$Evsum=0.0; 
$JtoeV=6.24150934E18; 
$kcaltoeV=0.043; 
$light=2.99792458E8;
$planck=6.62606957E-34;
$gasconst=5.189E19;
$boltzmann=8.6173324E-5;
$avogadro=6.02214129E23;
$temp=500.0; 
for($num=0;$num<$modes;$num++){ 
	$mevsum=$mevsum+$mev[$num]; 
#} 

#for($num=$modes-1;$num>($modes-3);$num--){ 
#	print "Mode ",$num+1,"\n"; 
#	print "frequency: ",$freq[$num],"\n"; 
#	print "energy: ",$mev[$num],"\n"; 

#	$mevsum=$mevsum+$mev[$num]; 
#print $num,"\n"; 
#print $mev[$num],"\n"; 


#units will be in J, kg, etc. for the actual calculations 
	$theta=($freq[$num]*100*$planck*$light*$JtoeV)/($boltzmann*$temp);
	$Svib=$Svib+($gasconst/$avogadro)*($theta*(1/(exp($theta)-1))-log(1-exp(($theta*-1))));
	$Evsum=$Evsum+($gasconst/$avogadro)*($theta*$temp)*((1/2)+1/(exp($theta)-1)); 
	

} 

$frequencies=frequencies;
open (FREQS, ">$frequencies") or die "Could not open the frequencies file.\n";
for($freqs=0;$freqs<$modes;$freqs++){ 
	if ($freqs<$modes-1){ 
		print FREQS $freq[$freqs],",";
	}
	if ($freqs==$modes-1){ 
		print FREQS $freq[$freqs]; 
	} 
}
close(FREQS); 


	$zpe=(1/2)*$mevsum/1000; 
	print "Values at ",$temp,"K:\n"; 
	print "ZPE (eV): ",$zpe,"\n"; 
	print "Svib (eV/K): ",$Svib,"\n"; 
	print "ST (eV):    ",$Svib*$temp,"\n"; 
	print "Ev (eV):    ",$Evsum,"\n"; 
	print "Ev-ST (eV): ",$Evsum-$Svib*$temp,"\n"; 




