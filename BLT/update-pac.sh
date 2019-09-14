#!/bin/bash
echo "Cleaning up & Fetching PAC lists..."
mkdir -p ~/BLT/pac
cd ~/BLT/pac
rm -f pac-*
rm -f *.pac
sleep 2
echo "Changed working directory to "$file_dir" and cleaned up old data. Now downloading new lists."
wget -nv -O 1.pac "https://ssl.bblck.me/blacklists/domain-list.txt"
wget -nv -O 2.pac "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
wget -nv -O 3.pac "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
wget -nv -O 4.pac "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"
wget -nv -O 5.pac "https://dshield.org/feeds/suspiciousdomains_Medium.txt"
wget -nv -O 6.pac "https://dshield.org/feeds/suspiciousdomains_High.txt"
wget -nv -O 7.pac "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext"
echo "Lists Downloaded."
cat *.pac > pac-comb.txt
sed -i "s/#.*$//" pac-comb.txt
sed -i "/^$/d" pac-comb.txt
sort pac-comb.txt > pac-sort.txt
uniq -i pac-sort.txt > pac-uniq.txt
cp pac-uniq.txt pac-pre.txt
cp pac-pre.txt pac-pre2.txt
sed -i "s/^/*./" pac-pre.txt
cat pac-pre.txt pac-pre2.txt > pac-wew.txt
perl -i -pe 'chomp if eof' pac-wew.txt
sed "s/^/shExpMatch(host, '/" pac-wew.txt > pac-lad.txt
sed -i "s/$/') ||/" pac-lad.txt
sed "2r pac-lad.txt" < ~/BLT/parsing/pactemplate.txt > pac-done.txt
mv pac-done.txt pac-done.js
perl -i -pe 'chomp if eof' pac-done.js
echo "Properly merged and formatted block lists into new PAC file."
# curl -T pac-done.js ftp://SERVER-AND-DIRECTORY-HERE --user USERNAME-HERE:PASSWORD-HERE
# echo "Successfully uploaded PAC to remote servers. We're done!"
sleep 2
rm -f *.pac
rm -f *.txt
xdg-open ~/BLT/pac