import Item from './Item';

function List() {
  return (
    <>
      <h1>Minha Lista</h1>
      <ul>
        <Item marca="Ferrari" ano_lancamento={1985} />
        <Item marca="Ford" ano_lancamento={1964} />
        <Item marca="Lambo" ano_lancamento="1995" />
        <Item marca="Ford" ano_lancamento={1964} />
      </ul>
    </>
  )
}

export default List