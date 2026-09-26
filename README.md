# dbt-airbnb-pipeline

dbt project that transforms raw Airbnb booking/listing/host data (landed in Snowflake via S3) into staging → intermediate → marts models.

## Project structure

```
.
├── analysis
├── ddl
│   ├── ingest.sql        # raw table DDL + COPY INTO from S3 (one-time/admin)
│   └── setup.sql         # account setup: TRANSFORM role, warehouse, AIRBNB db (one-time/admin)
├── docs
├── macros
│   ├── create_target_database.sql    # on-run-start hook: provisions your sandbox db
│   ├── generate_database_name.sql    # database = AIRBNB_<schema>
│   └── generate_schema_name.sql      # flat staging/intermediate/marts schemas
├── models
│   ├── intermediate
│   ├── marts
│   └── staging
│       ├── _sources.yml
│       └── stg_bookings.sql
├── seeds                 # static reference data loaded via `dbt seed`
├── snapshots             # type-2 slowly changing dimensions
├── tests
├── dbt_project.yml
├── packages.yml
└── pyproject.toml
```

## Environments

| Target | Database | Schema | Use |
|---|---|---|---|
| `dev` (default) | `AIRBNB_<you>` | `staging` / `intermediate` / `marts` | Your personal sandbox |
| `prod` | `AIRBNB` | `staging` / `intermediate` / `marts` | Shared production build |

## Prerequisites

- [uv](https://docs.astral.sh/uv/) (manages the Python version and dependencies for you)
- A Snowflake user in the `dbt-airbnb-pipeline` account with the `TRANSFORM` role granted (see step 3 below if you don't have one)
- This project uses key-pair auth, not passwords — step 2 below covers generating a key pair

## One-time setup

1. **Clone and install dependencies**

   ```bash
   git clone <this-repo>
   cd dbt-airbnb-pipeline
   uv sync
   ```

2. **Generate a key pair** (skip if you already have one for Snowflake)

   ```bash
   mkdir -p ~/.ssh/snowflake
   openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out ~/.ssh/snowflake/rsa_key.p8 -nocrypt
   openssl rsa -in ~/.ssh/snowflake/rsa_key.p8 -pubout -out ~/.ssh/snowflake/rsa_key.pub
   ```

3. **Get a Snowflake user.** If you don't have one yet, send the contents of `rsa_key.pub` to whoever administers the account and ask them to create one for you, following the same pattern as the `DBT_USER` service account in [`ddl/setup.sql`](ddl/setup.sql) (key-pair auth, `TRANSFORM` role) — just with your own username and your own public key:

   ```sql
   CREATE USER IF NOT EXISTS <your_snowflake_username>
     DEFAULT_ROLE = TRANSFORM
     DEFAULT_WAREHOUSE = COMPUTE_WH
     RSA_PUBLIC_KEY = '<paste your rsa_key.pub contents>';
   GRANT ROLE TRANSFORM TO USER <your_snowflake_username>;
   ```

   This requires `ACCOUNTADMIN` and only needs to happen once per person. **Don't share the `DBT_USER` service account or its private key across people** — it exists for automation, not as a shared human login.

4. **Add a profile** to `~/.dbt/profiles.yml`. Use **your Snowflake username as the schema** — that's what your personal sandbox database gets named after (see [How the per-developer database works](#how-the-per-developer-database-works) below):

   ```yaml
   dbt-airbnb-pipeline:
     target: dev
     outputs:
       dev:
         type: snowflake
         threads: 16
         account: <account_identifier>       # get this from an admin, or run the last query in ddl/setup.sql yourself
         user: <your_snowflake_username>
         role: TRANSFORM
         warehouse: COMPUTE_WH
         database: AIRBNB
         schema: <your_snowflake_username>
         private_key_path: ~/.ssh/snowflake/rsa_key.p8
       prod:
         type: snowflake
         threads: 16
         account: <account_identifier>
         user: <your_snowflake_username>
         role: TRANSFORM
         warehouse: COMPUTE_WH
         database: AIRBNB
         schema: PRODUCTION
         private_key_path: ~/.ssh/snowflake/rsa_key.p8
   ```

5. **Verify the connection**

   ```bash
   uv run dbt debug
   ```

6. **Run it**

   ```bash
   uv run dbt run
   ```

   That's it — no manual `CREATE DATABASE` or `GRANT` statements needed. The first run automatically provisions your personal sandbox database (see below).

## How the per-developer database works

This project overrides dbt's default database/schema naming (see `macros/generate_database_name.sql` and `macros/generate_schema_name.sql`) so that:

- Your **database** is `AIRBNB_<your schema>` — e.g. schema `jdoe` → database `AIRBNB_JDOE`. Everyone gets their own isolated sandbox, built fresh from the shared `AIRBNB.RAW` source data.
- Your **schemas within it** are flat and layer-based: `staging`, `intermediate`, `marts` (not prefixed/suffixed further).
- An `on-run-start` hook (`macros/create_target_database.sql`) runs `CREATE DATABASE IF NOT EXISTS` for your personal database before every `dbt run`/`dbt build`/`dbt test`. The `TRANSFORM` role already has account-level `CREATE DATABASE` privilege, and since it creates the database itself, it automatically owns it — so there's nothing left for you to grant by hand.
- The `prod` target is the one exception: it always resolves to the shared `AIRBNB` database (the same one raw data lands in under `AIRBNB.RAW`), regardless of schema — already provisioned, no per-dev suffix.

## Raw data ingestion

You normally **don't** need to touch these — they're one-time/admin scripts, not part of the everyday dev loop:

- [`ddl/setup.sql`](ddl/setup.sql) — one-time account setup (`TRANSFORM` role, warehouse, `AIRBNB` database, service user)
- [`ddl/ingest.sql`](ddl/ingest.sql) — creates the raw tables in `AIRBNB.RAW` and `COPY INTO`s them from S3. Only needs rerunning if the source CSVs are refreshed. Fill in real AWS credentials locally before running — never commit real key values into this file.

## Common commands

```bash
uv run dbt run              # build all models in your dev sandbox
uv run dbt run --select stg_bookings   # build a single model
uv run dbt test             # run tests
uv run dbt build            # run + test in DAG order
uv run dbt docs generate && uv run dbt docs serve   # browse the docs site
```
