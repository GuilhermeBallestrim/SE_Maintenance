from database.connection import SessionLocal
from models.setor import Setor


db = SessionLocal()

setores = db.query(Setor).all()

for setor in setores:
    print(
        setor.id_setor,
        setor.nome
    )

db.close()