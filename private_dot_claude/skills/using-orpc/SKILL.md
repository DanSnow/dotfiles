---
name: using-orpc
description: >-
  oRPC client-side patterns for TypeScript frontends using @orpc/contract, @orpc/client,
  @orpc/openapi-client, and @orpc/tanstack-query. Use when writing or modifying API client
  code that uses oRPC, adding new API endpoints to an oRPC contract, creating queries or
  mutations with oRPC + TanStack Query, or migrating from raw fetch to oRPC.
  Triggers: "add endpoint", "add API call", "oRPC", "contract", "queryOptions",
  "mutationOptions", "OpenAPILink".
---

# oRPC Client Patterns

## Three-File Architecture

```
lib/contract.ts  — Zod schemas + oc.router() contract
lib/client.ts    — OpenAPILink + createORPCClient
lib/orpc.ts      — createTanstackQueryUtils(client)
```

## Contract

Wrap with `oc.router()`. Define procedures with `oc.route()`:

```ts
import { oc } from '@orpc/contract'
import { z } from 'zod'

export const contract = oc.router({
  resource: {
    list: oc
      .route({ method: 'GET', path: '/api/v1/resources' })
      .input(z.object({ page: z.number().optional() }))
      .output(z.array(ResourceSchema)),

    find: oc
      .route({ method: 'GET', path: '/api/v1/resources/{id}' })
      .input(z.object({ id: z.string() }))
      .output(ResourceSchema),

    create: oc
      .route({ method: 'POST', path: '/api/v1/resources' })
      .input(z.object({ name: z.string() }))
      .output(z.object({ id: z.string() })),

    update: oc
      .route({ method: 'PUT', path: '/api/v1/resources/{id}' })
      .input(z.object({ id: z.string(), name: z.string().optional() })),

    delete: oc
      .route({ method: 'DELETE', path: '/api/v1/resources/{id}' })
      .input(z.object({ id: z.string() })),
  },
})
```

Rules:
- Path params use `{param}` and must appear in `.input()` schema
- GET inputs serialize as query params automatically
- No input: use `.input(z.union([z.void(), z.undefined()]))` so `mutate()` accepts no args
- Omit `.output()` for void-returning mutations
- Nest routes with plain objects: `units: { tags: { list: oc.route(...) } }`

## Client

```ts
import { createORPCClient } from '@orpc/client'
import type { ContractRouterClient } from '@orpc/contract'
import { OpenAPILink } from '@orpc/openapi-client/fetch'
import type { JsonifiedClient } from '@orpc/openapi-client'

const link = new OpenAPILink(contract, {
  url: baseUrl,
  headers: () => { /* auth headers */ },
  fetch: async (request, init) => {
    const res = await globalThis.fetch(request, init)
    // handle 401, etc.
    return res
  },
})

export const client: JsonifiedClient<ContractRouterClient<typeof contract>> =
  createORPCClient(link)
```

## TanStack Query Utils

```ts
import { createTanstackQueryUtils } from '@orpc/tanstack-query'
export const orpc = createTanstackQueryUtils(client)
```

## Queries

```ts
const { data } = useQuery(
  orpc.resource.list.queryOptions({ input: { page: 1 } })
)

// No-input query
const { data } = useQuery(orpc.tags.list.queryOptions())
```

## Mutations

Pass callbacks into `mutationOptions()` directly:

```ts
// Correct
const mutation = useMutation(
  orpc.resource.create.mutationOptions({
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: orpc.resource.key() })
    },
  }),
)

// Wrong - never spread
const mutation = useMutation({
  ...orpc.resource.create.mutationOptions(),  // BAD
  onSuccess: () => {},
})
```

Call with full contract input shape:
```ts
mutation.mutate({ name: 'New Resource' })
```

### When to use `mutationOptions()` vs manual `mutationFn`

- **Single procedure call** -> `mutationOptions()`
- **Multi-step logic** (conditional creates, chained calls) -> manual `mutationFn` with `client.*`

## Query Keys

```ts
// Invalidate all resource queries
queryClient.invalidateQueries({ queryKey: orpc.resource.key() })

// Invalidate specific
queryClient.invalidateQueries({
  queryKey: orpc.resource.find.key({ input: { id: '123' } })
})

// Set data directly
queryClient.setQueryData(
  orpc.resource.find.key({ input: { id: '123' } }),
  updatedData,
)
```

## Imperative Calls

Use `client.*` for non-hook imperative calls (form `onSubmit`, multi-step mutation bodies):

```ts
const result = await client.resource.create({ name: 'foo' })
```

## Types

Derive from contract schemas, never duplicate inline:

```ts
import type { z } from 'zod'
import type { ResourceSchema } from '~/lib/contract'
type Resource = z.infer<typeof ResourceSchema>
```

See [references/api_reference.md](references/api_reference.md) for import paths and full API surface.
