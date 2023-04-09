import tkinter as tk
from interface.GerenciarPacientes import GerenciarPacientes

class Application:
    def __init__(self, master):
        self.master = master
        master.title("Plataforma Médica")
        master.geometry("500x400")

        self.lbl_titulo = tk.Label(master, text="Diagnóstico Médico", font=("Arial", 16, "bold"))
        self.lbl_titulo.pack(pady=20)

        self.frame_menu = tk.Frame(master)
        self.frame_menu.pack()

        self.btn_gerenciar_pacientes = tk.Button(self.frame_menu, text="Gerenciar pacientes", command=self.gerenciar_pacientes)
        self.btn_gerenciar_pacientes.pack(pady=10)

        self.btn_realizar_diagnostico = tk.Button(self.frame_menu, text="Realizar diagnóstico", command=self.realizar_diagnostico)
        self.btn_realizar_diagnostico.pack(pady=10)

        self.btn_sair = tk.Button(self.frame_menu, text="Sair", command=master.quit)
        self.btn_sair.pack(pady=10)

        self.frame_gerenciar_pacientes = GerenciarPacientes(master)

        self.btn_voltar_gerenciar_pacientes = tk.Button(self.frame_gerenciar_pacientes, text="Voltar ao menu", command=self.voltar_menu)
        self.btn_voltar_gerenciar_pacientes.pack(pady=10)

    def gerenciar_pacientes(self):
        self.frame_menu.pack_forget()
        self.frame_gerenciar_pacientes.pack()

    def voltar_menu(self):
        self.frame_gerenciar_pacientes.pack_forget()
        self.frame_menu.pack()

    def realizar_diagnostico(self):
        # Redirecionar para tela de realização de diagnóstico
        print("Abrindo tela de realização de diagnóstico")

root = tk.Tk()
app = Application(root)
root.mainloop()
