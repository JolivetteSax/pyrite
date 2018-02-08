# pyrite

Simple examples of how various parts of bitcoin work, this is for educational
purposes.

## Hashcash

A new block can be "mined" by a proof of work. This algorithm is rooted
simply in looking for leading zeros in the computed hash of the block.

The primary thing missing from this implementation is a miner address that
can receive output value that could be spent in future transactions

## Ledger

The ledger only tracks unspent transactions at each "block". The reason this
works is that because you can only spend outputs, and each output must be fully
consumed at each transaction. In the example supplied, 5 coins are sent to another
user and the sender gets change, fully spending the input. 

The main thing missing from this example is the cryptographic proof, supplying 
the resulting key showing you can indeed spend the output.

## Other

Not necessarily for this project, there are a few other important things involved

 - distribution
 - public/private key pairs

In bitcoin, the distribution is managed through a p2p network maintained by the 
central bitcoin.org list of peers. 

Private keys are used to create special addresses that outputs can be sent to 
in the transaction ledger. Only the holder of the private key can then spend the
output and send it to another of these special addresses.
