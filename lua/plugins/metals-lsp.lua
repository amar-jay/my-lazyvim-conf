return {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    config = function()
  --[[
        local metals_config = require("metals").bare_config()
        metals_config.settings = {
            showImplicitArguments = true,
            excludedPackages = { "akka.actor.typed.javadsl" },
        }
        require("metals").initialize_or_attach(metals_config)
  --]]
    end
  }
