local java_dir = vim.fn.stdpath("data") .. "/java"
local bundles = vim.fn.glob(java_dir .. "/java-debug/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
local excluded = {
  ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
  ["jacocoagent.jar"] = true,
}

for _, jar in ipairs(vim.fn.glob(java_dir .. "/java-test/extension/server/*.jar", true, true)) do
  if not excluded[vim.fn.fnamemodify(jar, ":t")] then
    table.insert(bundles, jar)
  end
end

vim.lsp.config("jdtls", {
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local data = vim.fn.stdpath("cache") .. "/jdtls/" .. root:gsub("/", "_")
    return vim.lsp.rpc.start({"jdtls", "-data", data}, dispatchers, {cwd = root})
  end,
  filetypes = {"java"},
  init_options = {bundles = bundles},
  root_markers = {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
  },
  settings = {
    java = {
      symbols = {
        includeSourceMethodDeclarations = true,
      },
      import = {
        gradle = {
          java = { home = "/usr/lib/jvm/java-25-openjdk" },
        },
      },
    },
  },
})

vim.lsp.enable("jdtls")
