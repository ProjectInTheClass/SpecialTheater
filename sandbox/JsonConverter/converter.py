# Usage: just copy & paste the table data from the excel.
# Caution: each column must be sparated by '\t'.

isColumn = True
columns = []
result = []

while True:
  # get a line.
  line = input()
  if line == '':
    break
  
  # set the column.
  if isColumn:
    columns = [column for column in filter(lambda x: x != '', line.split('\t'))]
    isColumn = False
    continue

  # convert to json structure.
  data = {}
  items = [item for item in filter(lambda x: x != '', line.split('\t'))]
  for col in columns:
    data[col] = items[0]
    items = items[1:]
  if len(items) > 0:
    data[columns[-1]] = [data[columns[-1]]] + items

  # store the data of this line.
  result.append(data)

# print the result.
print(result)