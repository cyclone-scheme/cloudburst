Notes:

- Thread safety
  - how to make database functions thread safe??
  - might be the best reason to make DB drivers. Part of the function
    of the driver will be to handle concurrency (locks, etc)
- specify database type in config file ?
- load DB driver based on db type

- user's models will include a base model library with query, etc functions
- base library will incorporate db-specific code. or perhaps we swap out base with db-specific driver? not sure how this will work yet
