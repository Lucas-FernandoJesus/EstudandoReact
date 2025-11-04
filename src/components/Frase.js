import styles from './Frase.module.css'

function Frase() {
  return (
    <div className={styles.frase_container}>
      <p className={styles.frase_content}>
        Este é um componente de frase!
      </p>
    </div>
  )
}
export default Frase;