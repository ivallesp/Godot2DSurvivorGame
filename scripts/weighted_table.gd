class_name WeightedTable

var table: Array[Dictionary] = []
var total_weight: int = 0


func add_item(item, weight):
	table.append({"item": item, "weight": weight})
	total_weight += weight


func remove_item(item_to_remove):
	table = table.filter(func(item): return item["item"] != item_to_remove)
	# Recalculate total weight
	total_weight = 0
	for item in table:
		total_weight += item["weight"]


func pick_item(exclude: Array = []):
	var adj_total_weight = total_weight
	var adj_table = table
	if exclude.size() > 0:
		adj_table = []
		adj_total_weight = 0
		for item in table:
			if not item["item"] in exclude:
				adj_table.append(item)
				adj_total_weight += item["weight"]

	var index = randi_range(1, adj_total_weight)
	var curr_weight_sum: int = 0
	for d in adj_table:
		curr_weight_sum += d["weight"]
		if index <= curr_weight_sum:
			return d["item"]
