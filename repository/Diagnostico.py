from pyswip import Prolog, Functor
from repository.Prolog import prolog

class Diagnostico:
    def __init__(self):
        prolog.consult('diagnostico.pl')
        
        self.pertence = Functor("pertence", 2)
        self.probabilidade = Functor("probabilidade", 3)
        self.diagnostico = Functor("diagnostico", 3)
        self.diagnosticos_ordenados = Functor("diagnosticos_ordenados", 3)
        self.questao = Functor("questao", 4)