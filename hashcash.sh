lpad="start"

BLOCK_NUMBER=$1
ZEROS=$2

# Transactions are read from STDIN
TRANSACTIONS=$(</dev/stdin)

# leading zero target for difficulty
target=`for ((i=1; i<=$ZEROS; i++)); do echo -n 0; done`

# The nonce is used to change the sha512sum each time through the loop
nonce=0
number=""

# This is the mining loop. How quickly it runs determines how good you will be at mining, 
# Because you'll never know how many times you need to run this loop before you get a 
# "solution" with the right number of zeros in the target
while [ "$lpad" != "$target" ]
do

  # Each time through the loop, this will increment by one
  nonce=`expr $nonce + 1`

  # The nonce needs to be added to the candidate block
  # In bitcoin, the miner's address would also be added to the block
  block=`echo -n "{
    \"nonce\": $nonce,
    \"transactions\": \"$TRANSACTIONS\",
  }"`

  # The sha256sum is the hash function that will be checked for leading zeros
  # The cut -c1-$ZEROS program will take only the first chunk of the result 
  # that will allow us to compare it to the target
  lpad=`echo -n "$block" | sha256sum |cut -c1-$ZEROS`

done

# finalize the block, we've found a "winning" nonce and mined a block
hashcash=`echo -n "$block" | sha256sum | cut -d' ' -f1`
echo "{
  \"number\": $BLOCK_NUMBER,
  \"difficulty\": $ZEROS,
  \"hash\": \"$hashcash\",
  \"block\": $block,
}"

