const BASE = '/api/recipes'

export async function fetchRecipes(search = '', tag = '') {
  const params = new URLSearchParams()
  if (search) params.set('search', search)
  if (tag) params.set('tag', tag)
  const res = await fetch(`${BASE}/?${params}`)
  if (!res.ok) throw new Error('Failed to fetch recipes')
  return res.json()
}

export async function fetchRecipe(id) {
  const res = await fetch(`${BASE}/${id}`)
  if (!res.ok) throw new Error('Recipe not found')
  return res.json()
}

export async function createRecipe(data) {
  const res = await fetch(`${BASE}/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) throw new Error('Failed to create recipe')
  return res.json()
}

export async function updateRecipe(id, data) {
  const res = await fetch(`${BASE}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) throw new Error('Failed to update recipe')
  return res.json()
}

export async function deleteRecipe(id) {
  const res = await fetch(`${BASE}/${id}`, { method: 'DELETE' })
  if (!res.ok) throw new Error('Failed to delete recipe')
}

export async function uploadImageFile(file) {
  const form = new FormData()
  form.append('file', file)
  const res = await fetch('/api/upload/file', { method: 'POST', body: form })
  if (!res.ok) throw new Error('Failed to upload image')
  return (await res.json()).url
}

export async function uploadImageFromUrl(url) {
  const res = await fetch('/api/upload/url', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ url }),
  })
  if (!res.ok) throw new Error('Failed to import image from URL')
  return (await res.json()).url
}
