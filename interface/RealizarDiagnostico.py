import tkinter as tk
from tkinter import ttk
from repository.Diagnostico import Diagnostico
from pyswip import Query, Variable

class RealizarDiagnostico:
    def __init__(self, master):
        self.master = master

        self.diagnostico = Diagnostico()
        
        self.sintomas = []
        self.perguntas = []
        self.respostas = []
        self.caracterizacoes = {}
        self.carregar_perguntas()

        self.respostas_questionario = []

        self.indice_pergunta_atual = 0
        
        self.criar_widgets()

    def carregar_perguntas(self):
        sintoma = Variable()
        pergunta = Variable()
        respostas = Variable()
        caracterizacoes = Variable()

        q = Query(self.diagnostico.questao(sintoma, pergunta, respostas, caracterizacoes))
        while q.nextSolution():
            self.sintomas.append(sintoma.value)
            self.perguntas.append(pergunta.value)
            self.respostas.append([resposta.value for resposta in respostas.value])
            self.caracterizacoes.update({sintoma.value: caracterizacoes.value})
        q.closeQuery()

    def carregar_resultado(self):
        self.tree.delete(*self.tree.get_children())

        doenca = Variable()
        resultado = Variable()

        q = Query(self.diagnostico.diagnosticos_ordenados(self.respostas_questionario, doenca, resultado))
        while q.nextSolution():
            self.tree.insert("", "end", text="", values=(doenca.value, resultado.value))
        q.closeQuery()

    def criar_widgets(self):
        self.questions_frame = ttk.Frame(self.master, padding="3 3 12 12")
        self.questions_frame.grid(column=0, row=0, sticky=(tk.N, tk.W, tk.S))
        self.questions_frame.columnconfigure(0, weight=1)
        self.questions_frame.rowconfigure(0, weight=1)

        # label para pergunta
        self.pergunta_label = ttk.Label(self.questions_frame, text=self.perguntas[self.indice_pergunta_atual])
        self.pergunta_label.grid( row=0, column=0, padx=10, pady=10, sticky=(tk.W, tk.E))
        self.resposta_var = tk.StringVar()
        self.atualizar_questao()

        # botão para ir para a próxima pergunta
        self.botao_proxima_pergunta = ttk.Button(self.questions_frame, text="Próxima", command=self.proxima_pergunta)
        self.botao_proxima_pergunta.grid(row=2, column=0, padx=10, pady=10, sticky=(tk.W, tk.E))

        # tabela para resultados
        self.tree_frame = ttk.Frame(self.master, padding="3 3 12 12")
        self.tree_frame.grid(column=0, row=1, sticky=(tk.N, tk.W, tk.E, tk.S))
        self.tree_frame.columnconfigure(0, weight=1)
        self.tree_frame.rowconfigure(0, weight=1)
        self.tree = ttk.Treeview(self.tree_frame, columns=('Nome', 'Probabilidade'), show='headings')
        self.tree.heading('Nome', text='Nome')
        self.tree.heading('Probabilidade', text='Probabilidade')
        self.tree.pack()

    def atualizar_questao(self):
        self.pergunta_label.config(text=self.perguntas[self.indice_pergunta_atual])
        self.resposta_var.set("")
        for widget in self.questions_frame.grid_slaves():
            if int(widget.grid_info()["row"]) == 1:
                widget.destroy()
        for i, resposta in enumerate(self.respostas[self.indice_pergunta_atual]):
            ttk.Radiobutton(self.questions_frame, text=resposta, variable=self.resposta_var, value=resposta
                            ).grid(row=1, column=i, padx=10, pady=10, sticky=tk.W)
        self.resposta_var.set(self.respostas[self.indice_pergunta_atual][-1])

    def mostrar_resultado(self):
        self.pergunta_label.config(text="Resultado")
        self.resposta_var.set("")
        for widget in self.questions_frame.grid_slaves():
            row = int(widget.grid_info()["row"])
            if row == 1 or row == 2:
                widget.destroy()

    def proxima_pergunta(self):
        sintoma = self.sintomas[self.indice_pergunta_atual]
        respostas = self.respostas[self.indice_pergunta_atual]

        resposta = self.resposta_var.get()
        idx = respostas.index(resposta)

        if idx != len(respostas) - 1:
            print(self.caracterizacoes)
            if self.caracterizacoes.get(sintoma.value) is not None:
                caracterizacoes = self.caracterizacoes.get(sintoma.value)
                self.respostas_questionario.append(caracterizacoes[idx])
            else:
                self.respostas_questionario.append(sintoma)

        # atualiza a tabela
        self.carregar_resultado()

        # atualiza pergunta e respostas
        self.indice_pergunta_atual += 1
        if self.indice_pergunta_atual >= len(self.perguntas):
            self.mostrar_resultado()
        else:
            self.atualizar_questao()
