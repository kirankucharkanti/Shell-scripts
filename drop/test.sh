ls -d */ > input.txt
input1="input.txt"i
while IFS= read -r line
do
cd $line
cp bin/Release/* $line
done < "$input"
