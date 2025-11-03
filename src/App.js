import './App.css';
import HelloWorld from './components/HelloWorld';

function App() {
  const name = 'lucas';
  const newname = name.toUpperCase();
  const url = 'https://via.placeholder.com/150';
  return (
    <div className="App">
      <h1>Olá, {newname} !</h1>
      <img src={url} alt="Minha Imagem" />
      <HelloWorld />
    </div>
  );
}

export default App;
