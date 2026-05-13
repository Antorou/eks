# Training EKS

here is a full-stack recipe management app that we're gonna use for practicing deploying on EKS.

## architecture

```
Browser
  └── Frontend (React + nginx) :3000
        └── /api/* → Backend (FastAPI) :8000
              ├── PostgreSQL :5432   (recipes data)
              └── MinIO :9000        (image storage, S3-compatible)
```

| Service | Role |
|---|---|
| **frontend** | React SPA built by Vite, served by nginx. Proxies `/api/` to the backend. |
| **backend** | FastAPI app. REST API for recipes + image upload (Auto-creates DB tables on startup). |
| **db** | PostgreSQL. Stores recipes (title, ingredients, steps, tags, image URL…). |
| **minio** | S3-compatible object store. Stores uploaded recipe images in the `recipe-box` bucket. |
| **minio-init** | One-shot container that creates the `recipe-box` bucket and sets it public on first start. |

---

## how to run locally with Docker

**Prerequisites:** Docker + Docker Compose installed.

```bash
docker compose up --build
```

Postgres and MinIO start first (healthchecks gate everything else). The backend then starts and auto-creates the DB tables. The frontend is built and served by nginx.

### URLs

| Service | URL | Credentials |
|---|---|---|
| Frontend | http://localhost:3000 | — |
| Backend API docs | http://localhost:8000/docs | — |
| MinIO console | http://localhost:9001 | `minioadmin` / `minioadmin` |
| Postgres | `localhost:5432` | user: `postgres`, pass: `postgres`, db: `recipebox` |

### commands

```bash
# follow logs for one service
docker compose logs -f backend

# rebuild and restart one service after a code change
docker compose up --build backend

# stop all services (keeps volumes — data is preserved)
docker compose down

# stop and wipe everything (DB + MinIO data deleted)
docker compose down -v
```

---

## database

### connect from the terminal

```bash
# option 1 — via Docker, no local install needed
docker compose exec db psql -U postgres -d recipebox

# option 2 — via local psql
psql -h localhost -p 5432 -U postgres -d recipebox
# password: postgres
```

### schema — `recipes` table

| Column | Type | Notes |
|---|---|---|
| `id` | integer | primary key |
| `title` | varchar(255) | required |
| `description` | text | optional |
| `image_url` | varchar(500) | http/https only, set after image upload |
| `prep_time` | integer | minutes |
| `cook_time` | integer | minutes |
| `servings` | integer | |
| `ingredients` | JSON | array of `{name, quantity, unit}` |
| `steps` | JSON | array of `{order, description}` |
| `tags` | JSON | array of strings |
| `created_at` | timestamp | auto-set |
| `updated_at` | timestamp | auto-updated |

---

## image storage (local)

MinIO is an S3-compatible object store running locally. Images are stored in the `recipe-box` bucket and served publicly at `http://localhost:9000/recipe-box/<key>`.

### MinIO console

Open http://localhost:9001 — login with `minioadmin` / `minioadmin`. You can browse, upload, and delete objects from the UI.

### minio CLI (mc)

```bash
# open a shell in the minio/mc container
docker compose run --rm minio-init /bin/sh

# inside — list bucket contents
mc alias set local http://minio:9000 minioadmin minioadmin
mc ls local/recipe-box
mc ls local/recipe-box/recipes/

# delete all images
mc rm --recursive --force local/recipe-box/recipes/
```

### how image upload works

The backend exposes two endpoints:

- `POST /api/upload/file` — upload an image file directly 
- `POST /api/upload/url` — fetch an image from a public URL and store it 

Both endpoints return `{ "url": "..." }` pointing to the public MinIO URL, which is saved on the recipe record.

---

## API reference

Full interactive docs at http://localhost:8000/docs

| Method | Path | Description |
|---|---|---|
| GET | `/api/recipes/` | List all recipes |
| GET | `/api/recipes/{id}` | Get a single recipe |
| POST | `/api/recipes/` | Create a recipe |
| PUT | `/api/recipes/{id}` | Update a recipe |
| DELETE | `/api/recipes/{id}` | Delete a recipe |
| POST | `/api/upload/file` | Upload an image file |
| POST | `/api/upload/url` | Import an image from a public URL |
| GET | `/health` | Health check |
| GET | `/metrics` | Prometheus metrics |

## credits

Antoine Rousselot - [github](https://github.com/Antorou)

