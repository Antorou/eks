import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { fetchRecipes } from '../api'
import styles from './RecipeList.module.css'

export default function RecipeList() {
  const [recipes, setRecipes] = useState([])
  const [search, setSearch] = useState('')
  const [tag, setTag] = useState('')
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    setLoading(true)
    fetchRecipes(search, tag)
      .then(setRecipes)
      .finally(() => setLoading(false))
  }, [search, tag])

  const allTags = [...new Set(recipes.flatMap(r => r.tags))]

  return (
    <div>
      <div className={styles.filters}>
        <input
          className={styles.search}
          placeholder="Search recipes or ingredients..."
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
        <div className={styles.tags}>
          <button className={tag === '' ? styles.tagActive : styles.tag} onClick={() => setTag('')}>All</button>
          {allTags.map(t => (
            <button key={t} className={t === tag ? styles.tagActive : styles.tag} onClick={() => setTag(t)}>{t}</button>
          ))}
        </div>
      </div>

      {loading ? (
        <p className={styles.empty}>Loading...</p>
      ) : recipes.length === 0 ? (
        <p className={styles.empty}>No recipes yet. <Link to="/new">Add one!</Link></p>
      ) : (
        <div className={styles.grid}>
          {recipes.map(recipe => (
            <Link to={`/recipes/${recipe.id}`} key={recipe.id} className={styles.card}>
              <div
                className={styles.img}
                style={{ backgroundImage: recipe.image_url ? `url(${recipe.image_url})` : undefined }}
              />
              <div className={styles.cardBody}>
                <h3 className={styles.cardTitle}>{recipe.title}</h3>
                {recipe.description && <p className={styles.cardDesc}>{recipe.description}</p>}
                <div className={styles.cardMeta}>
                  {recipe.prep_time && <span>{recipe.prep_time}min prep</span>}
                  {recipe.cook_time && <span>{recipe.cook_time}min cook</span>}
                  {recipe.servings && <span>{recipe.servings} servings</span>}
                </div>
                <div className={styles.cardTags}>
                  {recipe.tags.map(t => <span key={t} className={styles.tagPill}>{t}</span>)}
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
