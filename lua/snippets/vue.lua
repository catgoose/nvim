local ls = require("luasnip")
---@diagnostic disable-next-line: unused-local
local s, t, i, c, r, f, sn =
  ls.snippet,
  ls.text_node,
  ls.insert_node,
  ls.choice_node,
  ls.restore_node,
  ls.function_node,
  ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local u = require("util.luasnip")
local smn = u.same_node

local snippets = {
  s(
    "cl",
    c(1, {
      fmt(
        [[
      console.log({});
      ]],
        r(1, "console_log")
      ),
      fmt(
        [[
console.group('{}');
console.log({});
console.groupEnd();
  ]],
        { i(1), r(2, "console_log") }
      ),
    })
  ),
  s(
    "setup",
    fmt(
      [[
      <script setup lang='ts'>
      {}
      </script>
      ]],
      {
        i(1),
      }
    )
  ),
  s(
    "template",
    fmt(
      [[
  <template>
  {}
  </template>
  ]],
      { i(1) }
    )
  ),
  s(
    "vue",
    fmt(
      [[
<script setup lang="ts">
{}
</script>

<template>
  <div></div>
</template>
  ]],
      { i(1) }
    )
  ),
  s(
    "setup",
    fmt(
      [[
<script setup lang="ts">
{}
</script>
   ]],
      i(1)
    )
  ),
  s(
    "style",
    fmt(
      [[
<style lang="scss">
{}
</style>
   ]],
      i(1)
    )
  ),
  s(
    "mount",
    fmt(
      [[
    onMounted(() => {{
      {}
    }})
    ]],
      { i(1) }
    )
  ),
  s(
    "unmount",
    fmt(
      [[
    onUnmounted(() => {{
      {}
    }})
    ]],
      { i(1) }
    )
  ),
  s(
    "watch",
    fmt(
      [[
     watch({}, ({}) => {{
       {}
     }})
     ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "pdate",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PCalendar
    inputId="{}"
    v-model="{}"
    class="w-full"
  ></PCalendar>
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
      }
    )
  ),
  s(
    "pcurr",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PInputNumber
    inputId="{}"
    v-model="{}"
    mode="currency"
    currency="USD"
    locale="en-US"
    class="w-full"
  ></PInputNumber>
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
      }
    )
  ),
  s(
    "pdrop",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PDropdown
    inputId="{}"
    v-model="{}"
    :options="{}"
    class="w-full"
  ></PDropdown>
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
        i(4),
      }
    )
  ),
  s(
    "pinput",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PInputText
    id="{}"
    v-model.trim="{}"
    required="true"
    class="w-full"
  />
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
      }
    )
  ),
  s(
    "pyear",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PInputNumber
    id="{}"
    :min="1900"
    :max="new Date().getFullYear() + 1"
    :useGrouping="false"
    v-model.trim="{}"
    class="w-full"
  />
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
      }
    )
  ),
  s(
    "pnum",
    fmt(
      [[
<div class="field">
  <label for="{}">{}</label>
  <PInputNumber
    id="{}"
    :min="{}"
    :max="{}"
    :useGrouping="false"
    v-model.trim="{}"
    class="w-full"
  />
</div>
  ]],
      {
        i(1),
        i(2),
        smn(1),
        i(3),
        i(4),
        i(5),
      }
    )
  ),
  s(
    "form",
    fmt(
      [[
<form autocomplete="off">
  {}
</form>
  ]],
      i(1)
    )
  ),
  s(
    "props",
    fmta(
      [[
const props = defineProps<<{
  <>
}>>();
]],
      i(1)
    )
  ),
  s(
    "style",
    c(1, {
      fmt(
        [[
  <style lang="scss">
  {}
  </style>
  ]],
        i(1)
      ),
      fmt(
        [[
  <style lang="scss" scoped>
  {}
  </style>
  ]],
        i(1)
      ),
    })
  ),
  s(
    "fun",
    fmta(
      [[
  function <>(<>) {
    <>
  }
  ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "props",
    fmt(
      [[
const props = defineProps<{{
  {}
}}>();
     ]],
      i(1)
    )
  ),
  s(
    "temp",
    fmt(
      [[
     <template>
     {}
     </template>
     ]],
      { i(0) }
    )
  ),
  s(
    "comput",
    fmt(
      [[
  const {} = computed(() => {})
  {}
   ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "emit",
    fmta(
      [[
const emit = defineEmits<<{
  <>: [<>: <>]
  <>
}>>()
    ]],
      {
        i(1),
        smn(1),
        i(2),
        i(0),
      }
    )
  ),
  s(
    "trans",
    fmt(
      [[
.{}enter-from
.{}enter-active
.{}enter-to
.{}leave-from
.{}leave-active
.{}leave-to {{
  {}
}}
     ]],
      {
        i(1),
        smn(1),
        smn(1),
        smn(1),
        smn(1),
        smn(1),
        i(0),
      }
    )
  ),
}

return snippets
