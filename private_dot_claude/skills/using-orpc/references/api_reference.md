# oRPC API Reference

## Package Imports

| Package | Import | Purpose |
|---------|--------|---------|
| `@orpc/contract` | `oc` | Define contract routes |
| `@orpc/contract` | `ContractRouterClient` (type) | Type the client from contract |
| `@orpc/client` | `createORPCClient` | Create client from link |
| `@orpc/openapi-client/fetch` | `OpenAPILink` | Fetch-based link for OpenAPI backends |
| `@orpc/openapi-client` | `JsonifiedClient` (type) | Wrapper type for JSON serialization |
| `@orpc/tanstack-query` | `createTanstackQueryUtils` | TanStack Query integration |

## `oc.route()` Options

```ts
oc.route({
  method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE',
  path: '/api/v1/resources/{id}',  // {param} for path params, {+path} for catch-all
  successStatus?: 200 | 201 | 204, // optional, defaults vary by method
})
```

## `oc.router()`

Wrap the contract object to enable type inference:

```ts
export const contract = oc.router({
  namespace: {
    procedure: oc.route({ ... }).input(...).output(...),
    nested: {
      procedure: oc.route({ ... }).input(...).output(...),
    },
  },
})
```

## No-Input Procedures

Procedures without input (e.g. a POST that takes no body) require a workaround to allow `mutate()` with no arguments. Without `.input()`, oRPC types the mutation input as required, forcing `mutate(undefined)`.

Fix: add `.input(z.union([z.void(), z.undefined()]))`:

```ts
// Contract
health: {
  ping: oc
    .route({ method: 'POST', path: '/api/v1/health/ping' })
    .input(z.union([z.void(), z.undefined()]))
    .output(z.object({ message: z.string() })),
}

// Usage — mutate() works with no args
const mutation = useMutation(orpc.health.ping.mutationOptions())
mutation.mutate()
```

Without the `.input()` workaround, TypeScript requires `mutate(undefined)`.

## `OpenAPILink` Constructor

```ts
new OpenAPILink(contract, {
  url: string | (() => string),
  headers?: () => Record<string, string> | Promise<Record<string, string>>,
  fetch?: (request: Request, init?: RequestInit) => Promise<Response>,
})
```

- `url`: base URL; empty string = relative paths
- `headers`: called before each request; return auth headers
- `fetch`: custom fetch; use for interceptors (401 handling, logging)

## TanStack Query Utils Methods

Given `const orpc = createTanstackQueryUtils(client)`:

### `orpc.<path>.queryOptions(opts?)`
Returns object for `useQuery()`. Pass `{ input: { ... } }` for procedures with input.

### `orpc.<path>.mutationOptions(opts?)`
Returns object for `useMutation()`. Accepts all TanStack mutation options (`onSuccess`, `onError`, `onSettled`, etc.) directly.

### `orpc.<path>.infiniteOptions(opts)`
Returns object for `useInfiniteQuery()`:
```ts
orpc.resource.list.infiniteOptions({
  input: (pageParam) => ({ cursor: pageParam ?? 0, limit: 10 }),
  initialPageParam: undefined,
  getNextPageParam: (lastPage) => lastPage.nextCursor,
})
```

### `orpc.<path>.key(opts?)`
Generate query key for invalidation. Partial matching when no input specified:
```ts
orpc.resource.key()                          // all resource queries
orpc.resource.key({ type: 'query' })         // only regular (non-infinite)
orpc.resource.find.key({ input: { id } })    // specific query
```

### `orpc.<path>.queryKey(opts?)`
Like `.key()` but for `setQueryData`:
```ts
queryClient.setQueryData(
  orpc.resource.find.queryKey({ input: { id } }),
  newData,
)
```

## `createTanstackQueryUtils` Options

```ts
createTanstackQueryUtils(client, {
  path?: string[],              // base path to avoid key conflicts
  experimental_defaults?: {     // default options per procedure
    resource: {
      find: {
        queryOptions: { staleTime: 60_000 },
      },
      create: {
        mutationOptions: {
          onSuccess: (output, input, _, ctx) => {
            ctx.client.invalidateQueries({ queryKey: orpc.resource.key() })
          },
        },
      },
    },
  },
})
```
