import './App.css';
import Pessoa from './components/Pessoa';
import SayMyName from './components/SayMyName';
import Frase from './components/Frase';
import List from './components/List';
function App() {

  const nome = 'Maria';
  return (
    <div className="App">
      <Frase />
      <SayMyName nome="Lucas" />
      <SayMyName nome="João" />
      <Frase />
      <SayMyName nome={nome} />
      <Frase />
      <Pessoa
        nome="Sebastian"
        idade="300"
        profissao="Desenhista"
        foto="https://via.placeholder.com/150" />
      <List />
    </div>
  );
}

export default App;
