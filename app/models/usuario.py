from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from database.base import Base


class Usuario(Base):
    __tablename__ = "usuarios"

    id_usuario: Mapped[int] = mapped_column(
        primary_key=True
    )

    nome: Mapped[str] = mapped_column(
        String(150),
        nullable=False
    )

    email: Mapped[str] = mapped_column(
        String(150),
        nullable=False,
        unique=True
    )

    senha: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    perfil: Mapped[str] = mapped_column(
        String(50),
        nullable=False
    )