# Diagnósticos Médicos

Este projeto tem como objetivo realizar diagnósticos a partir de um questionário de sintomas. Também permite que um usuário realize operações CRUD (Criar, Ler, Atualizar e Deletar) para gerenciamento de pacientes.

Desenvolvida para o trabalho dois da disciplina de PPLF, do terceiro ano de Ciência da Computação na UEM.

Contribuidores:

- RA117306 Felipe Gabriel Comin Scheffel
- RA117741 Douglas Kenji Sakakibara

## Funcionalidades

As funcionalidades do sistema incluem:

- Criação de novos pacientes, com informações básicas como nome, idade, gênero, endereço e telefone
- Listagem de pacientes já cadastrados, permitindo visualizar suas informações e filtrar a consulta
- Edição dos dados dos pacientes já cadastrados
- Exclusão de pacientes do sistema
- Realização de diagnósticos a partir de um questionário de sintomas, rankeando possíveis doenças conforme as respostas dadas pelo usuário

## Tecnologias utilizadas

O projeto foi desenvolvido utilizando as seguintes tecnologias:

- Prolog: para desenvolver o questionário de sintomas e realizar os diagnósticos
- Python: para a construção da interface gráfica e integração com o Prolog
- Pyswip: biblioteca para integrar o Prolog com o Python
- Tkinter: biblioteca para a criação da interface gráfica

## Como utilizar o sistema

Para utilizar o sistema, é necessário ter o Prolog e o Python instalados em sua máquina. Além disso, é necessário instalar as bibliotecas Pyswip e Tkinter.

1. Clone o repositório do projeto para sua máquina.
2. Abra o terminal na pasta raiz do projeto.
3. Digite o seguinte comando para executar o programa:

## Como utilizar o sistema

Para utilizar o sistema, é necessário ter o Prolog e o Python instalados em sua máquina.

1. Clone o repositório do projeto para sua máquina.
2. Abra o terminal na pasta raiz do projeto.
3. Instale as dependências:
```bash
$ py -m pip install pyswip tkinter
```
3. Execute o programa:
```bash
$ py Application.py
```
