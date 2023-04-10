import tkinter as tk
from interface.GerenciarPacientes import GerenciarPacientes
from interface.RealizarDiagnostico import RealizarDiagnostico

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

        self.btn_realizar_diagnostico = tk.Button(self.frame_menu, text="Realizar diagnóstico", command=self.exibir_popup_aviso)
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

    def exibir_popup_aviso(self):
        self.popup_aviso = tk.Toplevel(self.master)
        self.popup_aviso.title("Atenção")
        titulo = tk.Label(self.popup_aviso, text="Atenção", font=("Arial", 16, "bold"))
        titulo.pack(pady=20)
        aviso = tk.Label(self.popup_aviso, text="O resultado do protótipo é apenas informativo. O paciente deve consultar um médico para obter um diagnóstico correto e preciso.")
        aviso.pack(padx=20, pady=10)
        confirm_button = tk.Button(self.popup_aviso, text="Entendi", command=self.realizar_diagnostico)
        confirm_button.pack(pady=10)

    def realizar_diagnostico(self):
        self.popup_aviso.destroy()
        self.popup_realizar_diagnostico = tk.Toplevel(self.master)
        self.frame_realizar_diagnostico = RealizarDiagnostico(self.popup_realizar_diagnostico)


root = tk.Tk()
app = Application(root)
root.mainloop()
