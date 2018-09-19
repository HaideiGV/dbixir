import React, { Component } from 'react';
import HomePage from "./components/HomePage/HomePage";
import Header from "./components/Header/Header";
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <Header />
        <HomePage />
      </div>
    );
  }
}

export default App;
