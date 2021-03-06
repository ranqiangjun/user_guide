# This script builds the AsciiDoc Display Direct module output for the
# guidelines and user guide.

# Exit immediately on uninitialized variable or error, and print each command.
set -uex

# Make the output directories if they do not exist.
mkdir -p ../output
mkdir -p ../output/html


# Process each language. Add new languages to the languages.txt file.
for lang in `cat languages.txt`
do

  mkdir -p ../output/html/$lang
  mkdir -p ../output/html/$lang/images

  # Run the preprocessor that puts file names into the files under each header.
  php addnames._php ../source/$lang ../output/html/$lang
  cp ../source/$lang/guide-docinfo.xml ../output/html/$lang

  # Run the AsciiDoc processor to convert to DocBook format. Syntax:
  #  asciidoc -d book -b docbook -f [config file] -o [output file] [input file]
  asciidoc -d book -b docbook -f std.conf -a docinfo -o ../output/html/$lang/guide.docbook ../output/html/$lang/guide.txt


  # Run the xmlto processor to convert from DocBook to bare XHTML, using a
  # custom style sheet that makes output for the AsciiDoc Display Direct
  # module. Syntax:
  #   xmlto -m bare.xsl xhtml -o [output dir] [input docbook file]
  xmlto -m bare.xsl xhtml -o ../output/html/$lang ../output/html/$lang/guide.docbook

  # Copy image files to output directory.
  cp ../source/$lang/images/*.png ../output/html/$lang/images

done


# Now process the Guidelines book. It has a few differences from the
# User Guide language books. See comments above in the languages section.

mkdir -p ../output/html/guidelines
mkdir -p ../output/html/guidelines/images

php addnames._php ../guidelines ../output/html/guidelines

asciidoc -d book -b docbook -f std.conf -f guidelines.conf -o ../output/html/guidelines/guidelines.docbook ../output/html/guidelines/guidelines.txt

xmlto -m bare.xsl xhtml --stringparam section.autolabel.max.depth=2 -o ../output/html/guidelines ../output/html/guidelines/guidelines.docbook

cp ../guidelines/images/*.png ../output/html/guidelines/images
