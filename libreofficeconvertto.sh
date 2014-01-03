#!/bin/sh

#    Copyright 2013-2014 Hariharan Raju

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

echo Hello `whoami`!

# file ext settings
seaf=seaf
html=html

# vcf files directory
HTMLDIR=~/DIR/TRANSCRIPTION
PDFDIR=~/DIR/PDF
ODTDIR=~/DIR/ODT
DOCDIR=~/DIR/DOC

echo Renaming .html files to .seaf
cd $HTMLDIR
for file in *.$html; # do ./loopcycle; done
do
 # rename all .html files to .seaf
# get full path for selected .html -> SEAF
SEAF=${HTMLDIR}$file
# get basename of html files -> seafname
filename="${SEAF##*/}"
seafname=${filename%%_*}
# rename file
mv $seafname.html $seafname.seaf
done


echo Converting .seaf files to .PDF
cd $HTMLDIR
for file in *.$seaf; # do ./loopcycle; done
do
 # convert all .seaf files to .PDF
soffice --headless --convert-to pdf:"writer_web_pdf_Export" --outdir $PDFDIR $file
done


echo Converting .seaf files to .ODT
cd $HTMLDIR
for file in *.$seaf; # do ./loopcycle; done
do
 # convert all .seaf files to .ODT
soffice --headless --convert-to odt:"OpenDocument Text Flat XML" --outdir $ODTDIR $file
done


echo Converting .seaf files to .DOC
cd $HTMLDIR
for file in *.$seaf; # do ./loopcycle; done
do
 # convert all .seaf files to .DOC
soffice --headless --convert-to doc:"MS Word 97" --outdir $DOCDIR $file
done


echo Conversion completed
