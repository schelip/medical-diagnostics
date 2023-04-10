

%%%% Fatos

% Sintomas gerais
sintoma(sede).
sintoma(vomitos).
sintoma(fraqueza).
sintoma(fome).
sintoma(dor_de_cabeca).
sintoma(irritabilidade).
sintoma(sensibilidade).
sintoma(dores_no_peito).
sintoma(tontura).
sintoma(falta_de_ar).
sintoma(desconforto_no_peito).
sintoma(tristeza).
sintoma(alteracao_no_humor).
sintoma(visao_alterada).
sintoma(formigamento_no_corpo).
sintoma(febre).
sintoma(dor_nos_olhos).
sintoma(manchas_vermelhas).
sintoma(dores_no_corpo).
sintoma(coriza).
sintoma(espirros).
sintoma(tosse).

% Subclassificações de sintomas
caracterizacao(vomitos_recorrente, vomitos).
caracterizacao(vomitos_esporadico, vomitos).
caracterizacao(febre_alta, febre).
caracterizacao(febre_baixa, febre).
caracterizacao(dor_de_cabeca_forte, dor_de_cabeca).
caracterizacao(dor_de_cabeca_fraca, dor_de_cabeca).
caracterizacao(tosse_seca, tosse).
caracterizacao(tosse_com_catarro, tosse).


doenca(diabetes,55,[sede,vomitos_recorrente,fraqueza,fome]).
doenca(enxaqueca,45,[vomitos_esporadico,dor_de_cabeca_forte,irritabilidade,sensibilidade]).
doenca(hipertensao,40,[dores_no_peito,dor_de_cabeca_forte,fraqueza,tontura]).
doenca(asma,24,[falta_de_ar,tosse_seca,fraqueza,desconforto_no_peito]).
doenca(depressao,60,[tristeza,fraqueza,alteracao_no_humor,irritabilidade]).
doenca(avc,45,[dor_de_cabeca_forte,visao_alterada,formigamento_no_corpo,fraqueza]).
doenca(dengue,65,[febre_alta,dor_de_cabeca_fraca,dor_nos_olhos,manchas_vermelhas]).
doenca(gripe,70,[febre_alta,dores_no_corpo,coriza,tosse_com_catarro]).
doenca(resfriado,80,[tosse_com_catarro,febre_baixa,coriza,espirros]).
doenca(bronquite,20,[tosse_seca,falta_de_ar,desconforto_no_peito,coriza]).

pergunta(espirros, 'Apresenta espirros ?').
pergunta(febre, 'Apresenta febre?').
pergunta(tosse, 'Apresenta tosse?').
pergunta(vomitos, 'Apresenta vomito?').
pergunta(dor_de_cabeca, 'Apresenta dor de cabeça?').
pergunta(dores_no_corpo, 'Apresenta dores no corpo? ').
pergunta(sede, 'Sente muita sede?').
pergunta(fraqueza, 'Apresenta uma fraqueza em seu corpo').
pergunta(mudancas_no_comportamento, 'Apresenta mudancas no seu comportamento?').
pergunta(dores_no_peito,'Apresenta dores no peito?').
pergunta(falta_de_ar,'Apresenta falta de ar?').
pergunta(tristeza,'Apresenta uma tristeza recorrente?').
pergunta(alteracao_no_humor,'Apresenta alteracoes no humor?').
pergunta(visao_alterada, 'Apresenta alterasoes na visao?').
pergunta(formigamento_no_corpo,'Apresenta formigamento no corpo?').
pergunta(dor_nos_olhos, 'Apresenta dor nos olhos?').
pergunta(coriza,'Apresenta coriza?').
pergunta(desconforto_no_peito, 'Apresenta algum desconforto no peito?').
pergunta(fome,'Notou se sente fome mais vezes ao dia do que de costume?').
pergunta(tontura,'Apresenta tontura?').
pergunta(irritabilidade,'Ultimimamente vem se sentido irratado(a) durante o dia?').
pergunta(manchas_vermelhas,'Apresenta manchas vermelhas no corpo?').
pergunta(sensibilidade,'Sente sensibilidade a luz,sons e cheiros?').

%Respostas simples
resposta(espirros, ['Sim','Nao']).
resposta(dores_no_corpo, ['Sim','Nao']).
resposta(sede, ['Sim','Nao']).
resposta(fraqueza, ['Sim','Nao']).
resposta(mudancas_no_comportamento, ['Sim','Nao']).
resposta(dores_no_peito, ['Sim','Nao']).
resposta(falta_de_ar, ['Sim','Nao']).
resposta(tristeza, ['Sim','Nao']).
resposta(alteracao_no_humor, ['Sim','Nao']).
resposta(visao_alterada, ['Sim','Nao']).
resposta(formigamento_no_corpo, ['Sim','Nao']).
resposta(dor_nos_olhos, ['Sim','Nao']).
resposta(coriza, ['Sim','Nao']).
resposta(desconforto_no_peito, ['Sim','Nao']).
resposta(fome, ['Sim','Nao']).
resposta(tontura, ['Sim','Nao']).
resposta(irritabilidade, ['Sim','Nao']).
resposta(manchas_vermelhas, ['Sim','Nao']).
resposta(sensibilidade, ['Sim','Nao']).

%Respostas caracterizadas
resposta(febre, ['Alta', 'Fraca', 'Nao'], [febre_alta, febre_fraca]).
resposta(vomitos, ['Recorrente', 'Esporadico', 'Nao'], [vomitos_recorrente, vomitos_esporadico]).
resposta(dor_de_cabeca, ['Forte', 'Fraca', 'Nao'], [dor_de_cabeca_forte, dor_de_cabeca_fraca]).
resposta(tosse, ['Seca', 'Catarro', 'Nao'], [tosse_com_catarro, tosse_seca]).


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
