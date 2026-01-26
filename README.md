# System Design Course

A monorepo for system design course projects, built with Turborepo.

## What's inside?

This Turborepo includes the following packages/apps:

### Apps

- `LikeService`: A Next.js API service for handling like operations

### Packages

- `@repo/ui`: A React component library
- `@repo/eslint-config`: ESLint configurations (includes `eslint-config-next` and `eslint-config-prettier`)
- `@repo/typescript-config`: `tsconfig.json`s used throughout the monorepo

### Infrastructure

- `infrastructure/horizontal-scaling`: Terraform configuration for deploying LikeService with nginx load balancer

Each package/app is 100% [TypeScript](https://www.typescriptlang.org/).

## Utilities

This Turborepo has some additional tools already setup for you:

- [TypeScript](https://www.typescriptlang.org/) for static type checking
- [ESLint](https://eslint.org/) for code linting
- [Prettier](https://prettier.io) for code formatting

## Getting Started

### Install dependencies

```bash
pnpm install
```

### Build

To build all apps and packages:

```bash
pnpm build
```

To build a specific package:

```bash
pnpm build --filter=like-service
```

### Develop

To develop all apps and packages:

```bash
pnpm dev
```

To develop a specific app:

```bash
pnpm run:like-service
```

### Infrastructure

To deploy the infrastructure with Terraform:

```bash
cd infrastructure/horizontal-scaling
terraform init
terraform apply
```

See [infrastructure/horizontal-scaling/README.md](./infrastructure/horizontal-scaling/README.md) for detailed instructions.

## Remote Caching

> [!TIP]
> Vercel Remote Cache is free for all plans. Get started today at [vercel.com](https://vercel.com/signup?/signup?utm_source=remote-cache-sdk&utm_campaign=free_remote_cache).

Turborepo can use a technique known as [Remote Caching](https://turborepo.dev/docs/core-concepts/remote-caching) to share cache artifacts across machines, enabling you to share build caches with your team and CI/CD pipelines.

By default, Turborepo will cache locally. To enable Remote Caching you will need an account with Vercel. If you don't have an account you can [create one](https://vercel.com/signup?utm_source=turborepo-examples), then enter the following commands:

```bash
pnpm exec turbo login
pnpm exec turbo link
```

## Useful Links

Learn more about the power of Turborepo:

- [Tasks](https://turborepo.dev/docs/crafting-your-repository/running-tasks)
- [Caching](https://turborepo.dev/docs/crafting-your-repository/caching)
- [Remote Caching](https://turborepo.dev/docs/core-concepts/remote-caching)
- [Filtering](https://turborepo.dev/docs/crafting-your-repository/running-tasks#using-filters)
- [Configuration Options](https://turborepo.dev/docs/reference/configuration)
- [CLI Usage](https://turborepo.dev/docs/reference/command-line-reference)
