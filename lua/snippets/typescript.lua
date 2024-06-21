local ls = require("luasnip")
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
local low = u.lower

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
    "cyg",
    fmt(
      [[cy.get({}).{}]],
      { c(1, {
        fmt([['[data-test={}]']], i(1)),
        t(""),
      }), i(2) }
    )
  ),
  s("exp", fmt("expect({}).{}", { i(1), i(2) })),
  s(
    "nspy",
    fmt([[const {} = jest.spyOn({}, '{}');]], {
      i(1, "spy"),
      i(2, "service"),
      i(3, "method"),
    })
  ),
  s(
    "expspy",
    fmt(
      [[
expect({}).toHaveBeenCalled();
  ]],
      i(1, "spy")
    )
  ),
  s(
    "nlogger",
    fmta(
      [[
      #<>(message: any, ...args: any) {
        this.logger.<>(message, { context: <>.name, ...args, });
      }
      ]],
      {
        c(1, {
          t("error"),
          t("debug"),
          t("warn"),
        }),
        smn(1),
        f(u.nest_classname),
      }
    )
  ),
  s(
    "ntry",
    fmta(
      [[const args = {<>}
     try {
       <>
      } catch (error) {
        this.#error(error, { function: '<>', args });
      };
    ]],
      { i(1), i(2), i(3, "MethodName") }
    )
  ),
  s(
    "con",
    fmta(
      [[
  constructor(<>) {<>}
  ]],
      { i(1), i(0) }
    )
  ),
  s(
    "inj",
    fmt([[{}{}: {}]], {
      c(1, {
        t("private "),
        t("public "),
        t(""),
      }),
      i(2, "service"),
      u.capitalize(2),
    })
  ),
  s("angenv", t([[import { environment } from 'src/environments/environment';]])),
  s(
    "tbi",
    fmt(
      [[
  {} = TestBed.inject({});
  ]],
      { i(1), i(2) }
    )
  ),
  s(
    "get",
    fmta(
      [[get <>() {
    return this.<>; 
  }]],
      { i(1), i(2) }
    )
  ),
  s(
    "set",
    fmta(
      [[set <>(<>) {
  this.<> = <>;
}]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
  s("onpush", t([[changeDetection: ChangeDetectionStrategy.OnPush,]])),
  s(
    "ncon",
    fmta(
      [[
  constructor(private logger: WinstonLoggerService) { }

  #error(error: any, ...args: any) {
    this.logger.error(error, {
      context: <>.name,
      ...args,
    });
  }
  ]],
      f(u.nest_classname)
    )
  ),
  s(
    "entity",
    fmta(
      [[
import { GraphUserEntity } from "@app/graph-user";
import {
  Entity,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  VersionColumn,
  ManyToOne,
} from "typeorm";

@Entity({
  name: "<>",
  schema: "<>",
})
export class <>Entity {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @VersionColumn()
  version: number;

  @ManyToOne(() =>> GraphUserEntity, (user) =>> user.id)
  createdByUser: GraphUserEntity;

  @ManyToOne(() =>> GraphUserEntity, (user) =>> user.id)
  updatedByUser: GraphUserEntity;
}
  ]],
      { i(1, "table"), i(2, "schema"), i(3, "") }
    )
  ),
  s(
    "ncol",
    fmt(
      [[
  @Column({})
  {}: {}

  {}
  ]],
      {
        c(1, {
          t(""),
          t({
            "{",
            [[type: "simple-json"]],
            "}",
          }),
        }),
        i(2, "name"),
        i(3, "Type"),
        i(0),
      }
    )
  ),
  s(
    "injrepo",
    fmt(
      [[
  @InjectRepository({}, '{}')
  private {}Repo: Repository<{}>
  ]],
      {
        i(1),
        i(2, "datasource"),
        i(3),
        smn(1),
      }
    )
  ),
  s(
    "injdatasource",
    fmt(
      [[
    @InjectDataSource("{}")
    private entityManager: EntityManager
    ]],
      i(1, "datasource")
    )
  ),
  s(
    "injds",
    fmt(
      [[
    @InjectDataSource("{}")
    private entityManager: EntityManager
    ]],
      i(1, "datasource")
    )
  ),
  s(
    "httpexc",
    fmt(
      [[
      const error = `{}`;
	       throw new HttpException(
         {{
	           status: HttpStatus.{},
	           error,
	         }},
	         HttpStatus.{}
	       );
	 ]],
      {
        i(1),
        c(2, {
          t("BAD_REQUEST"),
          t("UNAUTHORIZED"),
          t("FORBIDDEN"),
          t("NOT_FOUND"),
          t("METHOD_NOT_ALLOWED"),
          t("NOT_ACCEPTABLE"),
        }),
        smn(2),
      }
    )
  ),
  s(
    "httpexc",
    fmta(
      [[
  #httpException(error: any, ...args: any) {
    throw new HttpException(
      {
        status: HttpStatus.BAD_REQUEST,
        error: args ? `${error} - ${args}` : error,
      },
      HttpStatus.BAD_REQUEST
    );
  }
	 ]],
      {}
    )
  ),
  s(
    "nmeth",
    fmta(
      [[
  <><>(<>) {
      const args = { <> }
    try {
      <>
    } catch (error) {
      this.#error(error, { method: this.<>.name, args});
      throw error;
    }
  }
  ]],
      {
        c(1, {
          t("async "),
          t(""),
        }),
        i(2, "method"),
        i(3),
        f(u.nest_method_args, { 3 }),
        i(0),
        smn(2),
      }
    )
  ),
  s(
    "datasource",
    fmt(
      [[
    @InjectDataSource("{}")
    private entityManager: EntityManager,
  ]],
      { i(1) }
    )
  ),
  s("destroy", {
    t([[#destroy = new Subject<void>();]]),
  }),
  s("ondestroy", {
    sn(nil, {
      t({
        "ngOnDestroy(): void {",
        "\tthis.#destroy.next();",
        "}",
      }),
    }),
  }),
  s(
    "#debug",
    fmta(
      [[
  async #debug(message: any, ...args: any) {
    await this.winstonDebugService.debug(message, {
      context: <>.name,
      label: '<>',
      ...args,
    });
    this.logger.debug(message, args)
  }
  ]],
      {
        f(u.nest_classname),
        i(1, "AppName"),
      }
    )
  ),
  s("debserv", t("private winstonDebugService: WinstonDebugService")),
  s(
    "deb",
    fmta(
      [[
    this.#debug(<>, {
      <>
    })
    ]],
      {
        c(1, {
          fmt([[`{}`]], i(1)),
          fmta(
            [[
  `<>: ${<>}`
  ]],
            { smn(1), i(1) }
          ),
          fmt([[{}]], i(1)),
        }),
        c(2, {
          t(""),
          fmta(
            [[
            method: this.<>.name,
            args
          ]],
            { i(1) }
          ),
        }),
      }
    )
  ),
  s(
    "ngrxstore",
    fmta(
      [[
import { Injectable } from "@angular/core";
import { ComponentStore } from "@ngrx/component-store";

type <>State = {
  state: string
};

@Injectable()
export class <>Store extends ComponentStore<<<>State>> {
  constructor() {
    super({
      state: "initial",
    })
  }
}
    ]],
      {
        i(1, "StoreName"),
        smn(1),
        smn(1),
      }
    )
  ),
  s(
    "cachemodule",
    fmta(
      [[
    CacheModule.register({
      isGlobal: <>,
      ttl: <>,
    }),
    ]],
      { i(1, "true"), i(2, "60 * 24") }
    )
  ),
  s("cacheimport", t([[import { Cache } from "cache-manager";]])),
  s("cache", {
    t([[@Inject(CACHE_MANAGER) private cacheManager: Cache]]),
  }),
  s("nhttpimport", t([[import { HttpService } from "@nestjs/axios";]])),
  s("nschedule", t([[ScheduleModule.forRoot(),]])),
  s(
    "nsubscriber",
    fmt(
      [[
import {{
  EntitySubscriberInterface,
  EventSubscriber,
  InsertEvent,
  UpdateEvent,
}} from 'typeorm';

@EventSubscriber()
export class {}Subscriber
  implements EntitySubscriberInterface<{}Entity>
{{
  listenTo(): any {{
    return {}Entity;
  }}

  #updatedColumns: string[];
  async beforeUpdate(event: UpdateEvent<{}Entity>) {{
    const entity = <{}Entity>event.entity;
    this.#updatedColumns = event.updatedColumns.map((m) => m.propertyName);
  }}

  async beforeInsert(event: InsertEvent<{}Entity>) {{
    const entity = <{}Entity>event.entity;
  }}

  #isColumnUpdated(column: string) {{
    return this.#updatedColumns.indexOf(column) >= 0;
  }}
}}
    ]],
      { i(1, "Entity"), smn(1), smn(1), smn(1), smn(1), smn(1), smn(1) }
    )
  ),
  s(
    "appenv",
    fmta(
      [[
import { Environment } from './environment.type';

export class AppEnvironment {
  environment = baseEnvironment;
  constructor(environment: DeepPartial<<Environment>> = {}) {
    this.environment = this.#extendEnvironment(environment);
  }
  #extendEnvironment(environment: DeepPartial<<Environment>>): Environment {
    return Object.assign({}, baseEnvironment, environment);
  }
}

type DeepPartial<<T>> = T extends object
  ? {
      [P in keyof T]?: DeepPartial<<T[P]>>;
    }
  : T;

  const baseEnvironment: Environment = {

  }
      ]],
      {}
    )
  ),
  s(
    "newappenv",
    fmta(
      [[
import { AppEnvironment } from './environment.app';

export const environment = new AppEnvironment().environment;
  ]],
      {}
    )
  ),
  s("tap", {
    t("tap((val) => console.log(val)),"),
  }),
  s("catchError", {
    fmta(
      [[
catchError((err) =>> {
  this.snackbarService.error(
    `<>: ${err.message}`
  );
  return throwError(err);
})
]],
      { i(1) }
    ),
  }),
  s(
    "stand",
    fmt(
      [[
  standalone: true,
  imports: [CommonModule, {}],
  ]],
      { i(1) }
    )
  ),
  s(
    "rxsel",
    fmt(
      [[
  readonly {}{}$ = this.select((state) => state.{})
  ]],
      { c(1, {
        t("#"),
        t(""),
      }), i(2, "selector"), smn(2) }
    )
  ),
  s(
    "rxupd",
    fmt(
      [[
  readonly {}set{} = this.updater((state, {}: {}) => ({{
    ...state,
    {}
  }}))
  ]],
      {
        c(1, {
          t("#"),
          t(""),
        }),
        i(2, "Updater"),
        low(2),
        i(3, "Type"),
        low(2),
      }
    )
  ),
  s(
    "rxeff",
    fmt(
      [[
  readonly {}{} = this.effect(({}$: Observable<{}>) =>
  {}$.pipe({})
  )
  ]],
      {
        c(1, {
          t(""),
          t("#"),
        }),
        i(2, "effect"),
        i(3, "obs"),
        i(4, "type"),
        smn(3),
        i(0),
      }
    )
  ),
  s(
    "switchmap",
    fmt(
      [[
  switchMap(({}) => this.{}{}({})),
  ]],
      {
        c(1, {
          t(""),
          fmt(
            [[
          {}: {}
          ]],
            { i(1), i(2) }
          ),
        }),
        c(2, {
          t(""),
          t("#"),
        }),
        i(3),
        i(0),
      }
    )
  ),
  s(
    "reduce",
    fmta(
      [[
  <>.reduce((acc, cur) =>> {
    <>
    return acc
  })
  ]],
      { i(1), i(2) }
    )
  ),
  s(
    "ct",
    fmt([[{}]], { c(1, {
      t("console.time()"),
      t("console.timeEnd()"),
    }) })
  ),
  s(
    "meth",
    fmt(
      [[
    {}({}) {{
      {}
    }}
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    "tryerr",
    fmt(
      [[
  if (!{}) {{
    throw new Error("Error: {}");
  }}
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
    "pinia",
    fmta(
      [[
  export const use<>Store = defineStore('<>Store', () =>> {
   <> 
    return {

    }
  })
  ]],
      {
        i(1),
        low(1),
        i(0),
      }
    )
  ),
  s(
    "eaf",
    fmta(
      [[
export async function <>(<>) {
  <>
}
    ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    "trans",
    fmta(
      [[
await this.entityManager.transaction(async (manager) =>> {
  <>
});
  ]],
      { i(1) }
    )
  ),
  s("useapi", t("const { apiFetch } = useApiFetch();")),
  s(
    "apifetch",
    fmta(
      [[
  const { error, data } = await apiFetch('<>').<>(<>).json();

  if (error.value) {
    <>
  } else {
    const response = data.value;
    <>
    return response
  }
  ]],
      {
        i(1),
        c(2, {
          t("get"),
          t("post"),
          t("put"),
          t("delete"),
        }),
        i(3),
        i(4, "console.log(error);"),
        i(5, "console.log(response);"),
      }
    )
  ),
  s(
    "ntrans",
    fmt(
      [[
      await this.entityManager.transaction(async (manager) => {{
        {} 
      }});
    ]],
      { i(1) }
    )
  ),
  s(
    "query",
    fmt(
      [[
      const query = /* sql */ `
        {}
      `
     ]],
      { i(1) }
    )
  ),
  s(
    "vt",
    fmta(
      [[import { expect, test } from 'vitest'

 <> 
  ]],
      { i(0) }
    )
  ),
  s(
    "de",
    fmta(
      [[
     describe('<>', () =>> {
       <>
     })
     ]],
      { i(1), i(2) }
    )
  ),
  s(
    "be",
    fmta(
      [[beforeEach(() =>> {
          <>
        })
        ]],
      { i(1) }
    )
  ),
  s(
    "it",
    fmta(
      [[it('<>', () =>> {
     <>
   })
   ]],
      { i(1), i(2) }
    )
  ),
  s(
    "tt",
    fmta(
      [[test('<>', () =>> {
     <>
   })
   ]],
      { i(1), i(2) }
    )
  ),
  s(
    "comp",
    fmt(
      [[
    export function {}() {{

      {}

      return {{

      }}
    }}
    ]],
      {
        f(function()
          return vim.fn.expand("%:t:r")
        end),
        i(1),
      }
    )
  ),
  s(
    "fun",
    fmt(
      [[
    function {}() {{
      {}
    }}
    ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    "bepinia",
    fmt(
      [[
  beforeEach(() => {{
    setActivePinia(createPinia());
  }});
  {}
     ]],
      { i(1) }
    )
  ),
  s("sc", fmt([[structuredClone({})]], { i(0) })),
  s(
    "testpinia",
    fmta(
      [[
describe('<>', () =>> {
  let store: ReturnType<<typeof <>>>;
  beforeEach(() =>> {
    setActivePinia(createPinia());
    store = <>();
  });

  it('', () =>> {
    <>
  })
});
]],
      { i(1), i(2), smn(2), i(0) }
    )
  ),
  s("itc", t("const itc = it.concurrent;")),
  s(
    "playwright",
    fmta(
      [[
import { test, expect } from '@playwright/test'

test.describe('<>', () =>> {
  test('<>', async ({ page }) =>> {
    <>
  })
})
    ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    "ref",
    fmt(
      [[
  const {}: Ref<{} | undefined> = ref();
  {}
     ]],
      {
        i(1),
        i(2, "Type"),
        i(0),
      }
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
    "prtest",
    fmt(
      [[

      test('{}', async ({{ page }}) => {{
       {}
      }})
     ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    "primp",
    fmta(
      [[
import { test, expect, Page } from '@playwright/test';
<>
    ]],
      i(1)
    )
  ),
  --  TODO: 2024-06-03 - make choice for this on desc snippet
  s(
    "prdesc",
    fmt(
      [[
test.describe('{}', () => {{
  {}
}})
     ]],
      { i(1), i(0) }
    )
  ),
  s(
    "vitest",
    fmta(
      [[
import { DOMWrapper, VueWrapper, enableAutoUnmount } from '@vue/test-utils';
import <> from '../<>.vue';

describe('<>', () =>> {
  let wrapper: VueWrapper;
  beforeEach(() =>> {
    wrapper = mount(<>, {});
  });
  enableAutoUnmount(afterEach);

  it('<>', () =>> {
    <>
  })
})
    ]],
      {
        i(1),
        smn(1),
        smn(1),
        smn(1),
        i(2, "renders"),
        i(0),
      }
    )
  ),
  s("snap", t(".toMatchSnapshot()")),
  s("scr", t("await expect(page).toHaveScreenshot();")),
  s(
    "timeout",
    fmta(
      [[
   setTimeout(() =>> {
     <>
   }, <>)
   ]],
      { i(1), i(2, "0") }
    )
  ),
}

return snippets
