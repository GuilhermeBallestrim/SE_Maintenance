from pydantic import BaseModel


class UsuarioResponse(BaseModel):
    id_usuario: int
    nome: str
    email: str
    perfil: str

    class Config:
        from_attributes = True