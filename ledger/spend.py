import json

unspent={}
transactions={}

with open("unspent.json", 'r') as file_in:
  unspent = json.load(file_in)

with open("transactions.json", 'r') as file_in:
  transactions = json.load(file_in)

max_id=0
for item in unspent:
  num=int(item[6:])
  if num > max_id:
    max_id = num

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
