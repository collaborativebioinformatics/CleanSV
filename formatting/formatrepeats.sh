for file in repeats/*bed
do
	sed 's/chr//g' $file | sort -k1,1 -k2,2n | bgzip -c > $file.gz
	tabix $file.gz
	rm $file # make sure you have bgzip and tabix!
done
