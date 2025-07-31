local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
   -- Debug log
   s("ld", fmt([[{}.log.Debug("{}")]], {
      i(1, "variable"),
      i(2, "message"),
   })),

   -- Table-driven test with cmp.Diff
   s("tt", fmt([[
func Test{}(t *testing.T) {{
  tests := []struct {{
    name string
    input {}
    want {}
  }}{{
    // TODO: Add test cases.
  }}

  for _, tt := range tests {{
    t.Run(tt.name, func(t *testing.T) {{
      got := {}(tt.input)
      if diff := cmp.Diff(tt.want, got); diff != "" {{
        t.Errorf("%s() mismatch (-want +got):\n%s", tt.name, diff)
      }}
    }})
  }}
}}]], {
      i(1, "Function"),
      i(2, "Type"),
      i(3, "Type"),
      i(4, "Function"),
   })),

   -- Extended table test with before/after
   s("tt2", fmt([[
func Test{}(t *testing.T) {{
  tests := []struct {{
    name   string
    before func()
    input  {}
    want   {}
    after  func()
  }}{{
    {{
      name: "example",
      before: func() {{}},
      input: {},
      want:  {},
      after: func() {{}},
    }},
  }}

  for _, tt := range tests {{
    t.Run(tt.name, func(t *testing.T) {{
      tt.before()
      got := {}(tt.input)
      if diff := cmp.Diff(tt.want, got); diff != "" {{
        t.Errorf("%s() mismatch (-want +got):\n%s", tt.name, diff)
      }}
      tt.after()
    }})
  }}
}}]], {
      i(1, "Function"),
      i(2, "InputType"),
      i(3, "OutputType"),
      i(4, "inputValue"),
      i(5, "expectedValue"),
      i(6, "Function"),
   })),

   -- Error handling
   s("ife", fmt([[
if err != nil {{
  {}
}}]], {
      i(1, "return err"),
   })),

   -- Log with choice
   s("log", fmt([[log.{}("{}")]], {
      c(1, { t("Debug"), t("Info"), t("Error"), t("Warn") }),
      i(2, "message"),
   })),

   -- Function template
   s("function", fmt([[
func {}({}) {} {{
  {}
}}]], {
      i(1, "FunctionName"),
      i(2, ""), -- Förifylld tom sträng – undviker tabbstopp-problem
      i(3, "returnType"),
      i(4, "// TODO"),
   })),

   -- Interface definition
   s("interface", fmt([[
type {} interface {{
  {}
}}]], {
      i(1, "MyInterface"),
      i(0),
   })),

   -- Method definition
   s("method", fmt([[
func ({}) {}({}) {} {{
  {}
}}]], {
      i(1, "r MyType"),
      i(2, "MethodName"),
      c(3, {
         i(1, ""),           -- empty
         i(2, "param Type"), -- with params
      }),
      i(4, "returnType"),
      i(5, "// TODO"),
   })),

   -- Struct + constructor
   s("structc", fmt([[
type {} struct {{
  {}
}}

func New{}({}) *{} {{
  return &{}{{}}
}}]], {
      i(1, "MyStruct"),
      i(2, "// fields..."),
      rep(1),
      i(3, "// params"),
      rep(1),
      rep(1),
   })),

   -- Struct definition
   s("struct", fmt([[
type {} struct {{
  {}
}}]], {
      i(1, "MyStruct"),
      i(2, "// fields..."),
   })),

   -- Interface implementation assertion
   s("impl", fmt([[var _ {} = (*{})(nil)]], {
      i(1, "MyInterface"),
      i(2, "MyStruct"),
   })),

   -- Benchmark
   s("tb", fmt([[
func Benchmark{}(b *testing.B) {{
  for i := 0; i < b.N; i++ {{
    {}({})
  }}
}}]], {
      i(1, "FunctionName"),
      i(2, "FunctionName"),
      i(3, "// args"),
   })),

   -- JSON marshal
   s("json", fmt([[
data, err := json.Marshal({})
if err != nil {{
  {}
}}]], {
      i(1, "value"),
      i(2, "return err"),
   })),

   -- Log current function name
   s("logfn", fmt([[
log.Debug("{}: entered", runtime.FuncForPC(reflect.ValueOf({}).Pointer()).Name())
  ]], {
      i(1, "msg"),
      i(2, "fn"),
   })),

   -- FOR loop classic
   s("fori", fmt([[
for i := 0; i < {}; i++ {{
  {}
}}]], {
      i(1, "n"),
      i(2, "// TODO"),
   })),

   -- FOR RANGE loop
   s("forr", fmt([[
for {}, {} := range {} {{
  {}
}}]], {
      i(1, "k"),
      i(2, "v"),
      i(3, "collection"),
      i(4, "// TODO"),
   })),

   -- SWITCH
   s("switch", fmt([[
switch {} {{
case {}:
  {}
default:
  {}
}}]], {
      i(1, "expr"),
      i(2, "value"),
      i(3, "// case body"),
      i(4, "// default body"),
   })),

   -- DEFER
   s("defer", fmt([[
defer {}({})
]], {
      i(1, "fn"),
      i(2, "// args"),
   })),

   -- SELECT
   s("select", fmt([[
select {{
case {} := <-{}:
  {}
default:
  {}
}}]], {
      i(1, "val"),
      i(2, "ch"),
      i(3, "// handle received value"),
      i(4, "// default case"),
   })),
   s("main", fmt([[
func main() {{
  {}
}}]], {
      i(1, "// TODO"),
   })),
   -- Wrap error using fmt.Errorf
   s("wraperr", fmt([[fmt.Errorf("{}: %w", {})]], {
      i(1, "message"),
      i(2, "err"),
   })),

   -- Pretty print a value using fmt.Printf
   s("pp", fmt([[fmt.Printf("%+v\n", {})]], {
      i(1, "value"),
   })),
   -- Critical section protected by a mutex (safe concurrent access)
   s("mutex", fmt([[
var mu sync.Mutex
mu.Lock()
defer mu.Unlock()
{}]], {
      i(1, "// critical section"),
   })),
}
