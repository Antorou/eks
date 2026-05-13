import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { fetchRecipe, createRecipe, updateRecipe } from '../api'
import ImageUpload from '../components/ImageUpload'
import styles from './RecipeForm.module.css'

const emptyForm = {
  title: '', description: '', image_url: '',
  prep_time: '', cook_time: '', servings: '',
  ingredients: [{ name: '', quantity: '', unit: '' }],
  steps: [{ order: 1, description: '' }],
  tags: '',
}

export default function RecipeForm() {
  const { id } = useParams()
  const navigate = useNavigate()
  const isEdit = Boolean(id)
  const [form, setForm] = useState(emptyForm)
  const [loading, setLoading] = useState(isEdit)

  useEffect(() => {
    if (!isEdit) return
    fetchRecipe(id).then(r => {
      setForm({
        ...r,
        prep_time: r.prep_time ?? '',
        cook_time: r.cook_time ?? '',
        servings: r.servings ?? '',
        tags: r.tags.join(', '),
        ingredients: r.ingredients.length ? r.ingredients : emptyForm.ingredients,
        steps: r.steps.length ? r.steps : emptyForm.steps,
      })
      setLoading(false)
    })
  }, [id, isEdit])

  function setField(field, value) {
    setForm(f => ({ ...f, [field]: value }))
  }

  function setIngredient(i, field, value) {
    const updated = form.ingredients.map((ing, idx) => idx === i ? { ...ing, [field]: value } : ing)
    setField('ingredients', updated)
  }

  function addIngredient() {
    setField('ingredients', [...form.ingredients, { name: '', quantity: '', unit: '' }])
  }

  function removeIngredient(i) {
    setField('ingredients', form.ingredients.filter((_, idx) => idx !== i))
  }

  function setStep(i, value) {
    const updated = form.steps.map((s, idx) => idx === i ? { ...s, description: value } : s)
    setField('steps', updated)
  }

  function addStep() {
    setField('steps', [...form.steps, { order: form.steps.length + 1, description: '' }])
  }

  function removeStep(i) {
    const updated = form.steps.filter((_, idx) => idx !== i).map((s, idx) => ({ ...s, order: idx + 1 }))
    setField('steps', updated)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    const payload = {
      ...form,
      prep_time: form.prep_time ? Number(form.prep_time) : null,
      cook_time: form.cook_time ? Number(form.cook_time) : null,
      servings: form.servings ? Number(form.servings) : null,
      tags: form.tags.split(',').map(t => t.trim()).filter(Boolean),
      ingredients: form.ingredients.filter(i => i.name),
      steps: form.steps.filter(s => s.description),
    }
    if (isEdit) {
      await updateRecipe(id, payload)
      navigate(`/recipes/${id}`)
    } else {
      const created = await createRecipe(payload)
      navigate(`/recipes/${created.id}`)
    }
  }

  if (loading) return <p className={styles.status}>Loading...</p>

  return (
    <div className={styles.wrapper}>
      <h1 className={styles.title}>{isEdit ? 'Edit Recipe' : 'New Recipe'}</h1>
      <form onSubmit={handleSubmit} className={styles.form}>

        <div className={styles.section}>
          <h2 className={styles.sectionTitle}>Basic Info</h2>
          <label className={styles.label}>Title *
            <input required className={styles.input} value={form.title} onChange={e => setField('title', e.target.value)} />
          </label>
          <label className={styles.label}>Description
            <textarea className={styles.textarea} value={form.description} onChange={e => setField('description', e.target.value)} rows={3} />
          </label>
          <div className={styles.label}>Image
            <ImageUpload value={form.image_url} onChange={url => setField('image_url', url)} />
          </div>
          <div className={styles.row}>
            <label className={styles.label}>Prep time (min)
              <input type="number" className={styles.input} value={form.prep_time} onChange={e => setField('prep_time', e.target.value)} min={0} />
            </label>
            <label className={styles.label}>Cook time (min)
              <input type="number" className={styles.input} value={form.cook_time} onChange={e => setField('cook_time', e.target.value)} min={0} />
            </label>
            <label className={styles.label}>Servings
              <input type="number" className={styles.input} value={form.servings} onChange={e => setField('servings', e.target.value)} min={1} />
            </label>
          </div>
          <label className={styles.label}>Tags (comma separated)
            <input className={styles.input} value={form.tags} onChange={e => setField('tags', e.target.value)} placeholder="italian, pasta, quick" />
          </label>
        </div>

        <div className={styles.section}>
          <h2 className={styles.sectionTitle}>Ingredients</h2>
          {form.ingredients.map((ing, i) => (
            <div key={i} className={styles.ingredientRow}>
              <input className={styles.input} placeholder="Quantity" value={ing.quantity} onChange={e => setIngredient(i, 'quantity', e.target.value)} />
              <input className={styles.input} placeholder="Unit" value={ing.unit} onChange={e => setIngredient(i, 'unit', e.target.value)} />
              <input className={styles.inputFlex} placeholder="Ingredient name" value={ing.name} onChange={e => setIngredient(i, 'name', e.target.value)} />
              <button type="button" className={styles.removeBtn} onClick={() => removeIngredient(i)}>✕</button>
            </div>
          ))}
          <button type="button" className={styles.addBtn} onClick={addIngredient}>+ Add ingredient</button>
        </div>

        <div className={styles.section}>
          <h2 className={styles.sectionTitle}>Steps</h2>
          {form.steps.map((step, i) => (
            <div key={i} className={styles.stepRow}>
              <span className={styles.stepNum}>{i + 1}</span>
              <textarea className={styles.textareaFlex} rows={2} value={step.description} onChange={e => setStep(i, e.target.value)} placeholder="Describe this step..." />
              <button type="button" className={styles.removeBtn} onClick={() => removeStep(i)}>✕</button>
            </div>
          ))}
          <button type="button" className={styles.addBtn} onClick={addStep}>+ Add step</button>
        </div>

        <div className={styles.formActions}>
          <button type="button" className={styles.cancelBtn} onClick={() => navigate(-1)}>Cancel</button>
          <button type="submit" className={styles.submitBtn}>{isEdit ? 'Save changes' : 'Create recipe'}</button>
        </div>
      </form>
    </div>
  )
}
