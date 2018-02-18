import json

# unspent is where we'll store unspent transactions. 
unspent={}

# This is the new list of transactions that spend the outputs loaded above
# Each transaction *must* spend the entirety of the previous output
transactions={}

with open("unspent.json", 'r') as file_in:
  unspent = json.load(file_in)

with open("transactions.json", 'r') as file_in:
  transactions = json.load(file_in)

# Some book-keeping - we need to number the transactions by finding the highest numbered one
max_id=0
for item in unspent:
  num=int(item[6:])
  if num > max_id:
    max_id = num

# Going through the transactions, we're matching them up with unspent outputs
for tx in transactions:
  print "Processing:" + tx['id']
  if unspent.has_key(tx['id']):
    if unspent[tx['id']]['owner'] != tx['sender']:
      raise Exception("Bad TX, owner must match sender");
    total = 0
    for output in tx['outputs']:
      total = total + int(output['amount'])
      max_id=max_id + 1
      new_ident="output" + str(max_id)
      unspent[new_ident] = { 'owner': output['recipient'], 'amount': output['amount'] }
    if total != unspent[tx['id']]['amount']:
      raise Exception("Bad TX, amounts must add up");
    del unspent[tx['id']]

print "saving new unspent tx list"
with open("new_unspent.json", 'w') as f:
  json.dump(unspent, f, indent=2)
