from datetime import datetime
from sqlalchemy import Column, Integer, String, Text, DateTime, JSON
from app.database import Base


class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False, index=True)
    description = Column(Text, nullable=True)
    image_url = Column(String(500), nullable=True)
    prep_time = Column(Integer, nullable=True)   # minutes
    cook_time = Column(Integer, nullable=True)   # minutes
    servings = Column(Integer, nullable=True)
    ingredients = Column(JSON, nullable=False, default=list)  # [{name, quantity, unit}]
    steps = Column(JSON, nullable=False, default=list)        # [{order, description}]
    tags = Column(JSON, nullable=False, default=list)         # [string]
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
