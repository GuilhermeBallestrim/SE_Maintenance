from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from database.base import Base


class Setor(Base):
    __tablename__ = "setores"

    id_setor: Mapped[int] = mapped_column(
        primary_key=True
    )

    nome: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        unique=True
    )