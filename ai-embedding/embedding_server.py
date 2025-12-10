from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer

app = FastAPI()
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

class TextInput(BaseModel):
    text: str

@app.post("/embed")
def embed(input: TextInput):
    vector = model.encode(input.text).tolist()
    return {"vector": vector}
