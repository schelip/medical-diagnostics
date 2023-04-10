

%%%% Fatos

% Sintomas gerais
sintoma(febre).
sintoma(tosse).
sintoma(espirros).
sintoma(fadiga).
sintoma(perda_apetite).
sintoma(diarreia).
sintoma(vomito).
sintoma(nausea).
sintoma(dor_corpo).
sintoma(dor_cabeca).
sintoma(dor_garganta).

% Subclassificações de sintomas
caracterizacao(vomito_recorrente, vomito).
caracterizacao(vomito_esporadico, vomito).
caracterizacao(febre_alta, febre).
caracterizacao(febre_baixa, febre).
caracterizacao(dor_cabeca_forte, dor_cabeca).
caracterizacao(dor_cabeca_fraca, dor_cabeca).
caracterizacao(dor_garganta_forte, dor_garganta).
caracterizacao(dor_garganta_fraca, dor_garganta).

% Doenças e seus sintomas
doenca(gripe, 30, [febre_alta, tosse, dor_corpo, dor_cabeca]).

doenca(resfriado, 40, [febre_baixa, tosse, espirros, dor_corpo]).

doenca(enxaqueca, 12, [dor_cabeca_forte, fadiga, vomito_esporadico, dor_garganta_fraca]).

doenca(gastrite, 20, [dor_no_estomago, acidez_estomacal, ulceras, vomito, tosse]).

% Perguntas
pergunta(espirros, 'Apresenta espirros?').
pergunta(febre, 'Apresenta febre?').
pergunta(tosse, 'Apresenta tosse?').
pergunta(fadiga, 'Apresenta cansaço ou falta de energia?').
pergunta(perda_apetite, 'Apresenta perda de apetite?').
pergunta(diarreia, 'Apresenta diarreia?').
pergunta(vomito, 'Apresenta vomito?').
pergunta(nausea, 'Apresenta nausea?').
pergunta(dor_corpo, 'Apresenta dor no corpo?').
pergunta(dor_cabeca, 'Apresenta dor de cabeca?').
pergunta(dor_garganta, 'Apresenta dor de garganta?').

% Respostas simples
resposta(tosse, ['Sim', 'Nao']).
resposta(espirros, ['Sim', 'Nao']).
resposta(fadiga, ['Sim', 'Nao']).
resposta(perda_apetite, ['Sim', 'Nao']).
resposta(diarreia, ['Sim', 'Nao']).
resposta(nausea, ['Sim', 'Nao']).
resposta(dor_corpo, ['Sim', 'Nao']).

% Respostas caracterizantes
resposta(febre, ['Alta', 'Fraca', 'Nao'], [febre_alta, febre_fraca]).
resposta(vomito, ['Recorrente', 'Esporadico', 'Nao'], [vomito_recorrente, vomito_esporadico]).
resposta(dor_garganta, ['Forte', 'Fraca', 'Nao'], [dor_garganta_forte, dor_garganta_fraca]).
resposta(dor_cabeca, ['Forte', 'Fraca', 'Nao'], [dor_cabeca_forte, dor_cabeca_fraca]).


%%%%% Predicados

%% pertence(?Doenca, ?Sintoma)
%
% Estabelece a relação entre uma doença e um sintoma (caracterizado ou geral)
:- begin_tests(pertence).

test(pertence_sintoma_verdadeiro) :-
    pertence(gripe, febre_alta).

test(pertence_sintoma_falso) :-
    pertence(gripe, espirros).

test(pertence_sintoma_caracterizado_verdadeiro) :-
    pertence(gripe, dor_cabeca_forte).

test(pertence_sintoma_caracterizado_verdadeiro_geral) :-
    pertence(enxaqueca, vomito_recorrente).

:- end_tests(pertence).

pertence(Doenca, Sintoma) :-
    doenca(Doenca, _, SintomasDoenca),
    (member(Sintoma, SintomasDoenca);
     caracterizacao(Sintoma, SintomaCaracterizado),
     member(SintomaCaracterizado, SintomasDoenca)).

%% probabilidade(+Doenca, +Sintomas, -Resultado)
%
% A partir da probabilidade base e da relação entre os sintomas passados e da doença,
% calcula a probabilidade do paciente ter a doençá
:- begin_tests(probabilidade).

test(probabilidade_alta) :-
    probabilidade(gripe, [febre_alta, tosse, dor_corpo, dor_cabeca], 100).

test(probabilidade_media) :-
    probabilidade(gripe, [febre_alta, tosse, dor_corpo], 50).

test(probabilidade_baixa) :-
    probabilidade(gripe, [tosse, dor_corpo], 0).

test(probabilidade_zero) :-
    probabilidade(gripe, [tosse, dor_corpo], 0).

:- end_tests(probabilidade).

probabilidade(Doenca, Sintomas, Resultado) :-
    length(Sintomas, N_sintomas),
    doenca(Doenca, Probabilidade, SintomasDoenca),
    length(SintomasDoenca, N_sintomas_doenca),
    intersection(Sintomas, SintomasDoenca, Intersecao),
    length(Intersecao, N_intersecao),
    Resultado is Probabilidade * N_intersecao / (N_sintomas_doenca + N_sintomas).

%% diagnostico(+Sintomas, -Doenca, -Resultado)
%
% Dado um conjunto de sintomas, retorna um lista de doenças possíveis e a probabilidade de
% o paciente ter cada uma delas
:- begin_tests(diagnostico).

test(diagnostico_verdadeiro) :-
    diagnostico([febre_alta, tosse, dor_corpo, dor_cabeca], gripe, Prob),
    assertion(Prob > 0).

test(diagnostico_falso) :-
    diagnostico([tosse, dor_corpo], gripe, Prob),
    assertion(Prob =:= 0).

:- end_tests(diagnostico).

diagnostico(Sintomas, Doenca, Resultado) :-
    doenca(Doenca, _, _),
    probabilidade(Doenca, Sintomas, ResultadoRaw),
    ResultadoRaw > 0,
    format(atom(Resultado), '~2f%', ResultadoRaw).

diagnosticos_ordenados(Sintomas, Doenca, Resultado) :-
    findall([DoencaDiagnostico, ResultadoDiagnostico],
             diagnostico(Sintomas, DoencaDiagnostico, ResultadoDiagnostico),
             Diagnosticos),
    sort(Diagnosticos, DiagnosticosOrdenadosAsc),
    reverse(DiagnosticosOrdenadosAsc, DiagnosticosOrdenados),
    member([Doenca, Resultado], DiagnosticosOrdenados).

%% questao(?Sintoma, -Pergunta, -Repostas, -Caracterizacoes)
%
% Exibe a pergunta, as respostas, e, se existerem, as caracterizacoes representada
% por cada resposta, relacionadas a um sintoma
:- begin_tests(questao).

test(questao_simples) :-
    questao(nausea, Pergunta, Respostas, Caracterizacoes),
    pergunta(nausea, Pergunta),
    resposta(nausea, Respostas),
    Pergunta = 'Apresenta nausea?',
    Respostas = ['Sim', 'Nao'],
    Caracterizacoes = [].

test(questao_caracterizacoes) :-
    questao(febre, Pergunta, Respostas, Caracterizacoes),
    pergunta(febre, Pergunta),
    resposta(febre, Respostas, Caracterizacoes),
    Pergunta = 'Apresenta nausea?',
    Respostas = ['Alta', 'Fraca', 'Nao'],
    Caracterizacoes = [febre_alta, febre_fraca].

:- end_tests(questao).

questao(Sintoma, Pergunta, Respostas, Caracterizacoes) :-
    pergunta(Sintoma, Pergunta),
    (resposta(Sintoma, Respostas, Caracterizacoes) ;
     resposta(Sintoma, Respostas),
     Caracterizacoes = []).
