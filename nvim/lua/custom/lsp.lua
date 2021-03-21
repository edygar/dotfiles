require'lspinstall'.setup()

local custom_attach = function(client)
  print("'" .. client.name .. "' language server started" );

  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
end

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach=custom_attach }
end
