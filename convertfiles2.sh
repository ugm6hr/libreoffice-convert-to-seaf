#!/bin/bash

#    Copyright 2014 Hariharan Raju

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

#get working directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

# transcription files directory - THIS FILE NEEDS TO LOCATED IN THE CLIENT DATA DIRECTORY
ROOTDIR=./

#subdirectories (standard for all - make directories)
SEAFSDIR=TRANSCRIPTION/
PDFSDIR=PDF/
ODTSDIR=ODT/
DOCSDIR=DOC/
PRINTSDIR=PRINT/
PRINT=PRINT

#directory full link
SEAFDIR=$ROOTDIR$SEAFSDIR
PDFDIR=$ROOTDIR$PDFSDIR
ODTDIR=$ROOTDIR$ODTSDIR
DOCDIR=$ROOTDIR$DOCSDIR
PRINTDIR=$ROOTDIR$PRINTSDIR

#date/timestamp
DATESTAMP=`/bin/date +_%s_%D | tr "/" "-"`

# file endings (standard for all)
html=html
seaf=seaf
pdf=pdf
odt=odt

# create directories if don't already exist
mkdir $SEAFDIR
mkdir $PDFDIR
mkdir $ODTDIR
mkdir $DOCDIR
mkdir $PRINTDIR

cd $SEAFDIR

echo Renaming .html files to .seaf
for file in *.$html; # do ./loopcycle; done
do
 # rename all .html files to .seaf
# get full path for selected .html -> SEAF
SEAF=${SEAFDIR}$file
# get basename of html files -> seafname
filename="${SEAF##*/}"
seafname=${filename%%.*}
echo Renaming $seafname.html to $seafname.seaf
# rename file
mv $seafname.html $seafname.seaf
done


echo Converting .seaf files to .ODT
for file in *.$seaf; # do ./loopcycle; done
do
echo Converting $seaf to ODT in $ODTDIR
 # convert all .seaf files to .ODT
soffice --headless --convert-to odt:"OpenDocument Text Flat XML" --outdir $ODTDIR $file
done

# move directory to ROOTDIR
rsync -av $ODTDIR ../$ODTSDIR
rm -r $ODTDIR


#move to ODTDIR
cd ../
cd $ODTDIR


echo Converting .odt files to .DOC
for file in *.$odt; # do ./loopcycle; done
do
echo Converting $odt to DOC in $DOCDIR
 # convert all .seaf files to .DOC
soffice --headless --convert-to doc:"MS Word 97" --outdir $DOCDIR $file
done

# move directory to ROOTDIR
rsync -av $DOCDIR ../$DOCSDIR
rm -r $DOCDIR

echo Converting .odt files to .PDF
for file in *.$odt; # do ./loopcycle; done
do
echo Converting $odt to PDF in $PDFDIR
 # convert all .seaf files to .PDF
soffice --headless --convert-to "PDF" --outdir $PDFDIR $file
done

echo Creating single daily PDF called PRINT$DATESTAMP.pdf
cd $PDFDIR
pdftk * cat output PRINT$DATESTAMP.pdf
mv PRINT$DATESTAMP.pdf ../
cd ../

# move directory to ROOTDIR
rsync -av $PDFDIR ../$PDFSDIR
rm -r $PDFDIR

# move PRINT PDF to PRINTDIR
mv PRINT$DATESTAMP.pdf ../$PRINTSDIR

echo Conversion completed

