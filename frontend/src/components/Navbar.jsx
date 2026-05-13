import { Link } from 'react-router-dom'
import styles from './Navbar.module.css'

export default function Navbar() {
  return (
    <nav className={styles.nav}>
      <Link to="/" className={styles.brand}>Recipe Box</Link>
      <Link to="/new" className={styles.addBtn}>+ New Recipe</Link>
    </nav>
  )
}
