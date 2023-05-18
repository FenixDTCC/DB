SET NOCOUNT ON

DECLARE @associado INT
DECLARE @idatendimento INT, @idatendimentoevento INT, @idespecialidade INT, @ididentificacaoatendimento INT, @idhospital INT

DECLARE Associado_Cursor CURSOR FOR SELECT idAssociado from Associado WHERE idAssociado <= CONVERT(INT,DATEPART(SECOND,GETDATE()))

OPEN Associado_Cursor
FETCH NEXT FROM Associado_Cursor INTO @associado


--select RAND(CONVERT(INT,DATEPART(SECOND,GETDATE()))*CONVERT(INT,DATEPART(MILLISECOND,GETDATE()))*1000)*100
--SELECT CONVERT(INT,DATEPART(SECOND,GETDATE()))

WHILE @@FETCH_STATUS = 0  
BEGIN 
	IF NOT EXISTS (SELECT 1 FROM Atendimentos WHERE idAssociado = @associado)
	BEGIN
		SELECT @idatendimento = ISNULL(MAX(idAtendimento),0)+1 FROM Atendimentos WITH (NOLOCK)

		SELECT @idhospital = RAND(CONVERT(INT,DATEPART(SECOND,GETDATE()))*CONVERT(INT,DATEPART(MILLISECOND,GETDATE()))*1000)*100
		IF @idhospital < 13
		BEGIN
			SELECT @idhospital = 2
		END
		ELSE
		BEGIN
			IF @idhospital < 25
				SELECT @idhospital = 1
			ELSE
			BEGIN
			    IF @idhospital < 37
					SELECT @idhospital = 3
				ELSE
				BEGIN
					IF @idhospital < 49
						SELECT @idhospital = 4
					ELSE
						SELECT @idhospital = 5
				END
			END
		END

		SELECT @ididentificacaoatendimento = RAND(CONVERT(INT,DATEPART(SECOND,GETDATE()))*CONVERT(INT,DATEPART(MILLISECOND,GETDATE()))*1000)*100
		IF @ididentificacaoatendimento < 51
		BEGIN
			SELECT @ididentificacaoatendimento = 2
		END
		ELSE
		BEGIN
			IF @ididentificacaoatendimento < 76
				SELECT @ididentificacaoatendimento = 1
			ELSE
				SELECT @ididentificacaoatendimento = 3
		END

		SELECT @idespecialidade = RAND(CONVERT(INT,DATEPART(SECOND,GETDATE()))*CONVERT(INT,DATEPART(MILLISECOND,GETDATE()))*1000)*100
		IF @idespecialidade < 51
		BEGIN
			SELECT @idespecialidade = 45
		END
		ELSE
		BEGIN
			IF @idespecialidade < 76
				SELECT @idespecialidade = 16
			ELSE
				SELECT @idespecialidade = 49
		END
		INSERT INTO Atendimentos VALUES (@idatendimento,ISNULL(@idespecialidade,16),1,isnull(@ididentificacaoatendimento,1),1,@associado,GETDATE())
		INSERT INTO AtendimentosEventos VALUES (@idatendimento,1,'I',GETDATE())
		INSERT INTO AtendimentosEventos VALUES (@idatendimento,1,'F',GETDATE())
	END
	ELSE
	BEGIN
		SELECT @idatendimento = AT.idAtendimento, 
		       @idatendimentoevento =  AE.idEvento 
		FROM Atendimentos AT WITH (NOLOCK)
		INNER JOIN AtendimentosEventos AE WITH (NOLOCK) ON AE.idAtendimento = AT.idAtendimento
		WHERE idAssociado = @associado

		IF @idatendimentoevento = 1
		BEGIN
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento+1,'I',DATEADD(MI,CONVERT(INT,(RAND(@associado*1000)*10)),GETDATE()))
		END

		IF @idatendimentoevento = 2
		BEGIN
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento,'F',GETDATE())
			UPDATE Atendimentos SET idStatusAtendimento = 2 WHERE idAtendimento = @idatendimento
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento+1,'I',DATEADD(MI,CONVERT(INT,(RAND(@associado*1000)*10)),GETDATE()))
		END

		IF @idatendimentoevento = 3
		BEGIN
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento,'F',GETDATE())
			UPDATE Atendimentos SET idStatusAtendimento = 3 WHERE idAtendimento = @idatendimento
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento+1,'I',DATEADD(MI,CONVERT(INT,(RAND(@associado*1000)*10)),GETDATE()))
		END

		IF @idatendimentoevento = 4
		BEGIN
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento,'F',GETDATE())
			UPDATE Atendimentos SET idStatusAtendimento = 4 WHERE idAtendimento = @idatendimento
		END

		if @idatendimentoevento = 4 and @idatendimento < CONVERT(INT,DATEPART(SECOND,GETDATE()))
		BEGIN
			UPDATE Atendimentos SET idStatusAtendimento = 7 WHERE idAtendimento = @idatendimento
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,6,'I',DATEADD(MI,CONVERT(INT,(RAND(@associado*1000)*10)),GETDATE()))
		END

		IF @idatendimentoevento = 6
		BEGIN
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,@idatendimentoevento,'F',GETDATE())
			UPDATE Atendimentos SET idStatusAtendimento = 3 WHERE idAtendimento = @idatendimento
			INSERT INTO AtendimentosEventos VALUES (@idatendimento,4,'I',DATEADD(MI,CONVERT(INT,(RAND(@associado*1000)*10)),GETDATE()))
		END


	END

--SELECT @idatendimento = ISNULL(MAX(idAtendimento),0)+1 FROM Atendimentos
--INSERT INTO Atendimentos VALUES (@idatendimento,16,1,1,1,1,GETDATE())
--INSERT INTO AtendimentosEventos VALUES (@idatendimento,1,'I',GETDATE())

--INSERT INTO AtendimentosEventos VALUES (1,1,'F',GETDATE())
--INSERT INTO AtendimentosEventos VALUES (1,2,'I',GETDATE())

--INSERT INTO AtendimentosEventos VALUES (1,2,'F',GETDATE())
--UPDATE Atendimentos SET idStatusAtendimento = 2 WHERE idAtendimento = 1
--INSERT INTO AtendimentosEventos VALUES (1,3,'I',GETDATE())

--INSERT INTO AtendimentosEventos VALUES (1,3,'F',GETDATE())
--INSERT INTO AtendimentosEventos VALUES (1,4,'I',GETDATE())
--UPDATE Atendimentos SET idStatusAtendimento = 3 WHERE idAtendimento = 1

--INSERT INTO AtendimentosEventos VALUES (1,4,'F',GETDATE())
--UPDATE Atendimentos SET idStatusAtendimento = 4 WHERE idAtendimento = 1


	FETCH NEXT FROM Associado_Cursor INTO @associado
END

CLOSE Associado_Cursor
DEALLOCATE Associado_Cursor