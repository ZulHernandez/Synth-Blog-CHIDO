use master;
GO
if not exists (select name from master.dbo.sysdatabases where name = N'synth') create database synth
GO

if not exists(select * from sysobjects where name='intereses' and xtype='U')
CREATE TABLE intereses (
    idInteres INT PRIMARY KEY NOT NULL,
    descripion NVARCHAR(50)
); 

if not exists(select * from sysobjects where name='tipoCuenta' and xtype='U')
CREATE TABLE tipoCuenta (
	idTipoCuenta INT PRIMARY KEY NOT NULL,
    descripcion NVARCHAR(50) NOT NULL
);

if not exists(select * from sysobjects where name='cuenta' and xtype='U')
CREATE TABLE cuenta (
    idCuenta INT PRIMARY KEY NOT NULL,
    idTipoCuenta INT,
    nombre NVARCHAR(50),
    apellidos NVARCHAR(50),
    usuario NVARCHAR(50),
    clave NVARCHAR(32),
    fechaNac DATE,
    correo NVARCHAR(300),
    correoR nvarchar(300),
    descripcion NVARCHAR(300),
    foto nvarchar(100),
    FOREIGN KEY (idTipoCuenta)
		REFERENCES tipoCuenta (idTipoCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

if not exists(select * from sysobjects where name='relInteresCuenta' and xtype='U')
CREATE TABLE relInteresCuenta (
    idRel INT PRIMARY KEY NOT NULL,
    idCuenta INT,
    idInteres INT,
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY (IdInteres)
		REFERENCES intereses(IdInteres)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

if not exists(select * from sysobjects where name='relSeguidorCuenta' and xtype='U')
CREATE TABLE relSeguidorCuenta (
    idRel INT PRIMARY KEY NOT NULL,
    idSeguidor INT,
    idCuenta INT,
    FOREIGN KEY (idSeguidor)
        REFERENCES cuenta (idCuenta)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

if not exists(select * from sysobjects where name='teoria' and xtype='U')
CREATE TABLE teoria (
    idTeoria INT PRIMARY KEY NOT NULL,
    fecha DATE,
    numConsultas INT,
    titulo NVARCHAR(100),
    descripcion NVARCHAR(300),
    cuerpo NVARCHAR(500)
);

if not exists(select * from sysobjects where name='contenidoT' and xtype='U')
CREATE TABLE contenidoT (
    idContenido INT PRIMARY KEY NOT NULL,
    idTeoria INT,
    contenido NVARCHAR(500),
    cabeceraC NVARCHAR(500),
    FOREIGN KEY (idTeoria)
        REFERENCES teoria (idTeoria)
        ON DELETE CASCADE ON UPDATE CASCADE
);

if not exists(select * from sysobjects where name='post' and xtype='U')
CREATE TABLE post (
    idPost INT PRIMARY KEY NOT NULL,
    idCuenta INT,
    idInteres INT,
    titulo NVARCHAR(100),
    texto NVARCHAR(500),
    fecha DATE,
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idInteres)
        REFERENCES intereses (idInteres)
        ON DELETE CASCADE ON UPDATE CASCADE
);

if not exists(select * from sysobjects where name='contenidoP' and xtype='U')
CREATE TABLE contenidoP (
    idContenido INT PRIMARY KEY NOT NULL,
    idPost INT,
    contenido NVARCHAR(500),
    cabecera NVARCHAR(100),
    FOREIGN KEY (idPost)
        REFERENCES post (idPost)
        ON DELETE CASCADE ON UPDATE CASCADE
); 

go
if OBJECT_ID('vwpost','V') is not null
	drop view vwpost;
go
create view vwpost as 
select post.idCuenta, post.idPost, post.fecha, post.titulo, post.texto, cuenta.foto, cuenta.usuario, intereses.descripion, contenidoP.contenido, contenidoP.cabecera 
from post 
inner join cuenta on cuenta.idCuenta = post.idCuenta 
inner join intereses on intereses.idInteres = post.idInteres
left join contenidoP on contenidoP.idPost = post.idPost;

go
if OBJECT_ID('_obtenPost','P') is not null 
    drop procedure dbo._obtenPost;
go
create procedure dbo._obtenPost @idC int as
begin
    set nocount on;
    select * from vwpost where vwpost.idCuenta = @idC;
end;

go
IF OBJECT_ID('_obtenIntereses','P') is not null
	DROP PROCEDURE dbo._obtenIntereses
go
CREATE procedure dbo._obtenIntereses
as
begin
set nocount on;
    select idInteres as Interes,descripion as Genero from intereses;
end;

go
IF OBJECT_ID('_validaRecuperacion','P') is not null
	DROP PROCEDURE dbo._validaRecuperacion
go
create procedure _validaRecuperacion(@correoC nvarchar(300), @corrRec nvarchar(300)) as
begin
set nocount on;
declare @msj nvarchar(64);
declare @existe int;
	set @existe=(select count(*) from cuenta where correo=@correoC and correoR=@corrRec);
    if @existe = 1 begin
		set @msj='Existe';
	end
    else begin
		set @msj='No encontrado';
    end;
    select @msj as Usr;
end;

go
IF OBJECT_ID('_recuperarCuenta','P') is not null
	DROP PROCEDURE dbo._recuperarCuenta
go
create procedure _recuperarCuenta @correoC nvarchar(300), @corrRec nvarchar(300),@nvaClav nvarchar(32) as
begin
	set nocount on;
	declare @msj nvarchar(64);
    declare @existe int;
    set @existe=(select count(*) from cuenta where correo=@correoC and correoR=@corrRec);
    if @existe =0 begin
		set @msj='No existe';
        select @msj as Regreso;
	end
    else begin
		update cuenta set cuenta.clave=@nvaClav,cuenta.foto=HASHBYTES('MD5',@nvaClav) where correo=@correoC and correoR=@corrRec;
		set @msj='Cuenta recuperada';
        select @msj as Regreso,cuenta.foto as Token from cuenta where correo=@correoC and correoR=@corrRec;
    end;
end;

go
IF OBJECT_ID('_activarCuenta','P') is not null
	DROP PROCEDURE dbo._activarCuenta
go
create procedure _activarCuenta @token nvarchar(300) as
begin
	set nocount on;
	declare @msj nvarchar(30);
    declare @existe int;
    declare @usr nvarchar(100);
    declare @pss nvarchar(100);
    select @existe = count(*) from cuenta where cuenta.foto = @token;
    if @existe = 0 begin
		set @msj = 'No se encontro la cuenta';
    end
	else begin
		select @usr = correo from cuenta where cuenta.foto = @token;
        select @pss = clave from cuenta where cuenta.foto = @token;
		update cuenta set foto='/Synth_BLOG/img/fondomusica1.jpg' where foto = @token;
		set @msj = 'Cuenta activada';
    end;
	select @msj as Activacion,@usr as corr,@pss as clav;
end;

go
IF OBJECT_ID('_traePerfil','P') is not null
	DROP PROCEDURE dbo._traePerfil
go
CREATE procedure dbo._traePerfil( @id int)
as
begin
set nocount on;
    declare @msj nvarchar(50);
    declare @exist int;
    set @exist = (select count(*) from cuenta where idCuenta=@id);
    if @exist=0 begin
        set @msj='No existe';
        select @msj as estado;
    end
    else begin
        set @msj='Encontrado';
        select @msj as estado,cuenta.usuario as nombre,cuenta.clave as contra,cuenta.correo as mail,cuenta.descripcion as descrip,cuenta.foto as fotoUsr from cuenta where cuenta.idCuenta=@id;
    end 
end;

go
IF OBJECT_ID('_obtenCuenta','P') is not null
	DROP PROCEDURE dbo._obtenCuenta
go
CREATE procedure _obtenCuenta( @corr nvarchar(60), @con nvarchar(32))
as
begin
set nocount on;
    declare @existe int;
    declare @msg nvarchar(60);
    declare @us nvarchar(60);
	declare @tipous int;
    declare @activo nvarchar(60);
 select @existe = count(*) from cuenta where correo = @corr and clave = @con;
    if @existe = 1 begin
		select @msg = idCuenta from cuenta where correo = @corr and clave = @con;
		select @us = usuario from cuenta where correo = @corr and clave = @con;
		select @activo = foto from cuenta where correo = @corr and clave = @con;
		select @tipous = idTipoCuenta from cuenta where correo = @corr and clave = @con;
    end
    else begin
        set @msg = 0;
        set @us = '';
        set @activo = '';
		set @tipous = 0;
    end 
    select @msg,@us,@activo,@tipous;
end;

go
IF OBJECT_ID('_registraCuenta','P') is not null
	DROP PROCEDURE dbo._registraCuenta
go
CREATE procedure _registraCuenta( @nom nvarchar(50), @aP nvarchar(50), @usu nvarchar(50), @contra nvarchar(32), @fecha date, @cor nvarchar(300), @corrR nvarchar(300), @des nvarchar(300))
as
begin
set nocount on;
declare @idI int;
declare @existe int;
declare @msg nvarchar(60);
 select @existe = count(*) from cuenta where correo= @cor;
        if @existe = 1 begin
            set @msg = 'Registro existente.';
        end
        else begin 
         set @idI = (select case when max(idCuenta) is null then  0 else null end + 1 from cuenta);
            insert into cuenta values (@idI,2,@nom,@aP,@usu,@contra,@fecha,@cor,@corrR,@des,HASHBYTES('MD5',@cor));
            set @msg =  'Registro exitoso.';
        end 
SELECT @msg;
end;

go
IF OBJECT_ID('_modificarCuenta','P') is not null
	DROP PROCEDURE dbo._modificarCuenta
go
CREATE procedure _modificarCuenta( @id int, @contra nvarchar(32), @dato nvarchar(300) , @tipoModif int)
as
begin
set nocount on; 
declare @existe int;
declare @intere nvarchar(60);
declare @msj nvarchar(50);
 select @existe = count(*) from cuenta where idCuenta=@id and clave=@contra;
   if @existe = 0 begin 
        set @msj = 'Datos incorrectos o contrasenia erronea.';
   end
   else begin
    if @tipoModif=1 begin
            update cuenta set usuario=@dato where idCuenta=@id;
            set @msj =  'Nombre modificado.';
    end
    else begin
        if @tipoModif=2 begin
            update cuenta set clave=@dato where idCuenta=@id;
            set @msj='Clave modificada';
        end
        else begin
            if @tipoModif = 3 begin
            update cuenta set correo=@dato where idCuenta=@id;
            set @msj='Correo modificado';
            end
            else begin
                if @tipoModif = 4 begin
                        
                        select @intere = count(*) from interes where idInteres=@dato;
                     select @existe = count(*) from relinterescuenta where idCuenta=@id and idInteres=@intere;
                        if @existe =0  begin
                         if @intere=0 begin
                            set @msj='Interes inexistente';
                         end
                        else begin
                         select @existe = case when max(idRel) is null then  0 else null end + 1 from relinterescuenta;
                            insert into relinterescuenta values(@existe,@id,@dato);
                            set @msj='Interes modificado';
                         end 
                        end
                        else begin
                            set @msj='Interes ya existente';
                        end 
                end
                else begin
                    if @tipoModif=5 begin
                        update cuenta set descripcion=@dato where idCuenta=@id;
                        set @msj='Descripcion modificada';
                    end
                    else begin
                    if @tipoModif=6 begin
                        update cuenta set foto=@dato where idCuenta=@id;
                        set @msj='Foto modificada';
                    end
                    else begin
                     set @msj='Modifificacion no disponible';
                     end 
                    end 
                end 
            end 
        end 
    end 
   end 
   select @msj as Estado; 
end;

go
IF OBJECT_ID('_eliminarCuenta','P') is not null
	DROP PROCEDURE dbo._eliminarCuenta
go
CREATE procedure _eliminarCuenta( @cor nvarchar(300), @contra nvarchar(32))
as
begin
set nocount on; 
declare @existe int;
declare @msj nvarchar(50);
 select @existe = count(*) from cuenta where correo = @cor and clave =  @contra;
    if @existe = 0 begin
        set @msj =  'Registio inexistente.';
    end
    else begin
        delete from cuenta where correo = @cor and clave =  @contra;
        set @msj = 'Registro eliminado.';
    end 
    select @msj; 
end;

go
IF OBJECT_ID('_registraSeguidor','P') is not null
	DROP PROCEDURE dbo._registraSeguidor
go
CREATE procedure _registraSeguidor( @id1 int, @id2 int)
as
begin
set nocount on;
    declare @existe int;
    declare @idI int;
    declare @msj nvarchar(50);
 select @existe = count(*) from relSeguidorCuenta where idSeguidor = @id1 and idCuenta =  @id2;
    if @existe = 1 begin
        set @msj =  'Registio existente.';
    end
    else begin
     select @idI = case when max(idRel) is null then 0 else max(idRel) end + 1 from relSeguidorCuenta;
        insert into relSeguidorCuenta values(@idI,@id1,@id2);
        set @msj = 'Registro ejecutado.';
    end 
    select @msj; 
end;

go
IF OBJECT_ID('_subirTeoria','P') is not null
	DROP PROCEDURE dbo._subirTeoria
go
CREATE procedure _subirTeoria( @title nvarchar(100), @des nvarchar(300), @body nvarchar(500))
as
begin
set nocount on;
declare @existe int;
declare @idT int; 
declare @msj nvarchar(50);
 select @existe = count(*) from teoria where titulo=@title and descripcion=@des and cuerpo=@body;
 select @idT = case when max(idTeoria) is null then 0 else max(idTeoria) end+1 from teoria; 
if(@existe > 0) begin 
    set @msj = 'Registro existente.';
end
else begin 
    insert into teoria (idTeoria, titulo, descripcion, cuerpo, fecha, numConsultas) values (@idT, @title, @des, @body,getdate(),0);
    set @msj = 'Registro exitoso';
end  
    select @msj,@idT;
end;

go
IF OBJECT_ID('_eliminarTeoria','P') is not null
	DROP PROCEDURE dbo._eliminarTeoria
go
CREATE procedure _eliminarTeoria( @idT int)
as
begin
set nocount on; 
declare @existe int; 
declare @msj nvarchar(50);
 select @existe = count(*) from teoria where idTeoria= @idT; 
if(@existe = 0) begin
    set @msj ='Registro inexistente.';
end
else begin 
    delete from teoria where idTeoria=@idT; 
    set @msj = 'Registro eliminado';
end 
    select @msj;
end;

go
IF OBJECT_ID('_registraContenido','P') is not null
	DROP PROCEDURE dbo._registraContenido
go
create procedure _registraContenido @idteo int, @cont nvarchar(max), @cabe nvarchar(500), @suich int as
begin
declare @idI int;
declare @msj nvarchar(50);
if (@suich = 1) begin
	select @idI = case when max(idContenido) is null then 0 else max(idContenido) end + 1 from contenidoT;
	insert into contenidoT values(@idI,@idteo,@cont,@cabe);
	set @msj =  'Registro de contenido exitoso.';
end;
else begin
	if(@suich = 2) begin
		select @idI = case when max(idContenido) is null then 0 else max(idContenido) end + 1 from contenidoP;
		insert into contenidoP values(@idI,@idteo,@cont,@cabe);
		set @msj =  'Registro de contenido exitoso.';
	end;
    else begin
		set @msj = 'ERROR: No se registro el contenido debido a que no se reconocio la peticion';
    end;
end;
select @msj;
end;

go
IF OBJECT_ID('_eliminaContenidoT','P') is not null
	DROP PROCEDURE dbo._eliminaContenidoT
go
CREATE procedure _eliminaContenidoT( @idd int)
as
begin
set nocount on;
declare @existe int;
declare @msj nvarchar(50);
 select @existe = count(*) from contenidoT where idContenido = @idd;
    if @existe = 0  begin 
        set @msj =  'Registro inexistente.';
    end
    else begin
        delete from contenidoT where idContenido = @idd;
        set @msj =  'Registro eliminado.';
    end 
    select @msj; 
end;

go
IF OBJECT_ID('_nuevoPost','P') is not null
	DROP PROCEDURE dbo._nuevoPost
go
CREATE procedure _nuevoPost( @idC int, @idI int, @title nvarchar(100), @txt nvarchar(500))
as
begin
set nocount on; 
declare @existe  int; 
declare @idP int; 
declare @msj nvarchar(50);
  select @existe = count(*) from post where idCuenta=@idC and titulo = @title;
if(@existe = 1) begin 
    set @msj = 'Registro existente.'; 
	set @idP = -1;
end
else begin 
	set @idP = (select case when max(idPost) is null then 0 else max(idPost) end+1 from post); 
    insert into post (idPost, idCuenta, idInteres, titulo, texto, fecha) values (@idP, @idC, @idI, @title, @txt, getdate());    
    set @msj = 'Registro exitoso';
	end 
    select @msj,@idP;
end;

go
IF OBJECT_ID('_modificarPost','P') is not null
	DROP PROCEDURE dbo._modificarPost
go
CREATE procedure _modificarPost( @title nvarchar(100), @txt nvarchar(500), @idI int, @idP int)  
as
begin
set nocount on; 
declare @msj nvarchar(50);
declare @existe int; 
 select @existe = count(*) from post where @idP = idPost;
if(@existe = 0) begin
    set @msj = 'Registro inexistente.';
end
else begin 
    update post set texto = @txt where idInteres=@idI and titulo=@title;
    set @msj = 'Registro modificado';
end  
select @msj;
end;

go
IF OBJECT_ID('_eliminarPost','P') is not null
	DROP PROCEDURE dbo._eliminarPost
go
CREATE procedure _eliminarPost( @idP int)
as
begin
set nocount on; 
declare @existe int;
declare @msj nvarchar(50); 
 select @existe = count(*) from post where idPost=@idP; 
if (@existe = 0) begin 
    set @msj = 'Registro inexistente.';
end
else begin 
    delete from post where idPost=@idP;
    set @msj ='Registro eliminado';
end  
    select @msj;
end;

INsert INto intereses values (1,'Rock and Roll');
INsert INto intereses values (2,'Pop');
INsert INto intereses values (3,'Rap');
INsert INto intereses values (4,'Ska');
INsert INto intereses values (5,'Reggae');
INsert INto intereses values (6,'Jazz');
INsert INto intereses values (7,'Musica Clasica');
INsert INto intereses values (8,'Reggaeton');
INsert INto intereses values (9,'Salsa');
INsert INto intereses values (10,'Cumbia'); 
INsert INto intereses values (11,'Electronica');
INsert INto intereses values (12,'Metal');
INsert INto intereses values (13,'Tango');
INsert INto intereses values (14,'Disco');
INsert INto intereses values (15,'Blues');

INSERT INTO tipoCuenta VALUES (1,'Administrador');
INSERT INTO tipoCuenta VALUES (2,'Alumno');

INSERT INTO cuenta VALUES (1,1,
                        'Marsoft',
                        'Empresa',
                        'Marsoft',
                        'marsoft',
                        '2015-08-23',
                        'marsoft@gmail.com',
                        'beareating59814@gmail.com',
                        'Somos una empresa desarrolladora de software',
                        '/Synth_BLOG/img/fondomusica1.jpg');