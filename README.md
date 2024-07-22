🚧 Work in progress

the goal is to write a lua lib that makes the implementation of an LSP as easy as possible.

You can see an example of a project using `easy-lsp` here: [squirrel-prover-lsp](https://github.com/benjamin-voisin/squirrel-prover-lsp)

## Usage

### Simple Example

```lua
Lsp = require 'easy-lsp'

Lsp.name = "YourLSPName"
Lsp.version = "beta"
Lsp.capabilities = {
}

Lsp.start()
```
This is the simples LSP, as it does absolutly nothing.

An LSP works by answering to `requests`, and handling `notifications`. The list of available `requests` and `notifications` is available here: [spec](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/).

For example, there is a `completion` request for autocompletion. In order for your LSP to handle them, you need to do two things:
- Add the Completion capability to the `capabilities` table.
- Add a function than responds to completion requests.

This will give you
```lua
Lsp = require 'easy-lsp'

Lsp.name = "YourLSPName"
Lsp.version = "beta"
Lsp.capabilities = {
    completionProvider = {},
}

Lsp.HandleRequest["textDocument/completion"] = function (request)
    local response = {
        id = request.id,
        result = {
            items = {
                {
                    label = "item1",
                    documentation = "First completion item",
                },
                {
                    lable = "item2",
                    documentation = "Second completion item",
                },
            }
        }
    }
    return response
end

Lsp.Start()
```
