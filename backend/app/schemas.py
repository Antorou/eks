from datetime import datetime
from typing import Optional
from pydantic import BaseModel, field_validator


class Ingredient(BaseModel):
    name: str
    quantity: str
    unit: str


class Step(BaseModel):
    order: int
    description: str


class RecipeBase(BaseModel):
    title: str
    description: Optional[str] = None
    image_url: Optional[str] = None

    @field_validator("image_url")
    @classmethod
    def validate_image_url(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and not v.startswith(("http://", "https://")):
            raise ValueError("image_url must be an http or https URL")
        return v
    prep_time: Optional[int] = None
    cook_time: Optional[int] = None
    servings: Optional[int] = None
    ingredients: list[Ingredient] = []
    steps: list[Step] = []
    tags: list[str] = []


class RecipeCreate(RecipeBase):
    pass


class RecipeUpdate(RecipeBase):
    title: Optional[str] = None


class RecipeOut(RecipeBase):
    id: int
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}
