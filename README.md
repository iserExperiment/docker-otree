# Docker for oTree

## Usage

- Settings (`.env`):
    - Change posswords `PG_PASSWORD` and `OTREE_ADMIN_PASSWORD`.
    - To Listen to a port other than `8000`, change `OTREE_PORT`.
    - If you use your own environment variables, add them.

- To build:
    ```
    docker compose build
    ```

- To run:
    ```
    docker compose up -d
    ```
    - Adding option `d` prevents the log from displaying.

- To reset the database (`resetdb`):
    ```
    docker compose exec otreeserver otree resetdb
    ```
    - Here, `otreeserver` is the service name defined in the `.env` file.

- To check logs:
    ```
    docker compose logs -f
    ```

- To shutdown:
    ```
    docker compose down
    ```
    - Then, the containers are stopped and removed.
    - Since Postgres data is stored in Docker's volume, it will survive unless deleted by command `docker volume rm {NAME OF VOLUME}`.

- To dump:
    ```
    mkdir postgres_data
    docker compose exec database pg_dump --clean --if-exists -U otree_user otree_db > postgres_data/backup.sql
    ```
    - Here, `database` is the service name, `otree_user` is the container name, and `otree_db` is the database name. All of these are defined in the `.env` file. The path `postgres_data/backup.sql` specifies the output file.
    - You can then find the `.sql` file in the `postgres_data` directory.

- To restore from `.sql` file:
    ```
    cat postgres_data/backup.sql | docker compose exec -T database psql -U otree_user -d otree_db
    ```
    - Here, the path `postgres_data/backup.sql` specifies the input file. `database` is the service name, `otree_user` is the container name, and `otree_db` is the database name. All of these are defined in the `.env` file.

- To initialize the database at startup using an `.sql` file, add the following line under `devices > database > volumes` in `compose.yaml`:
    ```yaml
    volumes:
      - ./postgres_data:/docker-entrypoint-initdb.d
    ```
    - Any `.sql` files stored in the `postgres_data` directory will be executed automatically.


## In the development phase

Instead of using Docker-compose, you can build using the Dockerfile itself.

- To build:
    ```
    docker build ./ -t devotree
    ```

- To `devserver`
    ```
    docker run --rm -it -v $PWD:/app -p 8000:8000 devotree
    ```

- To `startapp`
    ```
    docker run --rm -it -v $PWD:/app devotree otree startapp instruction
    ```


## How to directly copy the data of a Docker volume.

You can copy a volume's contents elsewhere with:

```
docker run --rm \
  -v XXXXX:/var/lib/postgresql/data \
  -v $(pwd):/backup \
  alpine \
  tar cvf /backup/YYYYY.tar /var/lib/postgresql/data
```

This command temporarily launches a new Alpine Linux container, mounts the postgres-data volume at `/var/lib/postgresql/data`, and creates a `YYYYY.tar` archive in your current directory. The resulting tar file contains all the PostgreSQL database files.

### How to Restore a Docker Volume

1. Extract the tar file into a directory of your choice. This will create a `var` folder.  
2. In your compose.yaml, under `devices > database > volumes`, replace with:  
    ```yaml
    volumes:
      - /PATH/TO/var/lib/postgresql/data:/var/lib/postgresql/data
    ```

   Here, `/PATH/TO/` on the left-hand side should point to where you extracted the tar file. You can use a relative path if you prefer.  
3. Run the container.
