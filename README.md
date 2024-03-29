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

- To `resetdb`:
    ```
    docker compose exec otreeserver otree resetdb
    ```

- To check logs:
    ```
    docker compose logs otreeserver -f
    ```

- To shutdown:
    ```
    docker compose down
    ```
    - Then, the containers are stopped and removed.
    - Since Postgres data is stored in Docker's volume, it will survive unless deleted by command `docker volume rm {NAME OF VOLUME}`.


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
