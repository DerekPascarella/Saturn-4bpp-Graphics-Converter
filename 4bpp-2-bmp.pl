#!/usr/bin/perl
#
# 4bpp-2-bmp.pl
# Convert SEGA Saturn 4bpp graphic format to bitmap using an external palette.
#
# Version 1.0
#
# Written by Derek Pascarella (ateam)

use strict;

# Store input parameters.
my $input_file = $ARGV[0];
my $palette_file = $ARGV[1];
my $palette_index = $ARGV[2];
my $width = $ARGV[3];
my $height = $ARGV[4];

# Store version number.
my $version_number = "1.0";

# Store usage text.
my $usage_header = "4bpp-2-bmp v$version_number\nConvert SEGA Saturn 4bpp graphic format to bitmap using an external palette.\n\nWritten by Derek Pascarella (ateam)";
my $usage_deatils = "Usage:\n4bpp-2-bmp <4BPP_FILE> <PALETTE_FILE> <PALETTE_INDEX> <WIDTH> <HEIGHT>";

# Ensure proper input parameters.
if($input_file eq "" || $palette_file eq "" || $width eq "" || $height eq "" || $palette_index eq "")
{
	die "\n$usage_header\n\nOne or more input parameters missing...\n\n$usage_deatils\n\n";
}
elsif(!-e $input_file || !-R $input_file || !-e $palette_file || !-R $palette_file)
{
	die "\n$usage_header\n\nCould not find or read $input_file or $palette_file...\n\n$usage_deatils\n\n";
}
elsif($width eq "" || $height eq "" || $palette_index eq "" || $width !~ /^[+-]?\d+$/ || $height !~ /^[+-]?\d+$/ || $palette_index !~ /^[+-]?\d+$/)
{
	die "\n$usage_header\n\nWidth, height, and palette index parameters must be whole numbers...\n\n$usage_deatils\n\n";
}

# Construct output filename.
my $output_file = $input_file . ".BMP";

# Status message.
print "\n4bpp-2-bmp v$version_number\n";
print "Convert SEGA Saturn 4bpp graphic format to bitmap using an external palette.\n\n";
print "Written by Derek Pascarella (ateam)\n\n";
print "Converting $input_file to $output_file using palette index $palette_index...\n\n";

# Parse the RIFF palette file.
open(my $palette_in, '<:raw', $palette_file) or die "Error: Can't open palette file $palette_file: $!\n\n";
read($palette_in, my $header, 24) == 24 or die "Error: Palette file is too short or invalid.\n\n";

# Calculate the offset for the selected palette (16 colors × 4 bytes each).
my $palette_size = 16 * 4;
my $palette_offset = 24 + ($palette_index * $palette_size);
seek($palette_in, $palette_offset, 0) or die "Error: Failed to seek to palette index $palette_index.\n\n";

# Read the selected palette.
my @palette;

for my $i (0 .. 15)
{
	read($palette_in, my $entry, 4) == 4 or die "Error: Palette file does not contain enough color entries for index $palette_index.\n\n";
	
	my ($r, $g, $b, $reserved) = unpack("C4", $entry);
	
	# Ignore the reserved byte.
	push @palette, [$r, $g, $b];
}

close($palette_in);

# Status message.
print "Loaded palette index $palette_index...\n";

for my $i (0 .. $#palette)
{
	my ($r, $g, $b) = @{$palette[$i]};

	printf(" - Color %2d: R=%3d G=%3d B=%3d\n", $i, $r, $g, $b);
}

# Open input and output files.
open(my $in, '<:raw', $input_file) or die "Error: Can't open $input_file: $!";
open(my $out, '>:raw', $output_file) or die "Error: Can't open $output_file: $!";

# Construct BMP and DIB headers for a 24-bit bitmap.
my $file_header = "BM" . pack("V", 14 + 40 + $width * $height * 3) . pack("V", 0) . pack("V", 14 + 40);
my $dib_header = pack("V", 40) . pack("V", $width) . pack("V", -$height) . pack("v", 1) .
				 pack("v", 24) . pack("V", 0) . pack("V", $width * $height * 3) .
				 pack("V", 0) . pack("V", 0) . pack("V", 0). pack("V", 0);

# Write headers to file.
print $out $file_header;
print $out $dib_header;

# Convert pixel data.
for my $y (1 .. $height)
{
	# Each byte equals two pixels.
	for my $x (1 .. ($width / 2))
	{
		my $byte;
		read($in, $byte, 1) or die "Error: Unexpected end of file while reading pixel data.\n\n";
		
		my ($pixel1, $pixel2) = (ord($byte) >> 4, ord($byte) & 0x0F);
		
		for my $pixel ($pixel1, $pixel2)
		{
			# Retrieve RGB values from the palette.
			my ($r, $g, $b) = @{$palette[$pixel]};
			
			# Pack RGB data and write it to file.
			print $out pack("C3", $b, $g, $r);
		}
	}
}

# Close files.
close($in);
close($out);

# Status message.
print "\nComplete!\n\n";