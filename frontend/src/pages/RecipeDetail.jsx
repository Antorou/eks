import { useState, useEffect } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { fetchRecipe, deleteRecipe } from '../api'
import styles from './RecipeDetail.module.css'

export default function RecipeDetail() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [recipe, setRecipe] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchRecipe(id)
      .then(setRecipe)
      .finally(() => setLoading(false))
  }, [id])

  async function handleDelete() {
    if (!confirm('Delete this recipe?')) return
    await deleteRecipe(id)
    navigate('/')
  }

  if (loading) return <p className={styles.status}>Loading...</p>
  if (!recipe) return <p className={styles.status}>Recipe not found.</p>

  return (
    <div className={styles.wrapper}>
      {recipe.image_url && (
        <img src={recipe.image_url} alt={recipe.title} className={styles.hero} />
      )}

      <div className={styles.header}>
        <div>
          <h1 className={styles.title}>{recipe.title}</h1>
          {recipe.description && <p className={styles.desc}>{recipe.description}</p>}
        </div>
        <div className={styles.actions}>
          <Link to={`/edit/${recipe.id}`} className={styles.editBtn}>Edit</Link>
          <button onClick={handleDelete} className={styles.deleteBtn}>Delete</button>
        </div>
      </div>

      <div className={styles.meta}>
        {recipe.prep_time && <div className={styles.metaItem}><span>Prep</span><strong>{recipe.prep_time} min</strong></div>}
        {recipe.cook_time && <div className={styles.metaItem}><span>Cook</span><strong>{recipe.cook_time} min</strong></div>}
        {recipe.servings && <div className={styles.metaItem}><span>Servings</span><strong>{recipe.servings}</strong></div>}
      </div>

      {recipe.tags.length > 0 && (
        <div className={styles.tags}>
          {recipe.tags.map(t => <span key={t} className={styles.tagPill}>{t}</span>)}
        </div>
      )}

      <div className={styles.sections}>
        <section>
          <h2 className={styles.sectionTitle}>Ingredients</h2>
          <ul className={styles.ingredients}>
            {recipe.ingredients.map((ing, i) => (
              <li key={i}>
                <span className={styles.qty}>{ing.quantity} {ing.unit}</span> {ing.name}
              </li>
            ))}
          </ul>
        </section>

        <section>
          <h2 className={styles.sectionTitle}>Steps</h2>
          <ol className={styles.steps}>
            {recipe.steps.map((step, i) => (
              <li key={i}>{step.description}</li>
            ))}
          </ol>
        </section>
      </div>
    </div>
  )
}
