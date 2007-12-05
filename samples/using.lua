require"macro"

local syntax = [[
  using <- space import+ -> build_using
  name <- [_a-zA-Z][_a-zA-Z0-9]+
  module <- {name ('.' name)*} space
  namelist <- ({name} space (',' space {name} space)*) -> build_namelist
  import <- ('from' space module 'import' space namelist) -> build_import
]]

local defs = {
  build_using = function (...)
    return { imports = {...} }
  end,
  build_import = function (module, names)
    return { module = module, names = names }
  end,
  build_namelist = function (...)
    local names = { ... }
    local list = {}
    for i, v in ipairs(names) do
      list[i] = { name = v }
    end
    return list
  end
}

local code = [[
  $imports[=[
    local _ = require("$module")
    $names[==[
    local $name = _["$name"]
    ]==]
  ]=]
    local _
]]

macro.define("using", syntax, code, defs)

macro.define_simple("import", function (args)
                                local libname = args[1]
                                local l = require(libname)
                                args.funcs = {}
                                for f, _ in pairs(l) do table.insert(args.funcs, { name = f }) end
                                return [[
                                  local _ = require[=[$1]=]
                                  $funcs[=[
                                  local $name = _[ [==[$name]==] ]
                                  ]=]
                                ]] 
                              end)
