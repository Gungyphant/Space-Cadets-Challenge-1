ids=("dem" "tsh2n14" "js9g09" "mv1g18" "Invalid ID")
for id in "${ids[@]}"; do
	echo "./Bash\ Solution.sh $id"
	./Bash\ Solution.sh $id
	echo
done
