lpad="start"

BLOCK_NUMBER=$1
ZEROS=$2

# Transactions are read from STDIN
TRANSACTIONS=$(</dev/stdin)

# leading zero target for difficulty
target=`for ((i=1; i<=$ZEROS; i++)); do echo -n 0; done`

nonce=0
number=""

while [ "$lpad" != "$target" ]
do

  nonce=`expr $nonce + 1`

  block=`echo -n "{
    \"nonce\": $nonce,
    \"transactions\": \"$TRANSACTIONS\",
  }"`

  lpad=`echo -n "$block" | sha256sum |cut -c1-$ZEROS`

done

hashcash=`echo -n "$block" | sha256sum | cut -d' ' -f1`
echo "{
  \"number\": $BLOCK_NUMBER,
  \"difficulty\": $ZEROS,
  \"hash\": \"$hashcash\",
  \"block\": $block,
}"

