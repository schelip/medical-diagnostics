from pyswip import Prolog, Functor, call

prolog = Prolog()

class PacienteModel:
    def __init__(self, id, nome, idade, genero, endereco, telefone):
        self.id = id
        self.nome = nome
        self.idade = idade
        self.genero = genero
        self.endereco = endereco
        self.telefone = telefone

class Pacientes:
    def __init__(self):
        prolog.consult("pacientes.pl")

        main = Functor("main", 0)

        self.definir_arquivo_pacientes = Functor("definir_arquivo_pacientes", 1)
        self.carregar_pacientes = Functor("carregar_pacientes", 0)
        self.salvar_pacientes = Functor("salvar_pacientes", 0)
        self.cadastrar_paciente = Functor("cadastrar_paciente", 7)
        self.alterar_paciente = Functor("alterar_paciente", 7)
        self.excluir_paciente = Functor("excluir_paciente", 2)

        call(main())

    def consultar_paciente_id(self, id):
        result =  list(prolog.query(f"paciente({id},Nome, Idade, Genero, Endereco, Telefone)"))
        if len(result) > 0:
            return result[0]
        return None
    
    def consultar_pacientes(self, paciente):
        query = []
        query.append(f"{paciente['Id']}" if paciente["Id"] is not None else "Id")
        query.append(f"'{paciente['Nome']}'" if paciente["Nome"] is not None else "Nome")
        query.append(f"{paciente['Idade']}" if paciente["Idade"] is not None else "Idade")
        query.append(f"'{paciente['Genero']}'" if paciente["Genero"] is not None else "Genero")
        query.append(f"'{paciente['Endereco']}'" if paciente["Endereco"] is not None else "Endereco")
        query.append(f"'{paciente['Telefone']}'" if paciente["Telefone"] is not None else "Telefone")
        query = ', '.join(query)
        pacientes = list(prolog.query("paciente(" + query + ")"))
        [p.update({k: v for k, v in paciente.items() if v is not None}) for p in pacientes]
        print(pacientes)
        return pacientes