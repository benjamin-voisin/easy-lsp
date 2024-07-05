package = "easy-lsp"
version = "dev-1"
source = {
	url = "git+ssh://git@github.com/benjamin-voisin/easy-lsp.git"
}
description = {
	summary = "the goal is to write a lua lib that makes the implementation of an LSP as easy as possible.",
	detailed = [[
the goal is to write a lua lib that makes the implementation of an LSP as easy as possible.
]],
	homepage = "*** please enter a project homepage ***",
	license = "CC-BY-SA-4.0"
}
build = {
	type = "builtin",
	modules = {
		["easy-lsp"] = "easy-lsp/init.lua",
		["easy-lsp.rpc"] = "easy-lsp/rpc.lua",
		["easy-lsp.io"] = "easy-lsp/io.lua",
	}
}
