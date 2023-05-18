SELECT * FROM Atendimentos
SELECT * FROM AtendimentosEventos


select * from eVENTO

16
45
49

1	Iniciado
2	Aguardando
3	Em andamento
4	Finalizado
5	Cancelado
6	Suspenso
7	Encaminhado
8	Transferido


1	Azul
2	Verde
3	Amarelo
4	Laranja
5	Vermelho

1	84.946.165/0001-40	Hospital e Maternidade A LTDA
2	85.182.404/0001-04	Hospital e Maternidade B LTDA
3	17.035.551/0001-93	Hospital e Maternidade C LTDA
4	88.466.041/0001-19	Hospital e Maternidade D LTDA
5	64.507.701/0001-02	Hospital e Maternidade E LTDA


1	Aparecida
2	Osvaldo


1	Senha para Atendimento
2	Triagem Diagnostica
3	Registro do Paciente
4	Consulta Medica
5	Internacao
6	Exames Ambulatoriais
7	Exames Clinicos

DECLARE @idatendimento INT
SELECT @idatendimento = ISNULL(MAX(idAtendimento),0)+1 FROM Atendimentos
INSERT INTO Atendimentos VALUES (@idatendimento,16,1,1,1,1,CURRENT_TIMESTAMP)

INSERT INTO AtendimentosEventos VALUES (@idatendimento,1,'I',CURRENT_TIMESTAMP)

INSERT INTO AtendimentosEventos VALUES (1,1,'F',CURRENT_TIMESTAMP)
INSERT INTO AtendimentosEventos VALUES (1,2,'I',CURRENT_TIMESTAMP)

INSERT INTO AtendimentosEventos VALUES (1,2,'F',CURRENT_TIMESTAMP)
UPDATE Atendimentos SET idStatusAtendimento = 2 WHERE idAtendimento = 1
INSERT INTO AtendimentosEventos VALUES (1,3,'I',CURRENT_TIMESTAMP)

INSERT INTO AtendimentosEventos VALUES (1,3,'F',CURRENT_TIMESTAMP)
INSERT INTO AtendimentosEventos VALUES (1,4,'I',CURRENT_TIMESTAMP)
UPDATE Atendimentos SET idStatusAtendimento = 3 WHERE idAtendimento = 1

INSERT INTO AtendimentosEventos VALUES (1,4,'F',CURRENT_TIMESTAMP)
UPDATE Atendimentos SET idStatusAtendimento = 4 WHERE idAtendimento = 1





SELECT AT.idAtendimento, AT.dtAtendimento,HO.NomeFantasia, ES.dsEspecialidade, SA.dsStatusAtendimento, IA.dsIdentificacaoAtendimento,EV.dsEvento,
CASE
     WHEN AE.acAtendimento = 'I' THEN 'Inicio'
     WHEN AE.acAtendimento = 'F' THEN 'Fim'
END,
AE.mtAtendimento
FROM Atendimentos AT WITH (NOLOCK)
INNER JOIN AtendimentosEventos AE      WITH (NOLOCK) ON AE.idAtendimento = AT.idAtendimento
INNER JOIN Especialidade ES            WITH (NOLOCK) ON ES.idEspecialidade = AT.idEspecialidade
INNER JOIN StatusAtendimento SA        WITH (NOLOCK) ON SA.idStatusAtendimento = AT.idStatusAtendimento
INNER JOIN IdentificacaoAtendimento IA WITH (NOLOCK) ON IA.idIdentificacaoAtendimento = AT.idIdentificacaoAtendimento
INNER JOIN Hospital HO                 WITH (NOLOCK) ON HO.idHospital = AT.idHospital
INNER JOIN Evento EV                   WITH (NOLOCK) ON EV.idEvento = AE.idEvento
--WHERE AT.idAssociado = 1 
ORDER BY AE.idEvento,AE.mtAtendimento


select * from Associado
SELECT * FROM Atendimentos WHERE idAssociado = 1 
SELECT * FROM AtendimentosEventos WHERE idAtendimento = (SELECT idAtendimento FROM Atendimentos WHERE idAssociado = 1) order by idEvento, mtAtendimento, acAtendimento DESC


SP_HELP AtendimentosEventos

TRUNCATE TABLE Atendimentos
truncate table AtendimentosEventos
delete from Atendimentos where idAssociado >= 1