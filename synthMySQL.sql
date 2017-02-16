drop database if exists synth;
create database synth; 
use synth;
#LA MIA 
CREATE TABLE intereses (
    idInteres INT(3) PRIMARY KEY NOT NULL,
    descripion NVARCHAR(50)
); 


CREATE TABLE tipoCuenta (
	idTipoCuenta INT(3) PRIMARY KEY NOT NULL,
    descripcion NVARCHAR(50) NOT NULL
);

CREATE TABLE cuenta (
    idCuenta INT(3) PRIMARY KEY NOT NULL,
    idTipoCuenta INT(1),
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
CREATE TABLE relInteresCuenta (
    idRel INT(3) PRIMARY KEY NOT NULL,
    idCuenta INT(3),
    idInteres INT(3),
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (IdInteres)
		REFERENCES intereses(IdInteres)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE relSeguidorCuenta (
    idRel INT(3) PRIMARY KEY NOT NULL,
    idSeguidor INT(3),
    idCuenta INT(3),
    FOREIGN KEY (idSeguidor)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idcuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE teoria (
    idTeoria INT(3) PRIMARY KEY NOT NULL,
    fecha DATE,
    numConsultas INT(5),
    titulo NVARCHAR(100),
    descripcion NVARCHAR(300),
    cuerpo NVARCHAR(500)
);

CREATE TABLE contenidoT (
    idContenido INT(3) PRIMARY KEY NOT NULL,
    idTeoria INT(3),
    contenido NVARCHAR(500),
    cabeceraC NVARCHAR(500),
    FOREIGN KEY (idTeoria)
        REFERENCES teoria (idTeoria)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE post (
    idPost INT(3) PRIMARY KEY NOT NULL,
    idCuenta INT(3),
    idInteres INT(3),
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
CREATE TABLE contenidoP (
    idContenidoP INT(3) PRIMARY KEY NOT NULL,
    idPost INT(3),
    contenido NVARCHAR(500),
    cabeceraC NVARCHAR(100),
    FOREIGN KEY (idPost)
        REFERENCES post (idPost)
        ON DELETE CASCADE ON UPDATE CASCADE
); 

#Hace lo mismo
drop procedure if exists _obtenCategorias;
delimiter gatito
create procedure _obtenCategorias()
begin
	select * from intereses;
end gatito
delimiter ;

drop procedure if exists _obtenTeoria;
delimiter gatito
create procedure _obtenTeoria(in idT int(3))
begin
	if(idT = -1) then
		select * from teoria;
	else
		update teoria set numConsultas = numConsultas + 1 where idTeoria = idT;
		select * from teoria where idTeoria = idT;
	end if;
end gatito
delimiter ;

select * from teoria;
drop procedure if exists _obtenContenido;
delimiter gatito
create procedure _obtenContenido(in idT int(3))
begin
	declare existe int;
    set existe = (select count(*) from teoria where idTeoria = idT);
    if (existe = 1) then
		select * from contenidoT where idTeoria = idT;
	else
		select '-1' as idContenido;
	end if;
end gatito
delimiter ;
select * from contenidoT;
#Hace lo mismo
drop procedure if exists _obtenIntereses;
delimiter **
create procedure _obtenIntereses()
begin
    select idInteres as Interes,descripion as Genero from intereses;
end **
delimiter ;

drop procedure if exists _validaRecuperacion;
delimiter **
create procedure _validaRecuperacion(in correoC nvarchar(300), in corrRec nvarchar(300))
begin
declare msj nvarchar(64);
declare existe int(1);
	set existe=(select count(*) from cuenta where correo=correoC and correoR=corrRec);
    if existe = 1 then
		set msj='Existe';
    else
		set msj='No encontrado';
    end if;
    select msj as Usr;
    end; **
delimiter ;

drop procedure if exists _recuperarCuenta;
delimiter **
create procedure _recuperarCuenta(in correoC nvarchar(300), in corrRec nvarchar(300),in nvaClav nvarchar(32))
begin
	declare msj nvarchar(64);
    declare existe int(1);
    set existe=(select count(*) from cuenta where correoC=correo and correoR=corrRec);
    if existe =0 then
		set msj='No existe';
        select msj as Regreso;
    else
		update cuenta set clave=nvaClav,foto=md5(nvaClav) where correo=correoC and correoR=corrRec;
		set msj='Cuenta recuperada';
        select msj as Regreso,cuenta.foto as Token from cuenta where correo=correoC and correoR=corrRec;
    end if;
    end;**
delimiter ;
    
#PROCEDURE MODIFICADO!
drop procedure if exists _activarCuenta;
delimiter **
create procedure _activarCuenta(in token nvarchar(300))
begin
	declare msj nvarchar(30);
    declare existe int(1);
    declare usr nvarchar(100);
    declare pss nvarchar(100);
    set existe=(select count(*) from cuenta where foto=token);
    if existe = 0 then
		set msj='No se encontro la cuenta';
    else
		set usr=(select correo from cuenta where foto=token);
        set pss=(select clave from cuenta where foto=token);
		update cuenta set foto='/Synth_BLOG/img/fondomusica1.jpg' where foto=token;
        
		set msj='Cuenta activada';
    end if;
select msj as Activacion,usr as corr,pss as clav;
end; **
delimiter ; 

drop procedure if exists _traePerfil;
delimiter **
create procedure _traePerfil(in id int(3))
begin
	declare msj nvarchar(50);
    declare exist int(1);
    set exist=(select count(*) from cuenta where idCuenta=id);
    if exist=0 then
		set msj='No existe';
        select msj as estado;
	else
		set msj='Encontrado';
        select msj as estado,cuenta.usuario as nombre,cuenta.clave as contra,cuenta.correo as mail,cuenta.descripcion as descrip,cuenta.foto as fotoUsr from cuenta where cuenta.idCuenta=id;
    end if;
end; **
delimiter ;



drop procedure if exists _obtenCuenta;
delimiter **
create procedure _obtenCuenta(in corr nvarchar(60), in con nvarchar(32))
begin
	declare existe int;
	declare msg nvarchar(60);
	declare us nvarchar(60);
    declare tipous int;
    declare activo nvarchar(60);
	set existe = (select count(*) from cuenta where correo = corr and clave = con);
	if existe = 1 then
		set msg = (select idCuenta from cuenta where correo = corr and clave = con);
		set us = (select usuario from cuenta where correo = corr and clave = con);
        set activo = (select foto from cuenta where correo = corr and clave = con);
        set tipous = (select idTipoCuenta from cuenta where correo = corr and clave = con);
	else
		set msg = 0;
		set us = '';
        set activo = '';
        set tipous = 0;
	end if;
	select msg,us,activo,tipous;
	end **
delimiter ;


drop procedure if exists _registraCuenta;
delimiter **
create procedure _registraCuenta(in nom nvarchar(50), in aP nvarchar(50), in usu nvarchar(50), in contra nvarchar(32), in fecha date, in cor nvarchar(300),in corrR nvarchar(300),in des nvarchar(300))
begin
declare idI int;
declare existe int;
declare msg nvarchar(60);
	set existe = (select count(*) from cuenta where correo= cor);
		if existe = 1 then
			set msg = 'Registro existente.';
		else 
			set idI = (select ifnull(max(idCuenta), 0) + 1 from cuenta);
			insert into cuenta values (idI,2,nom,aP,usu,contra,fecha,cor,corrR,des,md5(cor));
			set msg =  'Registro exitoso.';
		end if;
SELECT msg;
end  **
delimiter ;

select * from cuenta;
drop procedure if exists _modificarCuenta;
delimiter **
create procedure _modificarCuenta(in id int(3), in contra nvarchar(32),in dato nvarchar(300) , in tipoModif int(1))
begin 
declare existe int(3);
declare intere nvarchar(60);
declare msj nvarchar(50);
set existe = (select count(*) from cuenta where idCuenta=id and clave=contra);
   if existe = 0 then 
		set msj = 'Datos incorrectos o contrasenia erronea.';
   else
	if tipoModif=1 then
			update cuenta set usuario=dato where idCuenta=id;
			set msj =  'Nombre modificado.';
	else
		if tipoModif=2 then
			update cuenta set clave=dato where idCuenta=id;
            set msj='Clave modificada';
        else
			if tipoModif = 3 then
            update cuenta set correo=dato where idCuenta=id;
            set msj='Correo modificado';
            else
				if tipoModif = 4 then

                        set intere=(select count(*) from intereses where idInteres=dato);
						set existe=(select count(*) from relinterescuenta where idCuenta=id and idInteres=dato);
                        if existe =0  then
                         if intere=0 then
							set msj='Interes inexistente';
						 else
							set existe=(select ifnull(max(idRel), 0) + 1 from relinterescuenta);
							insert into relinterescuenta values(existe,id,dato);
                            set msj='Interes modificado';
						 end if;
						else
						    set msj='Interes ya existente';
                        end if;
                else
					if tipoModif=5 then
						update cuenta set descripcion=dato where idCuenta=id;
						set msj='Descripcion modificada';
					else
                    if tipoModif=6 then
						update cuenta set foto=dato where idCuenta=id;
						set msj='Foto modificada';
                    else
                     set msj='Modifificacion no disponible';
                     end if;
					end if;
                end if;
            end if;
        end if;
	end if;
   end if;
   select msj as Estado; 
end; **
delimiter ;



drop procedure if exists _eliminarCuenta;
delimiter **
create procedure _eliminarCuenta(in cor nvarchar(300), in contra nvarchar(32))
begin 
declare existe int;
declare msj nvarchar(50);
	set existe = (select count(*) from cuenta where correo = cor and clave =  contra);
    if existe = 0 then
		set msj =  'Registio inexistente.';
	else
		delete from cuenta where correo = cor and clave =  contra;
        set msj = 'Registro eliminado.';
	end if;
    select msj; 
end **
delimiter ;

#Editado por: Daniel
drop procedure if exists _registraSeguidor;
delimiter **
create procedure _registraSeguidor(in id int, in ids int)
begin
	declare existe int;
    declare idI int;
	set existe = (select count(*) from relSeguidorCuenta where idSeguidor = ids and idCuenta =  id);
    if existe = 1 then
		delete from relseguidorcuenta where idCuenta = id and idSeguidor = ids;
	else
		set idI = (select ifnull(max(idRel),0) + 1 from relSeguidorCuenta);
		insert into relSeguidorCuenta values(idI,ids,id);
	end if;
end **
delimiter ;
select * from relseguidorcuenta;
drop procedure if exists _subirTeoria;
delimiter **
create procedure _subirTeoria(in title nvarchar(100), in des nvarchar(300), in body nvarchar(500))
begin
declare existe int;
declare idT int; 
declare msj nvarchar(50);
set existe = (select count(*) from teoria where titulo=title and descripcion=des and cuerpo=body);
set idT = (select ifnull(max(idTeoria),0)+1 from teoria); 
if(existe > 0) then 
	set msj = 'Registro existente.';
else 
	insert into teoria (idTeoria, titulo, descripcion, cuerpo, fecha, numConsultas) values (idT, title, des, body,now(),0);
    set msj = 'Registro exitoso';
end if; 
	select msj,idT;
end** 
delimiter ; 

drop procedure if exists _eliminarTeoria** 
delimiter **
create procedure _eliminarTeoria(in idT int)
begin 
declare existe int; 
declare msj nvarchar(50);
set existe = (select count(*) from teoria where idTeoria= idT); 
if(existe = 0) then
	select msj ='Registro inexistente.';
else 
	delete from teoria where idTeoria=idT; 
    select msj = 'Registro eliminado';
end if;
	select msj;
end**  
delimiter ;

drop procedure if exists _registraContenido;
delimiter **
create procedure _registraContenido(in idteo int(3), in cont nvarchar(10000), in cabe nvarchar(500), in suich int(2))
begin
declare idI int;
declare msj nvarchar(50);
if (suich = 1) then
	set idI = (select ifnull(max(idContenido), 0) + 1 from contenidoT);
	insert into contenidoT values(idI,idteo,cont,cabe);
	set msj =  'Registro de contenido exitoso.';
else 
	if(suich = 2) then
		set idI = (select ifnull(max(idContenidoP), 0) + 1 from contenidoP);
		insert into contenidoP values(idI,idteo,cont,cabe);
		set msj =  'Registro de contenido exitoso.';
    else
		set msj = 'ERROR: No se registro el contenido debido a que no se reconocio la peticion';
    end if;
end if;
select msj;
end **
delimiter ;

drop procedure if exists _eliminaContenidoT**
delimiter **
create procedure _eliminaContenidoT(in idd int(3))
begin
declare existe int;
declare msj nvarchar(50);
	set existe = (select count(*) from contenidoT where idContenido = idd);
    if existe = 0  then 
		set msj =  'Registro inexistente.';
	else
		delete from contenidoT where idContenido = idd;
        set msj =  'Registro eliminado.';
    end if;
    select msj; 
end **
delimiter ;



drop procedure if exists _nuevoPost;
delimiter **
create procedure _nuevoPost(in idC int(3), in idI int(3), in title nvarchar(100), in txt nvarchar(500))
begin 
declare existe  int; 
declare idP int; 
declare msj nvarchar(50);
set existe =  (select count(*) from post where idCuenta=idC and titulo = title);
if(existe = 1) then 
	set msj = 'Ya existe un post con el mismo titulo'; 
    set idP = -1;
else 
	set idP = (select ifnull(max(idPost),0)+1 from post); 
    insert into post (idPost, idCuenta, idInteres, titulo, texto, fecha) values (idP, idC, idI, title, txt, now()); 	
	set msj = 'Registro exitoso';
end if;
select msj, idP;
end**
delimiter ;

drop procedure if exists _modificarPos;
delimiter **
create procedure _modificarPost(in title nvarchar(100), in txt nvarchar(500), in idI int, in idP int)  
begin 
declare msj nvarchar(50);
declare existe int; 
set existe = (select count(*) from post where idP = idPost);
if(existe = 0) then
	select msj = 'Registro inexistente.';
else 
	update post set texto = txt where idInteres=idI and titulo=title;
    select msj = 'Registro modificado';
end if; 
select msj;
end** 
delimiter ;

drop procedure if exists _eliminarPost**
delimiter **
create procedure _eliminarPost(in idP int)
begin 
declare existe int;
declare msj nvarchar(50); 
set existe = (select count(*) from post where idPost=idP); 
if (existe = 0) then 
	select msj = 'Registro inexistente.';
else 
	delete from post where idPost=idP;
    select msj ='Registro eliminado';
end if; 
	select msj;
end** 
delimiter ;

#linea modificada
drop procedure if exists _buscar;
delimiter **
create procedure _buscar(in paramBsq nvarchar(100))
begin
	declare existe int(1);
    
    
    select idCuenta as registro,usuario as nombre,descripcion as texto,'Usuario' as tipoResultado from cuenta where usuario regexp paramBsq union all 
    select idTeoria as registro, titulo as nombre,descripcion as texto, 'Articulo' as tipoResultado from teoria where titulo regexp paramBsq;
end **
delimiter ;

/*drop procedure if exists _buscarPorInteres;
delimiter **
create procedure _buscarPorInteres(in paramBsq nvarchar(100))
begin
	declare existe int(1);
    declare msj nvarchar(60);
    set existe=(select count(*) from intereses where descripion=paramBsq);
    if existe = 1  then
		
    else
		set msj='No existe interes';
        select msj as Resultado;
    end if;
end **
delimiter ;*/

#Agregado por: Daniel
drop view if exists vwpost;
create view vwpost as 
select cuenta.idCuenta, cuenta.usuario, cuenta.foto, post.idPost, post.idInteres, intereses.descripion as interes, post.titulo, post.texto, post.fecha,
(select contenidop.contenido from contenidop where contenidop.idPost = post.idPost and contenidop.contenido like '%imagen%') as imagenpost,
(select contenidop.cabeceraC from contenidop where contenidop.idPost = post.idPost and contenidop.contenido like '%imagen%') as cabeceraimagenpost,
(select contenidop.contenido from contenidop where contenidop.idPost = post.idPost and contenidop.contenido like '%audio%') as audiopost,
(select contenidop.cabeceraC from contenidop where contenidop.idPost = post.idPost and contenidop.contenido like '%audio%') as cabeceraaudiopost
from cuenta inner join post on cuenta.idCuenta = post.idCuenta
inner join intereses on post.idInteres = intereses.idInteres;

#Agregado por: Daniel
drop procedure if exists _obtenPost;
delimiter gatito
create procedure _obtenPost(in idC int)
begin
	select * from vwpost where vwpost.idCuenta = idC order by fecha desc,idPost desc;
end gatito
delimiter ;

#Agregado por: Daniel
drop procedure if exists _traePostInicio;
delimiter qwe
create procedure _traePostInicio(in id int)
begin
	declare stmtSeguidores nvarchar(1000);
    declare stmtIntereses nvarchar(1000);
	set @resultquery = null;
    set stmtSeguidores = (select group_concat(concat('select * from vwpost where vwpost.idCuenta = ',relSeguidorCuenta.idCuenta) separator '\r\nUNION\r\n') from relseguidorcuenta where relseguidorcuenta.idSeguidor = id);
    set stmtIntereses = (select group_concat(concat('select * from vwpost where vwpost.idInteres = ',relInteresCuenta.idInteres) separator '\r\nUNION\r\n') from relInteresCuenta where relInteresCuenta.idCuenta = id);
    if(stmtSeguidores = '' or stmtSeguidores is null) then
		if(stmtIntereses = '' or stmtIntereses is null)then
			select 'select * from vwpost where vwpost.idCuenta = 0' into @resultquery;
        else
			select stmtIntereses into @resultquery;
        end if;
    else
		if(stmtIntereses = '' or stmtIntereses is null) then
			select stmtSeguidores into @resultquery;
        else
			select concat(stmtSeguidores,'\r\nUNION\r\n',stmtIntereses) into @resultquery;
        end if;
    end if;
	prepare stmt from @resultquery;
    execute stmt;
end qwe
delimiter ;

#Agregado por: Daniel
drop procedure if exists _obtenListaSeguidos;
delimiter qwe
create procedure _obtenListaSeguidos(in id int)
begin
	select idCuenta from relseguidorcuenta where idSeguidor = id;
end qwe
delimiter ;

INsert INto intereses values(1,'Rock and Roll');
INsert INto intereses values(2,'Pop');
INsert INto intereses values(3,'Rap');
INsert INto intereses values(4,'Ska');
INsert INto intereses values(5,'Reggae');
INsert INto intereses values(6,'Jazz');
INsert INto intereses values(7,'Musica Clasica');
INsert INto intereses values(8,'Reggaeton');
INsert INto intereses values(9,'Salsa');
INsert INto intereses values(10,'Cumbia'); 
INsert INto intereses values(11,'Electronica');
INsert INto intereses values(12,'Metal');
INsert INto intereses values(13,'Tango');
INsert INto intereses values(14,'Disco');
INsert INto intereses values(15,'Blues');

#linea modificada
INSERT INTO tipoCuenta VALUES(1,'Administrador');
INSERT INTO tipoCuenta VALUES(2,'Persona');
#linea modificada
INSERT INTO cuenta VALUES(1,1,
						'Marsoft',
                        'Empresa',
                        'Marsoft',
						'marsoft',
                        '2015-08-23',
                        'marsoft@gmail.com',
                        'beareating59814@gmail.com',
                        'Somos una empresa desarrolladora de software',
                        '/Synth_BLOG/img/fondomusica1.jpg'),
                        (2,
                        2,
                        'Cuenta2',
                        'Apellidos2',
                        'User2',
                        'Clave2',
                        '2015-08-23',
                        'correo2@gmail.com',
                        'correoR2@gmail.com',
                        'Descripcion user 2',
                        '/Synth_BLOG/img/fondomusica1.jpg'),
                        (3,
							2,
							'Cuenta3',
							'Apellidos3',
							'User3',
							'Clave3',
							'2015-08-23',
							'correo3@gmail.com',
							'correoR3@gmail.com',
							'Descropcion user 3',
							'/Synth_BLOG/img/fondomusica1.jpg'),
						(4,
							2,
							'Cuenta4',
							'Apellidos4',
							'User4',
							'Clave4',
							'2015-08-23',
							'correo4@gmail.com',
							'correoR4@gmail.com',
							'Descropcion user 4',
							'/Synth_BLOG/img/fondomusica1.jpg'),
						(5,
                        
							2,
							'Cuenta5',
							'Apellidos5',
							'User5',
							'Clave5',
							'2015-08-23',
							'correo5@gmail.com',
							'correoR5@gmail.com',
							'Descropcion user 5',
							'/Synth_BLOG/img/fondomusica1.jpg');
#Linea modificada
insert into relinterescuenta values(1,1,1),(2,1,3),(3,2,2),(4,2,4),(5,3,7),(6,2,7);