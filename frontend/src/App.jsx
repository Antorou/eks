import { Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar'
import RecipeList from './pages/RecipeList'
import RecipeDetail from './pages/RecipeDetail'
import RecipeForm from './pages/RecipeForm'

export default function App() {
  return (
    <>
      <Navbar />
      <main style={{ maxWidth: 1100, margin: '0 auto', padding: '2rem 1rem' }}>
        <Routes>
          <Route path="/" element={<RecipeList />} />
          <Route path="/recipes/:id" element={<RecipeDetail />} />
          <Route path="/new" element={<RecipeForm />} />
          <Route path="/edit/:id" element={<RecipeForm />} />
        </Routes>
      </main>
    </>
  )
}
