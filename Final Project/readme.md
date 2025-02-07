# Hoot Generative Identity - README

## English

This project was developed during the Short Course on Generative Design for Identity Design at ESMAD, Polytechnic of Porto.  
Throughout the course, participants were introduced to experimental concepts and techniques for using Large Language Models (LLMs) to generate Processing code, thereby manipulating each participant’s chosen visual identity.  
I chose to work with a visual identity called **Hoot**, originally created during the Design Fundamentals course unit.  
The main goal of this project was to build a program that uses generative design to produce assets which can be reused in various graphic and multimedia contexts.

This folder contains two files:

- **`hoot_initial_design.pde`** – Demonstrates the first iteration of this design. It renders a black background, displays the original logo colors, and includes an interactive feature where the logo’s eyes follow the mouse cursor.  
- **`hoot_final_design.pde`** – Contains the final version of the project, showcasing a wide range of features accessible via the commands below:

**Keys**:  
- **f**: Toggle full screen.  
- **c**: Capture the current frame in SVG and PNG.  
- **r**: Randomize the background, grid, eyes, and logo colors.  
- **s**: Toggle the type of shape drawn in the cells:  
  - 0 - “Cut-out” triangle  
  - 1 - Organic ellipse (organic outline with 20 points)  
  - 2 - Abstract quadrilateral (distorted quadrilateral)  
  - 3 - Abstract blob (organic shape with 8 points)  
  - 4 - Abstract star (irregular star with 10 points)  
- **0**: Reset to the initial configuration.  

**Click/Drag**: Zoom or trigger the wave animation (the shapes morph smoothly as the wave passes).

---

## Português

Este trabalho foi feito no Curso de Curta Duração em Design Generativo para Design de Identidade (DGDI), na ESMAD, Politécnico do Porto.  
Ao longo do curso foram introduzidos conceitos experimentais e formas de utilizar grandes modelos de linguagem (LLM), para desenvolver código em Processing, e desta forma manipular a identidade visual escolhida por cada formando.  
No meu caso, escolhi uma identidade visual desenvolvida no âmbito da Unidade Curricular de Fundamentos de Design, a Hoot.  
O objetivo do projeto desenvolvido foi criar um programa que explora o design generativo para a criação de "assets" que podem ser reutilizados na produção de outros produtos gráficos e multimédia.

Nesta pasta existem dois ficheiros.  
O ficheiro `hoot_initial_design.pde` contém a primeira iteração deste design. Renderiza um ecrã de fundo preto, o logo com o esquema cromático original, e os “olhos” do logo seguem o rato.

O ficheiro `hoot_final_design.pde` contém a versão final do projeto, incluindo um conjunto avançado de funcionalidades que podem ser acedidas através dos seguintes comandos:

**Teclas**:  
- **f**: Alternar full screen.  
- **c**: Capturar o frame atual em SVG e PNG.  
- **r**: Randomizar as cores do fundo, da grelha, dos olhos e do logo.  
- **s**: Alternar o tipo de forma desenhada nas células:  
  - 0 - Triângulo “recortado”  
  - 1 - Elipse orgânica (contorno orgânico com 20 pontos)  
  - 2 - Quadrilátero abstrato (quadrilátero distorcido)  
  - 3 - Blob abstrato (forma orgânica com 8 pontos)  
  - 4 - Estrela abstrata (estrela irregular com 10 pontos)  
- **0**: Repor a configuração inicial.

**Clique/Arraste**: Zoom ou desencadear a animação em onda (as formas sofrem morfismo suavemente enquanto a onda passa).

---

## Folder Structure

Below is an example of how the project’s folder structure might look:

hoot_project/ ├── data/ │ ├── logo.svg │ └── olho.svg ├── captures/ (where SVG/PNG captures may be stored) ├── hoot_initial_design.pde └── hoot_final_design.pde

