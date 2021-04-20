#!/bin/bash

# Copyright  2019 Rakuten Institute of Technology (Author: Federico Ang)
# Apache 2.0

# Currently considered corpora of Filipino speech
# FSC
# ISIP
# KIT-CMU

# To be run from one directory above this script.

## This script expects that you have the corresponding post-edited transcriptions and wav lists
## corresponding to the databases considered

. ./path.sh
set -e # exit on error

#check existing directories
if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo "Usage: fph_data_prep.sh <fsc-data dir> [<mode_number>]"
  echo " mode_number can be 0, 1, 2, 3, (0=default using only FSC, 1=add ISIP,"
  echo "                                 2=add KIT, 3=use all data simultaneously)"
  exit 1;
fi

FSC=$1
ISIP=$(echo $FSC | sed 's/FSC/ISIP_TGL/g')
KIT=$(echo $FSC | sed 's/FSC/KIT_TGL/g')
mode=0

#if [ $# -eq 2 ]; then
#  mode=$2
#fi


dir=data/local/train
rm -fr $dir
mkdir -p $dir

# Audio data directory check
if [ ! -d $FSC ]; then
 echo "Error: run.sh requires a directory argument"
  exit 1;
fi

export LC_ALL=C;
# FSC dictionary file check
if [ ! -f $dir/lexicon.txt ]; then
  cat $FSC/lexicon/lexicon.txt /storage07/user_data/angfederico01/local/g2p-seq2seq_OLD/KIT_dict.norm | sed 's/([^)])//g;' | sed '/^(/d' | sed '/^)/d' | sort --parallel=8 | uniq >$dir/lexicon.txt || exit 1;
fi

### Config of using wav data that relates with acoustic model training ###
#if [ $mode -eq 3 ]
#then
cat $FSC/*/*/*-wav.list 2>/dev/null | sed '/^$/d' | sed '/speech/d' | sed 's/AS/C/g; s/PB/O/g; s/PBAS/O/g; s/ /\\ /g' > $dir/wav.flist # Using All data

sed -e 's?.*/??' -e 's?.wav??' $dir/wav.flist | paste - $dir/wav.flist > $dir/wavflist.scp
#elif [ $mode -eq 2 ]
#then
#  cat $CSJ/*/{A*,M*,R*,S*}/*-wav.list 2>/dev/null | sort > $dir/wav.flist # Using All data except for "dialog" data
cat $KIT/*/*/*-wav.list 2>/dev/null | sed '/^$/d' | sort --parallel=8 | uniq > $dir/wav.flist2 # Using All data
cat $dir/wav.flist2 >> $dir/wav.flist
#elif [ $mode -eq 1 ]
#then 
#  cat $CSJ/*/A*/*-wav.list 2>/dev/null | sort > $dir/wav.flist # Using "Academic lecture" data
#else
  # cat $CSJ/*/{A*,M*}/*-wav.list 2>/dev/null | sort > $dir/wav.flist # Using "Academic lecture" and "other" data
#  cat $CSJ/*/{A,M}*/*-wav.list 2>/dev/null | sort > $dir/wav.flist # Using "Academic lecture" and "other" data
#fi

# sort
sort --parallel=8 $dir/wav.flist > $dir/wav.flist_SORTED
mv $dir/wav.flist_SORTED $dir/wav.flist

n=`cat $dir/wav.flist | wc -l`

[ $n -ne 35604 ] && \
  echo "Warning: expected 35604 data files, found $n."

# (1a) Transcriptions preparation
# make basic transcription file (add segments info)

##e.g A01F0055_0172 00380.213 00385.951 => A01F0055_0380213_0385951
## for CSJ
#awk '{
#      spkutt_id=$1;
#      split(spkutt_id,T,"[_ ]");
#      name=T[1]; stime=$2; etime=$3;
#      printf("%s_%07.0f_%07.0f",name, int(1000*stime), int(1000*etime));
#      for(i=4;i<=NF;i++) printf(" %s", tolower($i)); printf "\n"
#}' $CSJ/*/*/*-trans.text |sort > $dir/transcripts1.txt # This data is for training language models
# Except evaluation set (30 speakers)

# test if trans. file is sorted
#export LC_ALL=C;
#sort -c $dir/transcripts1.txt || exit 1; # check it's sorted.

# Remove Option.
# **NOTE: modified the pattern matches to make them case insensitive
#cat $dir/transcripts1.txt \
#  | perl -ane 's:\<s\>::gi;
#               s:\<\/s\>::gi;
#               print;' \
#  | awk '{if(NF > 1) { print; } } ' |sort > $dir/text

# FSC corrections based on last db status
cat $FSC/*/*/*-trn.txt | sed '/10_xx00xxxx_12A/d' | sed '/40_xx10xxxx_15A/d' | sed '/01_xx01xxxx_14A/d' | sed 's/{[^}]*}//g; s/([^)]*)//g; s/([^}]*}//g' | sed '/fsc/d' | sed '/)/d' |\
sed '/noise/d; /non-speech/d; /nonfs/d; /nonsfc/d; /nsfc/d' |\
sed 's/-&gt.*//g; s/[!",`|~:;?\[*]/ /g; s/]/ /g; s/\.\.\.\.\?/ /g; s/\.\.[a-z][ ]\?$//g; s/\([a-z][a-z]\)\. /\1 .. /g; s/\.\./ <sp> /g; s/ [ ]*/ /g; s/[ ]\+$//g; s/\.$//g' |\
awk '{if ((! match($1,/speech/)) && ($4 !~ /^$/) && ($4 !~ /^<sp>$/)) {printf "%s ",$1; for (i=4; i<=NF; i++) printf " %s",$i; printf "\n"}}' | sed 's/AS/C/g; s/PB/O/g;' > $dir/text


# KIT transcriptions
awk -F'\t' '{printf "%s  %s\n",$1,$4}' $KIT/*/*/*-trn.txt >> $dir/text

sort --parallel=8 $dir/text > $dir/text_SORTED
mv $dir/text_SORTED $dir/text
sort -c $dir/text || exit 1;

# (1c) Make segments files from transcript
#segments file format is: utt-id start-time end-time, e.g.:
#A01F0055_0380213_0385951 => A01F0055_0380213_0385951 A01F0055 00380.213 00385.951
#awk '{
#       segment=$1;
#       split(segment,S,"[_]");
#       spkid=S[1]; startf=S[2]; endf=S[3];
#       print segment " " spkid " " startf/1000 " " endf/1000
#   }' < $dir/text > $dir/segments
awk '{
	if ((! match($1,/speech/)) && ($3 > $2)) {
	  segment=$1
	  split(segment,S,"[_]");
	  spkid=S[1]"_"S[2]"_"S[3];
	  print segment " " spkid " " $2 " " $3
	}
}' <(cat $FSC/*/*/*-trn.txt | sed 's/AS/C/g; s/PB/O/g;') | sort --parallel=8 > $dir/segments

#awk '{segment=$1; split(segment,S,"[_]"); spkid=S[1]; print $1 " " spkid}' $dir/segments > $dir/utt2spk || exit 1;
awk '{segment=$1; split(segment,S,"[_]"); spkid=S[1]"_"S[2]"_"S[3]; print $1 " " spkid}' $dir/segments | sort --parallel=8 -k2 > $dir/utt2spk || exit 1;

awk '{
          segment=$1
          split(segment,S,"[.]");
          spkid=S[1]"."S[2];
          print segment " " spkid " " $2 " " $3
}' <(cat $KIT/*/*/*-trn.txt) >> $dir/segments

sort --parallel=8 $dir/segments > $dir/segments_SORTED
mv $dir/segments_SORTED $dir/segments
sort -c $dir/segments || exit 1;

awk '{segment=$1; split(segment,S,"[.]"); spkid=S[1]"."S[2]; print $1 " " spkid}' <(cat $KIT/*/*/*-trn.txt) >> $dir/utt2spk || exit 1;
sort --parallel=8 -k2 $dir/utt2spk > $dir/utt2spk_SORTED
mv $dir/utt2spk_SORTED $dir/utt2spk

sed -e 's?.*/\([^/]*\)/\([^/]*$\)?\1.\2?' -e 's?.wav??' $dir/wav.flist2 | paste - $dir/wav.flist2 \
  >> $dir/wavflist.scp

awk '{
 printf("%s cat ", $1);
 for (i=2;i<=NF;i++) {
    printf("%s ",$i)
 }
 printf("|\n")
}' < $dir/wavflist.scp | sort > $dir/wav.scp || exit 1;



sort -k 2 $dir/utt2spk | utils/utt2spk_to_spk2utt.pl > $dir/spk2utt || exit 1;

# Copy stuff into its final locations [this has been moved from the format_data script]
rm -fr data/train
mkdir -p data/train
for f in spk2utt utt2spk wav.scp text segments; do
  cp data/local/train/$f data/train/ || exit 1;
done

echo "FSC data preparation succeeded."

utils/fix_data_dir.sh data/train
