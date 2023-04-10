:- use_module(library(plunit)).

% Variável global para armazenar o nome do arquivo
:- dynamic arquivo_pacientes/1.

%% definir_arquivo_pacientes(?Arquivo)
%
% Função para definir o arquivo a ser usado
definir_arquivo_pacientes(Arquivo) :-
    retractall(arquivo_pacientes(_)),
    assert(arquivo_pacientes(Arquivo)),
    carregar_pacientes.

%% criar_arquivo_testes
%
% Wrapper para executar os testes usando o arquivo exclusivo
criar_arquivo_testes :-
    definir_arquivo_pacientes('pacientes-tests.txt'),
    arquivo_pacientes(NomeArquivo),
    open(NomeArquivo, write, Arquivo),
    write(Arquivo, ''),
    close(Arquivo).

% Predicado dinâmico para pacientes
:- dynamic paciente/6.

:- begin_tests(pacientes).

% Teste para verificar se é possível cadastrar um paciente corretamente
test(cadastrar_paciente_sucesso, [ setup(criar_arquivo_testes),
                                   cleanup(definir_arquivo_pacientes('pacientes.txt'))
                                 ]) :-
    cadastrar_paciente(1, 'Fulano', 25, 'Masculino', 'Rua A', '1111-1111', Resultado),
    paciente(1, 'Fulano', 25, 'Masculino', 'Rua A', '1111-1111'),
    Resultado = 'Paciente cadastrado com sucesso'.

% Teste para verificar que não é possível cadastrar mais de um paciente com o mesmo id
test(cadastrar_paciente_falha, [ setup(criar_arquivo_testes),
                                 cleanup(definir_arquivo_pacientes('pacientes.txt'))
                               ]) :-
    cadastrar_paciente(1, 'Fulano', 25, 'Masculino', 'Rua A', '1111-1111', _),
    cadastrar_paciente(1, 'Teste', 25, 'Masculino', 'Rua A', '1111-1111', Resultado),
    Resultado = 'Erro: ja existe um paciente com esse ID.'.

% Teste para verificar se é possível alterar um paciente corretamente
test(alterar_paciente_sucesso, [ setup(criar_arquivo_testes),
                                 cleanup(definir_arquivo_pacientes('pacientes.txt'))
                               ]) :-
    cadastrar_paciente(1, 'Ciclana', 30, 'Feminino', 'Rua B', '2222-2222', _),
    alterar_paciente(1, 'Beltrana', 28, 'Feminino', 'Rua C', '3333-3333', Resultado),
    paciente(1, 'Beltrana', 28, 'Feminino', 'Rua C', '3333-3333'),
    Resultado = 'Paciente alterado com sucesso'.

% Teste para verificar o erro ao tentar alterar um id que não existe
test(alterar_paciente_falha, [ setup(criar_arquivo_testes),
                               cleanup(definir_arquivo_pacientes('pacientes.txt'))
                             ]) :-
    retractall(paciente(_, _, _, _, _, _)),
    alterar_paciente(1, 'Beltrana', 28, 'Feminino', 'Rua C', '3333-3333', Resultado),
    Resultado = 'Erro: nao existe nenhum paciente com esse ID.'.

% Teste para verificar se é possível excluir um paciente corretamente
test(excluir_paciente_sucesso, [ setup(criar_arquivo_testes),
                                 cleanup(definir_arquivo_pacientes('pacientes.txt'))
                               ]) :-
    cadastrar_paciente(1, 'Sicrano', 35, 'Masculino', 'Rua D', '4444-4444', _),
    excluir_paciente(1, Resultado),
    Resultado = 'Paciente excluido com sucesso',
    not(paciente(1, _, _, _, _, _)).

% Teste para verificar o erro ao tentar alterar um id que não existe
test(excluir_paciente_falha, [ setup(criar_arquivo_testes),
                               cleanup(definir_arquivo_pacientes('pacientes.txt'))
                             ]) :-
    excluir_paciente(1, Resultado),
    Resultado = 'Erro: nao existe nenhum paciente com esse ID.'.

% Teste para verificar se é possível carregar os pacientes a partir do arquivo corretamente
test(carregar_pacientes, nondet, [ setup(criar_arquivo_testes),
                                   cleanup(definir_arquivo_pacientes('pacientes.txt'))
                                 ]) :-
    arquivo_pacientes(NomeArquivo),
    open(NomeArquivo, write, Arquivo),
    writeq(Arquivo, paciente(4, 'Fulana', 27, 'Feminino', 'Rua E', '5555-5555')),
    write(Arquivo, '.'),
    nl(Arquivo),
    close(Arquivo),
    carregar_pacientes,
    paciente(4, 'Fulana', 27, 'Feminino', 'Rua E', '5555-5555').

% Teste para verificar se é possível salvar os pacientes no arquivo corretamente
test(salvar_pacientes, nondet, [ setup(criar_arquivo_testes),
                                 cleanup(definir_arquivo_pacientes('pacientes.txt'))
                               ]) :-
    assert(paciente(5, 'Pafúncio', 24, 'Masculino', 'Rua F', '6666-6666')),
    salvar_pacientes,
    arquivo_pacientes(NomeArquivo),
    retractall(paciente(_, _, _, _, _, _)),
    (   exists_file(NomeArquivo)
    ->  open(NomeArquivo, read, Arquivo),
        repeat,
        read(Arquivo, Paciente),
        (   Paciente == end_of_file
        ->  true
        ;   assert(Paciente),
            fail
        ),
        close(Arquivo)
    ;   false
    ),
    paciente(5, 'Pafúncio', 24, 'Masculino', 'Rua F', '6666-6666').

:- end_tests(pacientes).

%% carregar_pacientes
%
% Função para carregar os pacientes a partir do arquivo
carregar_pacientes :-
    arquivo_pacientes(NomeArquivo),
    retractall(paciente(_, _, _, _, _, _)),
    (   exists_file(NomeArquivo)
    ->  open(NomeArquivo, read, Arquivo),
        repeat,
        read(Arquivo, Paciente),
        (   Paciente == end_of_file
        ->  true
        ;   assertz(Paciente),
            fail
        ),
        close(Arquivo)
    ;   false
    ).

%% salvar_pacientes
%
% Função para salvar os pacientes no arquivo
salvar_pacientes :-
    arquivo_pacientes(NomeArquivo),
    open(NomeArquivo, write, Arquivo),
    forall(paciente(ID, Nome, Idade, Genero, Endereco, Telefone),
           (   writeq(Arquivo, paciente(ID, Nome, Idade, Genero, Endereco, Telefone)),
               write(Arquivo, '.'),
               nl(Arquivo)
           )),
    close(Arquivo).

%% cadastrar_paciente(+ID, +Nome, +Idade, +Genero, +Endereco, +Telefone, -Resultado)
%
% Função para cadastrar um paciente e salvá-lo no arquivo
cadastrar_paciente(ID, Nome, Idade, Genero, Endereco, Telefone, Resultado) :-
    (   not(paciente(ID, _, _, _, _, _))
    ->  assert(paciente(ID, Nome, Idade, Genero, Endereco, Telefone)),
        salvar_pacientes,
        Resultado = 'Paciente cadastrado com sucesso'
    ;   Resultado = 'Erro: ja existe um paciente com esse ID.'
    ).

%% alterar_paciente(+ID, +NovoNome, +NovaIdade, +NovoGenero, +NovoEndereco, +NovoTelefone, -Resultado)
%
% Função para alterar um paciente e salvá-lo no arquivo
alterar_paciente(ID, NovoNome, NovaIdade, NovoGenero, NovoEndereco, NovoTelefone, Resultado) :-
    (   paciente(ID, _, _, _, _, _)
    ->  retract(paciente(ID, _, _, _, _, _)),
        assert(paciente(ID, NovoNome, NovaIdade, NovoGenero, NovoEndereco, NovoTelefone)),
        salvar_pacientes,
        Resultado = 'Paciente alterado com sucesso'
    ;   Resultado = 'Erro: nao existe nenhum paciente com esse ID.'
    ).

%% excluir_paciente(+ID, -Resultado)
%
% Função para excluir um paciente e salvá-lo no arquivo
excluir_paciente(ID, Resultado) :-
    (   paciente(ID, _, _, _, _, _)
    ->  retract(paciente(ID, _, _, _, _, _)),
        salvar_pacientes,
        Resultado = 'Paciente excluido com sucesso'
    ;   Resultado = 'Erro: nao existe nenhum paciente com esse ID.'
    ).
