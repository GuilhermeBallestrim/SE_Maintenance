from fastapi import FastAPI

from routers.usuarios import router as usuarios_router


app = FastAPI(
    title="SE Maintenance API",
    version="1.0.0"
)


app.include_router(usuarios_router)