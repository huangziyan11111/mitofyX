#!/usr/bin/perl

use CGI qw( :standard );
use File::Path qw(make_path remove_tree);

use strict;
use warnings;

###############################################MAIN#################################################
#This CGI script is called when trna annotations are submitted via the Sequin annotation window
####################################################################################################
my $cis_start;
my $cis_end;
my @exons;
my $ex1_start;
my $ex2_start;
my $ex1_end;
my $ex2_end;

#get passed CGI parameters
my $gene        = param('gene');
my $taxon       = param('taxon');
my $project     = param('project');
my $feature_key = param('feature_key');
my $product     = param('product');
my $notes       = param('notes');
my $pseudo      = param('pseudo');
my $type        = param('type');

my $sequin_outfile = $project . ".tbl";
my $outfile_path   = "annotated/$project/"; #DIRECTORY
if (! -d $outfile_path){
  make_path($outfile_path);

}


my $cis_coords = param( 'gene_coords' );
( $cis_start, $cis_end ) = split( /\D+/, $cis_coords );

my $exon1 = param( 'ex1' );
if( $exon1 ){
  push( @exons, $exon1 );
  if( $exon1 =~ /(\d+)\D+(\d+)/ ){
    $ex1_start = $1;
    $ex1_end = $2;
  }
}

my $exon2 = param( 'ex2' );
if( $exon2 ){
  push( @exons, $exon2 );
  if( $exon2 =~ /(\d+)\D+(\d+)/ ){
    $ex2_start = $1;
    $ex2_end	= $2;
  }
}

if( -e "$outfile_path$sequin_outfile" ){
  print_SEQUIN( $cis_start, $cis_end, \@exons, $exon1, $exon2, $ex1_start, $ex2_start, $ex1_end, $ex2_end, $gene, $taxon, $sequin_outfile, $outfile_path, $cis_coords, $feature_key, $product, $notes, $pseudo, $type );
}else{
  open( SEQUIN, ">$outfile_path$sequin_outfile" );
  print SEQUIN ">Feature $taxon\n";
  close SEQUIN;
  print_SEQUIN( $cis_start, $cis_end, \@exons, $exon1, $exon2, $ex1_start, $ex2_start, $ex1_end, $ex2_end, $gene, $taxon, $sequin_outfile, $outfile_path, $cis_coords, $feature_key, $product, $notes, $pseudo, $type );
}

#-NEW LINES----------
print "Content-type: text/html\n\n";
print "<HTML><BODY onload=\"window.close()\"></BODY</HTML>\n";
#--------------------


exit;

#############################################SUBROUTINES############################################
sub print_SEQUIN{
  my( $cis_start, $cis_end, $exons_ref, $exon1, $exon2, $ex1_start, $ex2_start, $ex1_end, $ex2_end, $gene, $taxon, $sequin_outfile, $outfile_path, $cis_coords, $feature_key, $product, $notes, $pseudo, $type ) = @_;
  
  open( SEQUIN, ">>$outfile_path$sequin_outfile" );
  
  #print misc_features
  if( $feature_key eq "misc_feature" ){
    print SEQUIN "$cis_start\t$cis_end\t$feature_key\n";

    
    if( $gene ){
      $gene =~ /bacterial/ and $gene = "trnC";
      $gene =~ /mt/ and $gene = "trnC";
      $gene and print SEQUIN "\t\t\tgene\t$gene\n";
    }
    
    if( $pseudo eq "yes" ){
      print SEQUIN "\t\t\tpseudo\n";
    }

    if( $type ){
      $type eq "mito" and print SEQUIN "\t\t\tnote\tmitochondrial-type; see PubMed 21699590\n";
      $type eq "bacterial" and print SEQUIN "\t\t\tnote\tbacterial-type; see PubMed 21699590\n";
      $type eq "cplast" and print SEQUIN "\t\t\tnote\tchloroplast-type; see PubMed 21699590\n";
    }

    $notes and print SEQUIN "\t\t\tnote\t$notes\n";
    
  #print introns
  }elsif( $feature_key eq "intron" ){
  
    if( $gene ){
      $gene =~ /bacterial/ and $gene = "trnC";
      $gene =~ /mt/ and $gene = "trnC";
    }
    
    print SEQUIN "$cis_start\t$cis_end\t$feature_key\n";
    print SEQUIN "\t\t\tgene\t$gene\n";
    if( $pseudo eq "yes" ){
      print SEQUIN "\t\t\tpseudo\n";
    }

    $notes and print SEQUIN "\t\t\tnote\t$notes\n";
    
    #else print gene
  }else{

    if( $gene ){
      $gene =~ /bacterial/ and $gene = "trnC";
      $gene =~ /mt/ and $gene = "trnC";
    }

    print SEQUIN "$cis_start\t$cis_end\tgene\n";
    print SEQUIN "\t\t\tgene\t$gene\n";
  
    if( $pseudo eq "yes" ){
      print SEQUIN "\t\t\tpseudo\n";
    }
    
    $notes and print SEQUIN "\t\t\tnote\t$notes\n";

    if( $type ){
      $type eq "mito" and print SEQUIN "\t\t\tnote\tmitochondrial-type; see PubMed 21699590\n";
      $type eq "bacterial" and print SEQUIN "\t\t\tnote\tbacterial-type; see PubMed 21699590\n";
      $type eq "cplast" and print SEQUIN "\t\t\tnote\tchloroplast-type; see PubMed 21699590\n";
    }
  }
  
  if( @{$exons_ref} == 2 ){
    print SEQUIN "$ex1_start\t$ex1_end\ttRNA\n";
    print SEQUIN "$ex2_start\t$ex2_end\n";
    print SEQUIN "\t\t\tgene\t$gene\n";
    print SEQUIN "\t\t\tproduct\t$product\n";
  }else{
    if( ($pseudo ne "yes") && ($feature_key ne "misc_feature") && ($feature_key ne "intron") ){
      print SEQUIN "$cis_start\t$cis_end\ttRNA\n";
      print SEQUIN "\t\t\tgene\t$gene\n";
      print SEQUIN "\t\t\tproduct\t$product\n";
    }
  }
  
  close SEQUIN;
}
####################################################################################################
#this subroutine determines whether a sequence is on the + or - strand
sub strand{
  my( $start, $end ) = @_;
  my $strand;
  my $tmp;
  
  if( $start < $end ){
    $strand = "+";
  }else{
    $tmp = $end;
    $end = $start;
    $start = $tmp;
    $strand = "-";
  }
  
  return( $start, $end, $strand );
  
}
####################################################################################################

