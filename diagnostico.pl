% Sistema de diagnósticos

%%%% Fatos

% Sintomas gerais
sintoma(sede).
sintoma(vomitos).
sintoma(fraqueza).
sintoma(fome).
sintoma(dor_de_cabeca).
sintoma(irritabilidade).
sintoma(sensibilidade).
sintoma(dor_no_peito).
sintoma(tontura).
sintoma(falta_de_ar).
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
caracterizacao(dor_no_peito_forte, dor_no_peito).
caracterizacao(dor_no_peito_desconforto, dor_no_peito).
caracterizacao(tosse_seca, tosse).
caracterizacao(tosse_com_catarro, tosse).

% Doenças, probabilidades base e sintomas
doenca(diabetes,55,[sede,vomitos_recorrente,fraqueza,fome]).
doenca(enxaqueca,45,[vomitos_esporadico,dor_de_cabeca_forte,irritabilidade,sensibilidade]).
doenca(hipertensao,40,[dor_no_peito,dor_de_cabeca,fraqueza,tontura]).
doenca(asma,25,[falta_de_ar,tosse_seca,fraqueza,dor_no_peito_desconforto]).
doenca(avc,45,[dor_de_cabeca_forte,visao_alterada,formigamento_no_corpo,fraqueza]).
doenca(dengue,65,[febre_alta,dor_de_cabeca_fraca,dor_nos_olhos,manchas_vermelhas]).
doenca(gripe,70,[febre,dores_no_corpo,coriza,tosse_com_catarro]).
doenca(resfriado,80,[tosse,febre_baixa,coriza,espirros]).
doenca(bronquite,20,[tosse_seca,falta_de_ar,dor_no_peito,coriza]).
doenca(tuberculose,10,[tosse,falta_de_ar,dor_no_peito_desconforto,falta_de_ar,febre,fraqueza]).
doenca(conjuntivite,20,[dor_nos_olhos,sensibilidade,coriza,visao_alterada]).

% Perguntas do questionário
pergunta(espirros, 'Apresenta espirros?').
pergunta(febre, 'Apresenta febre?').
pergunta(tosse, 'Apresenta tosse?').
pergunta(vomitos, 'Apresenta vomito?').
pergunta(dor_de_cabeca, 'Apresenta dor de cabeca?').
pergunta(dores_no_corpo, 'Apresenta dores no corpo? ').
pergunta(sede, 'Sente muita sede?').
pergunta(fraqueza, 'Apresenta uma fraqueza em seu corpo?').
pergunta(dores_no_peito,'Apresenta dores no peito?').
pergunta(falta_de_ar,'Apresenta falta de ar?').
pergunta(visao_alterada, 'Apresenta alterasoes na visao?').
pergunta(formigamento_no_corpo,'Apresenta formigamento no corpo?').
pergunta(dor_nos_olhos, 'Apresenta dor nos olhos?').
pergunta(coriza,'Apresenta coriza?').
pergunta(desconforto_no_peito, 'Apresenta algum desconforto no peito?').
pergunta(fome,'Sente fome mais vezes ao dia do que de costume?').
pergunta(tontura,'Apresenta tontura?').
pergunta(irritabilidade,'Se sente irratado(a) durante o dia?').
pergunta(manchas_vermelhas,'Apresenta manchas vermelhas no corpo?').
pergunta(sensibilidade,'Sente sensibilidade a luz, sons e cheiros?').

% Respostas simples
resposta(espirros, ['Sim','Nao']).
resposta(dores_no_corpo, ['Sim','Nao']).
resposta(sede, ['Sim','Nao']).
resposta(fraqueza, ['Sim','Nao']).
resposta(mudancas_no_comportamento, ['Sim','Nao']).
resposta(falta_de_ar, ['Sim','Nao']).
resposta(alteracao_no_humor, ['Sim','Nao']).
resposta(visao_alterada, ['Sim','Nao']).
resposta(formigamento_no_corpo, ['Sim','Nao']).
resposta(dor_nos_olhos, ['Sim','Nao']).
resposta(coriza, ['Sim','Nao']).
resposta(fome, ['Sim','Nao']).
resposta(tontura, ['Sim','Nao']).
resposta(irritabilidade, ['Sim','Nao']).
resposta(manchas_vermelhas, ['Sim','Nao']).
resposta(sensibilidade, ['Sim','Nao']).

% Respostas caracterizadas
resposta(febre, ['Alta', 'Baixa', 'Nao'], [febre_alta, febre_baixa]).
resposta(vomitos, ['Recorrente', 'Esporadico', 'Nao'], [vomitos_recorrente, vomitos_esporadico]).
resposta(dor_de_cabeca, ['Forte', 'Fraca', 'Nao'], [dor_de_cabeca_forte, dor_de_cabeca_fraca]).
resposta(dor_no_peito, ['Forte', 'Desconforto', 'Nao'], [dor_no_peito_forte, dor_no_peito_desconforto]).
resposta(tosse, ['Seca', 'Catarro', 'Nao'], [tosse_com_catarro, tosse_seca]).


%%%%% Predicados

%% pertence(?Sintoma, ?Doenca)
%
% Estabelece a relação entre uma doença e um sintoma (caracterizado ou geral)
:- begin_tests(pertence).

test(pertence_sintoma_verdadeiro) :-
    pertence(coriza, gripe).

test(pertence_sintoma_falso) :-
    not(pertence(visao_alterada, gripe)).

test(pertence_sintoma_caracterizado_equivale_geral) :-
    pertence(febre_alta, gripe).

test(pertence_sintoma_geral_nao_equivale_caracterizado) :-
    not(pertence(dor_de_cabeca, avc)).

test(pertence_sintoma_caracterizado_verdadeiro) :-
    pertence(dor_de_cabeca_forte, avc).

test(pertence_sintoma_caracterizado_falso) :-
    not(pertence(dor_de_cabeca_fraca, avc)).

:- end_tests(pertence).

pertence(Sintoma, Doenca) :-
    doenca(Doenca, _, SintomasDoenca),
    member(Sintoma, SintomasDoenca), !.
    
pertence(Sintoma, Doenca) :-
    doenca(Doenca, _, SintomasDoenca),
    caracterizacao(Sintoma, SintomaCaracterizado),
    member(SintomaCaracterizado, SintomasDoenca), !.

%% pertencentes(+Sintomas, +Doenca, -SintomasPertencentes)
%
% Filtra uma lista de sintomas para retornar apenas quais desses sintomas são de certa doença
:- begin_tests(pertencentes).

test(todos_pertencentes) :-
    pertencentes([tosse_com_catarro,febre_baixa], resfriado, [tosse_com_catarro,febre_baixa]).

test(alguns_pertencentes) :-
    pertencentes([tosse_com_catarro,visao_alterada], resfriado, [tosse_com_catarro]).

test(nenhum_pertencente) :-
    pertencentes([irritabilidade,visao_alterada], resfriado, []).    

:- end_tests(pertencentes).

pertencentes(Sintomas, Doenca, SintomasPertencentes) :-
    findall(Sintoma, (member(Sintoma, Sintomas), pertence(Sintoma, Doenca)), SintomasPertencentes).

%% nao_apresentados(+Sintomas, +Doenca, -SintomasPertencentes)
%
% Filtra uma lista de sintomas para retornar apenas quais desses sintomas NÃO são de certa doença
:- begin_tests(nao_apresentados).

test(alguns_nao_apresentados) :-
    nao_apresentados([tosse_com_catarro,febre_baixa], resfriado, [coriza, espirros]).

test(alguns_nao_apresentados_alguns_nao_pertencentes) :-
    nao_apresentados([tosse_com_catarro,visao_alterada], resfriado, [febre_baixa, coriza, espirros]).

test(todos_nao_apresentados) :-
    nao_apresentados([irritabilidade,visao_alterada], resfriado, [tosse, febre_baixa, coriza, espirros]).

test(nenhum_nao_apresentado) :-
    nao_apresentados([tosse, febre_baixa, coriza, espirros], resfriado, []).

:- end_tests(nao_apresentados).

nao_apresentados(Sintomas, Doenca, SintomasNaoApresentados) :-
    doenca(Doenca, _, SintomasDoenca),
    findall(SintomaDoenca,
            (member(SintomaDoenca, SintomasDoenca),
                not(member(SintomaDoenca, Sintomas);
                (member(Sintoma, Sintomas), caracterizacao(Sintoma, SintomaDoenca)))),
            SintomasNaoApresentados).

%% probabilidade(+Doenca, +Sintomas, -Resultado)
%
% A partir da probabilidade base e da relação entre os sintomas passados e da doença,
% calcula a probabilidade do paciente ter a doençá
:- begin_tests(probabilidade).

test(probabilidade_alta) :-
    probabilidade(resfriado, [tosse_com_catarro,febre_baixa,coriza,espirros], 80).

test(probabilidade_media) :-
    probabilidade(resfriado, [coriza,espirros], 40).

test(probabilidade_baixa) :-
    probabilidade(resfriado, [febre_baixa], 20).

test(probabilidade_zero) :-
    probabilidade(resfriado, [visao_alterada], 0).

test(probabilidade_vazio) :-
    probabilidade(resfriado, [], 0).

:- end_tests(probabilidade).

probabilidade(Doenca, Sintomas, Resultado) :-
    doenca(Doenca, Probabilidade, SintomasDoenca),
    length(SintomasDoenca, N_sintomas_doenca),
    pertencentes(Sintomas, Doenca, SintomasPertencentes),
    length(SintomasPertencentes, N_pertencentes),
    Resultado is Probabilidade * N_pertencentes / N_sintomas_doenca.

%% diagnostico(+Sintomas, -Doenca, -Resultado)
%
% Dado um conjunto de sintomas, retorna um lista de doenças possíveis e a probabilidade de
% o paciente ter cada uma delas
:- begin_tests(diagnostico).

test(diagnostico_verdadeiro) :-
    diagnostico([febre_alta, tosse, dor_corpo, dor_cabeca], gripe, Prob),
    assertion(Prob > 0).

test(diagnostico_falso) :-
    not(diagnostico([visao_alterada, fome], gripe, _)).

test(diagnostico_gripe, nondet) :-
    diagnostico([febre_alta, tosse, dor_corpo, dor_cabeca], Doenca, _),
    Doenca = gripe.

test(diagnostico_resultados, nondet) :-
    findall((Doenca, Resultado),
            diagnostico([febre_alta, tosse], Doenca, Resultado),
            Diagnosticos),
    member((gripe, ResultadoGripe), Diagnosticos),
    member((dengue, ResultadoDengue), Diagnosticos),
    ResultadoGripe > ResultadoDengue.

:- end_tests(diagnostico).

diagnostico(Sintomas, Doenca, Resultado) :-
    doenca(Doenca, _, _),
    probabilidade(Doenca, Sintomas, Resultado),
    Resultado > 0.

%% diagnosticos_ordenados(+Sintomas, -Doenca, -Resultado)
%
% Wrapper para diagnostico, que garante a ordem decrescente de probabilidade
% para as doenças retornadas não-deterministicamente, e formato o valor da probilidade
:- begin_tests(diagnosticos_ordenados).

test(diagnosticos_resultados_ordenados, nondet) :-
    findall(Doenca,
            diagnosticos_ordenados([febre_alta, tosse], Doenca, _),
            Diagnosticos),
    nth0(IndiceGripe, Diagnosticos, gripe),
    nth0(IndiceDengue, Diagnosticos, dengue),
    IndiceGripe < IndiceDengue.

:- end_tests(diagnosticos_ordenados).

diagnosticos_ordenados(Sintomas, Doenca, Resultado) :-
    findall([ResultadoDiagnostico, DoencaDiagnostico],
             diagnostico(Sintomas, DoencaDiagnostico, ResultadoDiagnostico),
             Diagnosticos),
    sort(Diagnosticos, DiagnosticosOrdenadosAsc),
    reverse(DiagnosticosOrdenadosAsc, DiagnosticosOrdenados),
    member([ResultadoRaw, Doenca], DiagnosticosOrdenados),
    format(atom(Resultado), '~2f%', ResultadoRaw).


%% questao(?Sintoma, -Pergunta, -Repostas, -Caracterizacoes)
%
% Exibe a pergunta, as respostas, e, se existerem, as caracterizacoes representada
% por cada resposta, relacionadas a um sintoma
:- begin_tests(questao).

test(questao_simples) :-
    questao(espirros, Pergunta, Respostas, Caracterizacoes),
    pergunta(espirros, Pergunta),
    resposta(espirros, Respostas),
    Pergunta = 'Apresenta espirros?',
    Respostas = ['Sim', 'Nao'],
    Caracterizacoes = [].

test(questao_caracterizacoes, nondet) :-
    questao(febre, Pergunta, Respostas, Caracterizacoes),
    pergunta(febre, Pergunta),
    resposta(febre, Respostas, Caracterizacoes),
    Pergunta = 'Apresenta febre?',
    Respostas = ['Alta', 'Baixa', 'Nao'],
    Caracterizacoes = [febre_alta, febre_baixa].

:- end_tests(questao).

questao(Sintoma, Pergunta, Respostas, Caracterizacoes) :-
    pergunta(Sintoma, Pergunta),
    resposta(Sintoma, Respostas, Caracterizacoes).

questao(Sintoma, Pergunta, Respostas, Caracterizacoes) :-
    pergunta(Sintoma, Pergunta),
    resposta(Sintoma, Respostas),
    Caracterizacoes = [].
