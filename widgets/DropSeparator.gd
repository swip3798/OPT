extends Button

func can_drop_data(_pos, data):
	return typeof(data) == TYPE_INT
