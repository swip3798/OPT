extends Node

var basepath: String = ""
var baseargs: PoolStringArray = []
var port: int = 43512

var _is_validated: bool = false
var _host = "localhost"

var _pid: int = 0


func start_ee_backend_http(basepath: String, baseargs: PoolStringArray = []):
	if _pid != 0:
		return
	self.basepath = basepath
	self.baseargs = baseargs
	_pid = OS.execute(basepath, baseargs, false)

func stop_ee_backend():
	OS.kill(_pid)
	_pid = 0

func _exit_tree():
	print("Exit tree, kill ee backend")
	stop_ee_backend()
