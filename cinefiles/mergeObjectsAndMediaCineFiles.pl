use strict;

my %count ;
my $delim = "\t";

open MEDIA,$ARGV[0] or die "couldn't open media file $ARGV[0]";
my %media ;
while (<MEDIA>) {
  $count{'media'}++;
  chomp;
  s/\r//g;
  my ($objectcsid, $objectnumber, $mediacsid, $description, $filename, $creatorrefname, $creator, $blobcsid, $copyrightstatement, $identificationnumber, $rightsholderrefname, $rightsholder, $contributor, $mimetype, $md5) = split /$delim/;
  # my ($objectcsid, $objectnumber, $mediacsid, $description, $filename, $creatorrefname, $creator, $blobcsid, $copyrightstatement, $identificationnumber, $rightsholderrefname, $rightsholder, $contributor, $approvedforweb, $imageType,$mimetype,$md5) = split /$delim/;
  my $type = $mimetype eq 'application/pdf' ? 'pdf' : 'image';
  $media{$objectcsid}{$type} .= $blobcsid . ',';
  #print "$objectcsid $type $blobcsid \n";
}

open LINK,$ARGV[1] or die "couldn't open link file $ARGV[1]";
my %link ;
while (<LINK>) {
  $count{'link'}++;
  chomp;
  s/\r//g;
  my ($filmid, $docid) = split /$delim/;
  $link{$docid} = $filmid;
}

open LINK2,$ARGV[2] or die "couldn't open link2 file $ARGV[2]";
my %link2 ;
while (<LINK2>) {
  $count{'link2'}++;
  chomp;
  s/\r//g;
  my ($csid, $docid) = split /$delim/;
  $link2{$docid} = $csid;
}

open FILMS,$ARGV[3] or die "couldn't open films file $ARGV[4]";
my %films ;
while (<FILMS>) {
  $count{'films'}++;
  chomp;
  s/\r//g;
  my ($filmid, @rest) = split /$delim/;
  $films{$filmid} = join($delim, @rest);
  #print join($delim, @rest) . "\n"
}

open METADATA,$ARGV[4] or die "couldn't open docs file $ARGV[4]";
$media{'csid'}{'image'} = 'blob_ss';
$media{'csid'}{'pdf'} = 'pdf_ss';
$link2{'doc_id'} = 'csid';

while (<METADATA>) {
  $count{'metadata'}++;
  chomp;
  s/\r//g;
  my ($docid, @rest) = split /$delim/;
  # insert list of blobs as final column
  my $objectcsid = $link2{$docid};
  my $mediablobs = $media{$objectcsid}{'image'};
  my $pdfblobs = $media{$objectcsid}{'pdf'};
  my $filmid = $link{$docid};
  my $film_info;
  if ($filmid) {
    $count{'film matched'}++;
    $film_info = $films{$filmid};
  }
  else {
    $count{'film unmatched'}++;
    $film_info = "$delim" x 12;
  }
  #print ">>> d $docid f $filmid o $objectcsid m $mediablobs \n";
  if ($mediablobs) {
    $count{'media matched'}++;
  }
  else {
    $count{'media unmatched'}++;
  }
  $mediablobs =~ s/,+$//; # get rid of trailing comma
  $pdfblobs =~ s/,+$//; # get rid of trailing comma
  print $_ . $delim . $filmid . $delim . $film_info . $delim . $objectcsid . $delim .  $mediablobs . $delim .$pdfblobs . "\n";
}

foreach my $s (sort keys %count) {
 warn $s . ": " . $count{$s} . "\n";
}
