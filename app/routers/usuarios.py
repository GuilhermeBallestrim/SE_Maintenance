from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from database.connection import get_db
from models.usuario import Usuario
from schemas.usuario import UsuarioResponse


router = APIRouter(
    prefix="/usuarios",
    tags=["Usuários"]
)


@router.get("/", response_model=list[UsuarioResponse])
def listar_usuarios(db: Session = Depends(get_db)):
    usuarios = db.query(Usuario).all()

    return usuarios