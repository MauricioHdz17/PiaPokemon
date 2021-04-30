Create database PiaVillanos

use PiaVillanos

set dateformat dmy;


-- TABLAS --

Create Table Medalla(
IdMedalla INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
NombreMedalla VARCHAR(30) NOT NULL);

Create table TipoGimnasio(
IdTipoGimnasio INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
TipoGimnasio VARCHAR(30) NOT NULL);

Create table TipoBatalla(
IdTipoBatalla INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
TipoBatalla VARCHAR(30) NOT NULL);
 
Create table TipoPokemon(
IdTipoPoke INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(15) NOT NULL);

Create table Estado(
IdEstado INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30));

Create table Ciudad(
IdCiudad INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30) NOT NULL,
IdEstado INT,
Foreign Key (IdEstado) References Estado (IdEstado));

Create table Pokemon(
IdPokemon INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30) NOT NULL,
Preevolucion BIT NOT NULL,
Evolucion BIT NOT NULL,
Altura FLOAT NOT NULL,
Peso FLOAT NOT NULL,
IdTipoPoke INT NOT NULL,
Foreign Key (IdTipoPoke) References TipoPokemon (IdTipoPoke));

Create table EntrenadorP(
IdEntrenador INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30) NOT NULL,
Apellidos VARCHAR(30) NOT NULL,
FNacimiento DATE NOT NULL,
NCelular INT NOT NULL,
Direccion VARCHAR(30) NOT NULL,
IdCiudad INT NOT NULL,
Foreign Key (IdCiudad) References Ciudad (IdCiudad));

Create table Entrena_Poke(
IdEn_Poke INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
IdEntrenador int not null,
IdPokemon int not null,
Foreign Key (IdEntrenador) References EntrenadorP (IdEntrenador),
Foreign Key (IdPokemon) References Pokemon (IdPokemon));

Create table LiderP(
IdLiderP INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30) NOT NULL,
Apellido VARCHAR(30) NOT NULL,
Celular NUMERIC,
FechaN DATE,
Sueldo MONEY);

Create table GimnasioP(
IdGimnasioP INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre VARCHAR(30) NOT NULL,
IdTipoGimnasio INT NOT NULL,
Direccion VARCHAR(30) NOT NULL,
IdCiudad INT NOT NULL,
NTelefono int NOT NULL,
IdMedalla INT NOT NULL,
IdLiderP INT NOT NULL,
Foreign Key (IdTipoGimnasio) References TipoGimnasio (IdTipoGimnasio),
Foreign Key (IdCiudad) References Ciudad (IdCiudad),
Foreign Key (IdMedalla) References Medalla (IdMedalla),
Foreign Key (IdLiderP) References LiderP (IdLiderP));

Create table Lider_Poke(
IdLider_Poke INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
IdLiderP INT NOT NULL,
IdPokemon INT NOT NULL,
Foreign Key (IdLiderP) References LiderP (IdLiderP),
Foreign Key (IdPokemon) References Pokemon (IdPokemon));

Create table MedallaEntrenador(
IdMedallaEntrenador INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Descripcion VARCHAR(30) NOT NULL,
IdEntrenador INT NOT NULL,
IdMedalla INT NOT NULL,
IdGimnasioP INT NOT NULL,
FechaBatalla DATE NOT NULL,
EstatusBatalla VARCHAR(30) NOT NULL,
IdTipoBatalla INT NOT NULL,
Foreign key (IdMedalla) References Medalla (IdMedalla),
Foreign Key (IdTipoBatalla) References TipoBatalla (IdTipoBatalla),
Foreign Key (IdEntrenador) References EntrenadorP (IdEntrenador),
Foreign Key (IdGimnasioP) References GimnasioP (IdGimnasioP));

-- PROCEDURES PARA ACTUALIZAR --

CREATE PROCEDURE spActualizarEntrenador
  @IdEntrenador INT,
  @Nombre VARCHAR(30),
  @Apellidos VARCHAR(30),
  @FNacimiento DATE,
  @NCelular INT,
  @Direccion VARCHAR(30),
  @IdCiudad INT,
  @mensaje VARCHAR(60) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
  DECLARE @Cuanto2 SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SET @Cuanto2 = 0;
  SELECT @Cuanto = COUNT(t.Nombre) 
  FROM EntrenadorP t
  WHERE t.IdEntrenador = @IdEntrenador;
  IF  @Cuanto > 0 
  BEGIN
    UPDATE EntrenadorP 
	SET   EntrenadorP.Nombre = @Nombre, 
		  EntrenadorP.Apellidos = @Apellidos, 
		  EntrenadorP.FNacimiento = @FNacimiento,
		  EntrenadorP.NCelular = @NCelular,
		  EntrenadorP.Direccion = @Direccion,
		  EntrenadorP.IdCiudad = @IdCiudad
	WHERE EntrenadorP.IdEntrenador = @IdEntrenador;
    SET @mensaje = 'Se actualizó el entrenador con folio ' + CONVERT(varchar,(@IdEntrenador)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un entrenador con ese folio.';
  END
END

CREATE PROCEDURE spActualizarMedallaEn
(
  @IdMedallaEntrenador INT,
  @Descripcion VARCHAR(30),
  @IdEntrenador INT,
  @IdMedalla INT,
  @IdGimnasioP INT,
  @FechaBatalla DATE,
  @EstatusBatalla VARCHAR(30),
  @IdTipoBatalla INT,
  @mensaje VARCHAR(60) OUTPUT 
  )
AS
  DECLARE @Cuanto  SMALLINT;
  DECLARE @Cuanto2 SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SET @Cuanto2 = 0;
  SELECT @Cuanto = COUNT(t.Descripcion) 
  FROM MedallaEntrenador t
  WHERE t.IdMedallaEntrenador = @IdMedallaEntrenador;
  IF  @Cuanto > 0 
  BEGIN
    UPDATE MedallaEntrenador 
	SET   MedallaEntrenador.Descripcion = @Descripcion,
	      MedallaEntrenador.IdEntrenador = @IdEntrenador, 
		  MedallaEntrenador.IdMedalla = @IdMedalla, 
		  MedallaEntrenador.IdGimnasioP = @IdGimnasioP,
		  MedallaEntrenador.FechaBatalla = @FechaBatalla,
		  MedallaEntrenador.EstatusBatalla = @EstatusBatalla,
		  MedallaEntrenador.IdTipoBatalla = @IdTipoBatalla
	WHERE MedallaEntrenador.IdMedallaEntrenador = @IdMedallaEntrenador;
    SET @mensaje = 'Se actualizó la medalla de entrenador con folio ' + CONVERT(varchar,(@IdMedallaEntrenador)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe una medalla de entrenador con ese folio.';
  END
END


CREATE PROCEDURE spActualizarPokemon
  @IdPokemon INT,
  @Nombre VARCHAR(30),
  @Preevolucion BIT,
  @Evolucion BIT,
  @Altura FLOAT,
  @Peso FLOAT,
  @IdTipoPoke INT,
  @mensaje VARCHAR(60) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
  DECLARE @Cuanto2 SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SET @Cuanto2 = 0;
  SELECT @Cuanto = COUNT(t.Nombre) 
  FROM Pokemon t
  WHERE t.IdPokemon = @IdPokemon;
  IF  @Cuanto > 0 
  BEGIN
    UPDATE Pokemon 
	SET   Pokemon.Nombre = @Nombre, 
		  Pokemon.Preevolucion = @Preevolucion, 
		  Pokemon.Evolucion = @Evolucion,
		  Pokemon.Altura = @Altura,
		  Pokemon.Peso = @Peso,
		  Pokemon.IdTipoPoke = @IdTipoPoke
	WHERE Pokemon.IdPokemon = @IdPokemon;
    SET @mensaje = 'Se actualizó el Pokemon con folio ' + CONVERT(varchar,(@IdPokemon)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un Pokemon con ese folio.';
  END
END


CREATE PROCEDURE spActualizarEntrenaPoke
  @IdEn_Poke INT,
  @IdEntrenador INT,
  @IdPokemon INT,
  @mensaje VARCHAR(60) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
  DECLARE @Cuanto2 SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SET @Cuanto2 = 0;
  SELECT @Cuanto = COUNT(t.IdEntrenador) 
  FROM Entrena_Poke t
  WHERE t.IdEn_Poke = @IdEn_Poke;
  IF  @Cuanto > 0 
  BEGIN
    UPDATE Entrena_Poke 
	SET   Entrena_Poke.IdEntrenador = @IdEntrenador, 
		  Entrena_Poke.IdPokemon = @IdPokemon
	WHERE Entrena_Poke.IdEn_Poke = @IdEn_Poke;
    SET @mensaje = 'Se actualizó el Pokemon del entrenador con folio ' + CONVERT(varchar,(@IdPokemon)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un Pokemon de entrenador con ese folio.';
  END
END


-- PROCEDURES PARA AGREGAR ---

CREATE PROCEDURE spAgregarEntrenador
(
  @Nombre VARCHAR(30),
  @Apellidos VARCHAR(30),
  @FNacimiento DATE,
  @NCelular INT,
  @Direccion VARCHAR(30),
  @IdCiudad INT,
  @mensaje VARCHAR(50) OUTPUT
)
AS
  DECLARE @Cuanto SMALLINT;
  DECLARE @Ultimo SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto = 0;
  SET @Ultimo = 0;
  SELECT @Ultimo = MAX(t.IdEntrenador) FROM EntrenadorP t;
  SELECT @Cuanto = COUNT(t.Nombre)
  FROM EntrenadorP t
  WHERE t.Nombre = @Nombre
  IF  @Cuanto > 0 
  BEGIN
     SET @mensaje = 'ERROR. Ya existe un entrenador con ese nombre';
  END
  ELSE
  BEGIN
    INSERT EntrenadorP VALUES(@Nombre,@Apellidos,@FNacimiento,@NCelular,@Direccion,@IdCiudad);
	SET @mensaje = 'Entrenador registrado con exito con el folio ' + CONVERT(varchar,(@Ultimo + 1));
  END
END


CREATE PROCEDURE spAgregarMedallaEntrena
(
  @Descripcion Varchar(30),
  @IdEntrenador INT,
  @IdMedalla INT,
  @IdGimnasioP INT,
  @FechaBatalla DATE,
  @EstatusBatalla VARCHAR(30),
  @IdTipoBatalla INT,
  @mensaje VARCHAR(50) OUTPUT
)
AS
  DECLARE @Cuanto SMALLINT;
  DECLARE @Ultimo SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto = 0;
  SET @Ultimo = 0;
  SELECT @Ultimo = MAX(t.IdMedallaEntrenador) FROM MedallaEntrenador t;
  SELECT @Cuanto = COUNT(t.IdEntrenador)
  FROM MedallaEntrenador t
  WHERE t.IdEntrenador = @IdEntrenador
  IF  @Cuanto > 0 
  BEGIN
     SET @mensaje = 'ERROR. Ya existe un entrenador con esa medallla';
  END
  ELSE
  BEGIN
    INSERT MedallaEntrenador VALUES(@Descripcion,@IdEntrenador,@IdMedalla,@IdGimnasioP,@FechaBatalla,@EstatusBatalla,@IdTipoBatalla);
	SET @mensaje = 'Medalla de entrenador registrada con exito con el folio ' + CONVERT(varchar,(@Ultimo + 1));
  END
END

CREATE PROCEDURE spAgregarPokemon
(
  @Nombre VARCHAR(30),
  @Preevolucion BIT,
  @Evolucion BIT,
  @Altura FLOAT,
  @Peso FLOAT,
  @IdTipoPoke INT,
  @mensaje VARCHAR(50) OUTPUT
)
AS
  DECLARE @Cuanto SMALLINT;
  DECLARE @Ultimo SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto = 0;
  SET @Ultimo = 0;
  SELECT @Ultimo = MAX(t.IdPokemon) FROM Pokemon t;
  SELECT @Cuanto = COUNT(t.Nombre)
  FROM Pokemon t
  WHERE t.Nombre = @Nombre
  IF  @Cuanto > 0 
  BEGIN
     SET @mensaje = 'ERROR. Ya existe un Pokemon con esa nombre';
  END
  ELSE
  BEGIN
    INSERT Pokemon VALUES(@Nombre,@Preevolucion,@Evolucion,@Altura,@Peso,@IdTipoPoke);
	SET @mensaje = 'Pokemon registrado con exito con el folio ' + CONVERT(varchar,(@Ultimo + 1));
  END
END


CREATE PROCEDURE spAgregarPokeEntrena
(
  @IdEntrenador INT,
  @IdPokemon INT,
  @mensaje VARCHAR(50) OUTPUT
)
AS
  DECLARE @Cuanto SMALLINT;
  DECLARE @Ultimo SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto = 0;
  SET @Ultimo = 0;
  SELECT @Ultimo = MAX(t.IdEn_Poke) FROM Entrena_Poke t;
  SELECT @Cuanto = COUNT(t.IdEntrenador)
  FROM Entrena_Poke t
  WHERE t.IdEntrenador = @IdEntrenador
  IF  @Cuanto > 0 
  BEGIN
     SET @mensaje = 'ERROR. Ya existe un pokemon igual para este entrenador';
  END
  ELSE
  BEGIN
    INSERT Entrena_Poke VALUES(@IdEntrenador,@IdPokemon);
	SET @mensaje = 'Pokemon de entrenador registrado con exito con el folio ' + CONVERT(varchar,(@Ultimo + 1));
  END
END


--- PROCEDURES PARA ELIMINAR ---

CREATE PROCEDURE spEliminarEntrenador
  @IdEntrenador  INT,
  @mensaje VARCHAR(50) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SELECT @Cuanto = COUNT(t.Nombre) 
  FROM EntrenadorP t
  WHERE t.IdEntrenador = @IdEntrenador;
  IF  @Cuanto > 0 
  BEGIN
    DELETE  
	FROM EntrenadorP 
	WHERE EntrenadorP.IdEntrenador = @IdEntrenador;
    SET @mensaje = 'Se eliminó el entrenador con ese folio ' + CONVERT(varchar,(@IdEntrenador)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un entrenador con ese folio.';
  END
END



CREATE PROCEDURE spEliminarPokemon
  @IdPokemon  INT,
  @mensaje VARCHAR(50) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SELECT @Cuanto = COUNT(t.Nombre) 
  FROM Pokemon t
  WHERE t.IdPokemon = @IdPokemon
  IF  @Cuanto > 0 
  BEGIN
    DELETE  
	FROM Pokemon 
	WHERE Pokemon.IdPokemon = @IdPokemon;
    SET @mensaje = 'Se eliminó el Pokemon con ese folio ' + CONVERT(varchar,(@IdPokemon)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un Pokemon con ese folio.';
  END
END

CREATE PROCEDURE spEliminarMedallaEntrena
  @IdMedallaEntrenador  INT,
  @mensaje VARCHAR(50) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SELECT @Cuanto = COUNT(t.IdMedallaEntrenador) 
  FROM MedallaEntrenador t
  WHERE t.IdMedallaEntrenador = @IdMedallaEntrenador
  IF  @Cuanto > 0 
  BEGIN
    DELETE  
	FROM MedallaEntrenador 
	WHERE MedallaEntrenador.IdMedallaEntrenador = @IdMedallaEntrenador;
    SET @mensaje = 'Se eliminó la medalla con ese folio ' + CONVERT(varchar,(@IdMedallaEntrenador)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe una medalla con ese folio.';
  END
END


CREATE PROCEDURE spEliminarEntrePoke
  @IdEn_Poke  INT,
  @mensaje VARCHAR(50) OUTPUT 
AS
  DECLARE @Cuanto  SMALLINT;
BEGIN
  SET NOCOUNT ON; 
  SET @Cuanto  = 0;
  SELECT @Cuanto = COUNT(t.IdEn_Poke) 
  FROM Entrena_Poke t
  WHERE t.IdEn_Poke = @IdEn_Poke
  IF  @Cuanto > 0 
  BEGIN
    DELETE  
	FROM Entrena_Poke 
	WHERE Entrena_Poke.IdEn_Poke = @IdEn_Poke;
    SET @mensaje = 'Se eliminó el Pokemon/entrendaor con ese folio ' + CONVERT(varchar,(@IdEn_Poke)) + '.';
  END
  ELSE
  BEGIN
	SET @mensaje = 'ERROR. No existe un Pokemon/entrenador con ese folio.';
  END
END




drop table Medalla
drop table MedallaEntrenador
drop table Lider_Poke
drop table GimnasioP
drop table LiderP
drop table Entrena_Poke
drop table EntrenadorP
drop table Pokemon
drop table Ciudad
drop table Estado
drop table TipoPokemon
drop table TipoBatalla
drop table TipoGimnasio



