ids=("dem" "tsh2n14" "js9g09" "mv1g18" "Invalid ID")
for id in "${ids[@]}"; do
	echo "./Solution.sh $id"
	./Solution.sh $id
	echo
done
