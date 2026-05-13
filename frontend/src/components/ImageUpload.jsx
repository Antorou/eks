import { useState, useRef } from 'react'
import { uploadImageFile, uploadImageFromUrl } from '../api'
import styles from './ImageUpload.module.css'

export default function ImageUpload({ value, onChange }) {
  const [mode, setMode] = useState('file')
  const [urlInput, setUrlInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const fileRef = useRef()

  async function handleFile(e) {
    const file = e.target.files[0]
    if (!file) return
    setLoading(true)
    setError('')
    try {
      const url = await uploadImageFile(file)
      onChange(url)
    } catch {
      setError('Upload failed.')
    } finally {
      setLoading(false)
    }
  }

  async function handleUrlImport() {
    if (!urlInput) return
    setLoading(true)
    setError('')
    try {
      const url = await uploadImageFromUrl(urlInput)
      onChange(url)
      setUrlInput('')
    } catch {
      setError('Failed to import from URL.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className={styles.wrapper}>
      <div className={styles.tabs}>
        <button type="button" className={mode === 'file' ? styles.tabActive : styles.tab} onClick={() => setMode('file')}>Upload file</button>
        <button type="button" className={mode === 'url' ? styles.tabActive : styles.tab} onClick={() => setMode('url')}>From URL</button>
      </div>

      {mode === 'file' ? (
        <div className={styles.dropzone} onClick={() => fileRef.current.click()}>
          <input ref={fileRef} type="file" accept="image/*" style={{ display: 'none' }} onChange={handleFile} />
          {loading ? <span>Uploading...</span> : <span>Click to choose an image</span>}
        </div>
      ) : (
        <div className={styles.urlRow}>
          <input
            className={styles.urlInput}
            placeholder="https://example.com/image.jpg"
            value={urlInput}
            onChange={e => setUrlInput(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && (e.preventDefault(), handleUrlImport())}
          />
          <button type="button" className={styles.importBtn} onClick={handleUrlImport} disabled={loading}>
            {loading ? '...' : 'Import'}
          </button>
        </div>
      )}

      {error && <p className={styles.error}>{error}</p>}

      {value && (
        <div className={styles.preview}>
          <img src={value} alt="Preview" />
          <button type="button" className={styles.clearBtn} onClick={() => onChange('')}>Remove</button>
        </div>
      )}
    </div>
  )
}
