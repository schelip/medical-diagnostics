import tkinter as tk
from tkinter import ttk
from repository.Pacientes import *
from pyswip import Query, Variable

class GerenciarPacientes(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.lf_botoes = tk.LabelFrame(self, text="Gerenciamento de Pacientes")
        self.lf_botoes.pack(padx=20, pady=10)

        self.btn_cadastrar = tk.Button(self.lf_botoes, text="Cadastrar Paciente", command=self.popup_cadastrar_paciente)
        self.btn_cadastrar.pack(pady=10)

        self.btn_consultar = tk.Button(self.lf_botoes, text="Consultar Paciente", command=self.popup_consultar_paciente)
        self.btn_consultar.pack(pady=10)

        self.btn_alterar = tk.Button(self.lf_botoes, text="Alterar Paciente", command=self.popup_alterar_paciente)
        self.btn_alterar.pack(pady=10)

        self.btn_excluir = tk.Button(self.lf_botoes, text="Excluir Paciente", command=self.popup_excluir_paciente)
        self.btn_excluir.pack(pady=10)

        self.pacientes = Pacientes()
        
    def cadastrar_paciente(self):
        paciente = self.make_paciente()
        if paciente is None: return
        resultado = Variable()
        q = Query(self.pacientes.cadastrar_paciente(paciente["Id"], paciente["Nome"], paciente["Idade"], paciente["Genero"], paciente["Endereco"], paciente["Telefone"], resultado))
        q.nextSolution()
        self.exibir_mensagem(resultado.value)
        q.closeQuery()

    def consultar_paciente(self):
        pacientes = self.pacientes.consultar_pacientes(self.make_paciente(conferir_preenchidos=False))
        list_popup = tk.Toplevel(self)
        tree = ttk.Treeview(list_popup)
        cols = ["Id", "Nome", "Idade", "Genero","Endereco", "Telefone"]
        tree["columns"] = cols
        for col in tree["columns"]:
            tree.heading(col, text=col)
        for paciente in pacientes:
            values = [paciente.get(col, '') for col in cols]
            tree.insert("", "end", values=values)
        tree.pack()

    def alterar_paciente(self):
        paciente = self.make_paciente()
        if paciente is None: return
        resultado = Variable()
        q = Query(self.pacientes.alterar_paciente(paciente["Id"], paciente["Nome"], paciente["Idade"], paciente["Genero"], paciente["Endereco"], paciente["Telefone"], resultado))
        q.nextSolution()
        self.exibir_mensagem(resultado.value)
        q.closeQuery()

    def excluir_paciente(self):
        paciente = self.make_paciente(conferir_preenchidos=False)
        if paciente["Id"] is None:
            self.exibir_mensagem("Id é obrigatório")
            return
        resultado = Variable()
        q = Query(self.pacientes.excluir_paciente(paciente["Id"], resultado))
        q.nextSolution()
        self.exibir_mensagem(resultado.value)
        q.closeQuery()

    def popup_cadastrar_paciente(self):
        popup = self.popup_campos()
        popup.title("Cadastrar paciente")
        btn = tk.Button(popup, text="Salvar", command=self.cadastrar_paciente)
        btn.grid(row=6, column=1)

    def popup_consultar_paciente(self):
        popup = self.popup_campos()
        popup.title("Consultar paciente")
        self.genero_var.set("Qualquer")
        o_radio = tk.Radiobutton(popup, text="Qualquer", variable=self.genero_var, value="Qualquer")
        o_radio.grid(row=3, column=3)
        btn = tk.Button(popup, text="Consultar", command=self.consultar_paciente)
        btn.grid(row=6, column=1)

    def popup_alterar_paciente(self):
        popup = self.popup_campos(consulta_id=True)
        popup.title("Alterar paciente")
        btn = tk.Button(popup, text="Alterar", command=self.alterar_paciente)
        btn.grid(row=6, column=1)

    def popup_excluir_paciente(self):
        popup = self.popup_campos(consulta_id=True, desabilitar_campos=True)
        popup.title("Excluir paciente")
        
        btn = tk.Button(popup, text="Excluir", command=self.excluir_paciente)
        btn.grid(row=6, column=1)

    def popup_campos(self, consulta_id=False, desabilitar_campos=False):
        popup = tk.Toplevel(self)
        popup.geometry("400x300")

        tk.Label(popup, text="ID:").grid(row=0, column=0, padx=10, pady=10)
        self.id_var = tk.StringVar()
        id_entry = tk.Entry(popup, textvariable=self.id_var)
        id_entry.grid(row=0, column=1)

        if consulta_id:
            consultar_btn = tk.Button(popup, text="Consultar", command=self.consultar_id)
            consultar_btn.grid(row=0, column=2)

        tk.Label(popup, text="Nome:").grid(row=1, column=0, padx=10, pady=10)
        self.nome_var = tk.StringVar()
        nome_entry = tk.Entry(popup, textvariable=self.nome_var)
        nome_entry.grid(row=1, column=1)

        tk.Label(popup, text="Idade:").grid(row=2, column=0, padx=10, pady=10)
        self.idade_var = tk.StringVar()
        idade_entry = tk.Entry(popup, textvariable=self.idade_var)
        idade_entry.grid(row=2, column=1)

        tk.Label(popup, text="Gênero:").grid(row=3, column=0, padx=10, pady=10)
        self.genero_var = tk.StringVar()
        self.genero_var.set("Masculino")
        m_radio = tk.Radiobutton(popup, text="Masculino", variable=self.genero_var, value="Masculino")
        m_radio.grid(row=3, column=1)
        f_radio = tk.Radiobutton(popup, text="Feminino", variable=self.genero_var, value="Feminino")
        f_radio.grid(row=3, column=2)

        tk.Label(popup, text="Endereço:").grid(row=4, column=0, padx=10, pady=10)
        self.endereco_var = tk.StringVar()
        endereco_entry = tk.Entry(popup, textvariable=self.endereco_var)
        endereco_entry.grid(row=4, column=1)

        tk.Label(popup, text="Telefone:").grid(row=5, column=0, padx=10, pady=10)
        self.telefone_var = tk.StringVar()
        telefone_entry = tk.Entry(popup, textvariable=self.telefone_var)
        telefone_entry.grid(row=5, column=1)

        clr_btn = tk.Button(popup, text="Limpar", command=self.clear_paciente)
        clr_btn.grid(row=6, column=0)

        if desabilitar_campos:
            nome_entry.config(state='disabled')
            idade_entry.config(state='disabled')
            m_radio.config(state='disabled')
            f_radio.config(state='disabled')
            endereco_entry.config(state='disabled')
            telefone_entry.config(state='disabled')

        self.status_bar = tk.Label(popup, text="", bd=1, relief=tk.SUNKEN, anchor=tk.W)
        self.status_bar.grid(row=7, column=0, columnspan=3, pady=10, sticky="nsew")

        return popup
    
    def exibir_mensagem(self, mensagem):
        if self.status_bar:
            self.status_bar.config(text=mensagem)
            self.after(3000, lambda: self.status_bar.config(text=""))

    def make_paciente(self, conferir_preenchidos=True):
        try:
            paciente = {
                "Id": int(self.id_var.get()) if len(self.id_var.get()) > 0 else None,
                "Nome": self.nome_var.get() if len(self.nome_var.get()) > 0 else None,
                "Idade": int(self.idade_var.get()) if len(self.idade_var.get()) > 0 else None,
                "Genero": self.genero_var.get() if len(self.genero_var.get()) > 0 and self.genero_var.get() != "Qualquer" else None,
                "Endereco": self.endereco_var.get() if len(self.endereco_var.get()) > 0 else None,
                "Telefone": self.telefone_var.get() if len(self.telefone_var.get()) > 0 else None
            }
            if conferir_preenchidos and any([v is None for v in paciente.values()]):
                self.exibir_mensagem("Por favor preencha todos os campos")
            else: return paciente
        except ValueError:
                self.exibir_mensagem("Algum valor está inválido")
    
    def clear_paciente(self):
        self.id_var.set("")
        self.nome_var.set("")
        self.idade_var.set("")
        self.genero_var.set("Masculino")
        self.endereco_var.set("")
        self.telefone_var.set("")
    
    def consultar_id(self):
        if len(self.id_var.get()) == 0:
            self.exibir_mensagem("Id é obrigatório")
        else:
            resultado = self.pacientes.consultar_paciente_id(self.id_var.get())
            if resultado:
                self.nome_var.set(resultado['Nome'])
                self.idade_var.set(resultado['Idade'])
                self.genero_var.set(resultado['Genero'])
                self.endereco_var.set(resultado['Endereco'])
                self.telefone_var.set(resultado['Telefone'])
            else:
                self.exibir_mensagem("Nenhum paciente encontrado.")