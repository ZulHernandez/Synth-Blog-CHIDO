create table interes(
idInteres serial primary key not null,
descripcion text); 

insert into interes values (1,'Rock and Roll');
insert into interes values (2,'Pop');
insert into interes values (3,'Rap');
insert into interes values (4,'Ska');
insert into interes values (5,'Reggae');
insert into interes values (6,'Jazz');
insert into interes values (7,'Musica Clasica');
insert into interes values (8,'Reggaeton');
insert into interes values (9,'Salsa');
insert into interes values (10,'Cumbia');
insert into interes values (11,'Electronica');
insert into interes values (12,'Metal');
insert into interes values (13,'Tango');
insert into interes values (14,'Disco');

create table relInteresCuenta( 
idRel serial primary key not null,
idCuenta integer,
idInteres integer,
foreign key (idCuenta) references cuenta (idCuenta)  on delete cascade on update cascade);  

create table seguidor(
idSeguidor serial primary key not null,
idCuenta integer,
foreign key (idCuenta) references cuenta (idCuenta)  on delete cascade on update cascade);

create table relSeguidorCuenta(
idRel serial primary key not null, 
idSeguidor integer, 
idCuenta integer,
foreign key (idSeguidor) references seguidor (idSeguidor)  on delete cascade on update cascade,
foreign key (idcuenta) references cuenta (idCuenta)  on delete cascade on update cascade); 

create table contenidoT(
idContenido serial primary key not null, 
idTeoria integer,
contenido text, 
cabeceraC text, 
foreign key (idTeoria) references teoria (idTeoria)  on delete cascade on update cascade);

create table post(
idPost serial primary key not null,
idCuenta integer, 
idIntereses integer, 
titulo text,
texto text,
fecha date,
foreign key (idCuenta) references cuenta (idCuenta) on delete cascade on update cascade,
foreign key (idIntereses) references interes (idInteres) on delete cascade on update cascade);  

create table contenidoP(
idContenidoP serial primary key not null, 
idPost integer,
contenido text,
cabeceraC text,
foreign key (idPost) references post (idPost) on delete cascade on update cascade); 

create table teoria(
idTeoria serial primary key not null, 
fecha date, 
numConsultas integer,
titulo text,
descripcion text, 
cuerpo text); 

create table cuenta(
idCuenta serial primary key not null,
tipoCuenta integer,
nombre text, 
apellidoP text,
apellidoM text, 
usuario text,
clave text, 
fechaNac date,
correo text,
descripcion text, 
foto text); 


CREATE OR REPLACE FUNCTION _subirTeoria(title text, des text, in body text )
RETURNS integer AS
$$		
	INSERT INTO teoria(fecha,numConsultas,titulo, descripcion,cuerpo) VALUES (now(),0,$1, $2,$3)
    RETURNING idTeoria;   
$$
LANGUAGE 'sql' VOLATILE;
SELECT _subirTeoria('Holi', 'Holi nn', 'Holibody') As new_idTeoria;
select * from teoria;


CREATE OR REPLACE FUNCTION _eliminarTeoria(idT integer)
RETURNS void AS
$$
	DELETE FROM teoria WHERE idTeoria = $1;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _eliminarTeoria(6);
select * from teoria;


CREATE OR REPLACE FUNCTION  _registraCuenta( nom text,aP text,  aM text,usu text, contra text, fecha date,cor text,des text, fot text)
RETURNS integer AS
$$
	INSERT INTO cuenta(tipoCuenta,nombre,apellidoP,apellidoM,usuario,clave,fechaNac,correo,descripcion,foto) VALUES (0,$1,$2,$3,$4,$5,$6,$7,$8,$9)
    RETURNING idCuenta;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _registraCuenta( 'Laus' , 'More', 'Bel' , 'Lauss', 'lll' , '2016-08-20', 'majamxdj@gmail.com' , 'holiholi' , 'URL') As new_idTeoria;
select * from cuenta;


CREATE OR REPLACE FUNCTION _modificarCuenta(usu text, in cor text, in contra text, in des text, in fot text)
RETURNS void AS
$$
	UPDATE cuenta set usuario = $1 , descripcion = $4 , foto = $5 , clave = $3 where correo = $2;
$$
LANGUAGE 'sql' VOLATILE;

SELECT _modificarCuenta('Lausas', 'majamxdj@gmail.com', 'LLjjL','holjjji','hjjola');
select * from cuenta;


CREATE OR REPLACE FUNCTION _eliminarCuenta(cor text, contra text)
RETURNS void AS
$$
	DELETE FROM cuenta WHERE correo = $1 AND clave =  $2;
$$
LANGUAGE 'sql' VOLATILE;

SELECT _eliminarCuenta ('majamxdj@gmail.com','LLjjL');
select * from cuenta;


CREATE OR REPLACE FUNCTION _registraContenidoT(idteo integer, cont text, cabe text)
RETURNS integer AS 
$$
	insert into contenidoT (idTeoria,contenido,cabeceraC) values($1,$2,$3)
    RETURNING idContenido;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _registraContenidoT(1,'jajajaja', 'holiii!');
select * from contenidoT;

CREATE OR REPLACE FUNCTION _eliminaContenidoT(idd integer)
RETURNS void AS
$$
	DELETE FROM contenidoT WHERE idContenido = $1;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _eliminaContenidoT(1);
select * from contenidoT;

CREATE OR REPLACE FUNCTION  _nuevoPost(idC integer, idI integer, title text, txt text)
RETURNS integer AS
$$
	 INSERT INTO post (idCuenta, idIntereses, titulo, texto, fecha) VALUES ($1, $2, $3, $4, now())
     RETURNING idPost;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _nuevoPost  (2, 1, 'posttt','probaaanddooo');
select * from post;

CREATE OR REPLACE FUNCTION _modificarPost(title text, txt text, idI integer, idP integer)
RETURNS void AS
$$
	UPDATE post SET texto = $2 WHERE idIntereses=$3 AND titulo=$1;	
$$
LANGUAGE 'sql' VOLATILE;

SELECT _modificarPost ('posttt','pprroo', 1, 4);
select * from post;

delimiter **
drop procedure if exists _eliminarPost**
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
call _eliminarPost (1);
select * from post;

CREATE OR REPLACE FUNCTION _eliminarPost(idP integer)
RETURNS void AS
$$
	DELETE FROM post WHERE idPost=$1;
$$
LANGUAGE 'sql' VOLATILE;
SELECT _eliminarPost (4);
select * from post;
/*

CREATE FUNCTION add_three_values(v1 anyelement, v2 anyelement, v3 anyelement)
RETURNS anyelement AS $$
DECLARE
    result ALIAS FOR $0;
BEGIN
    result := v1 + v2 + v3;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

SELECT add_three_values(1,2,3);


select * from new_book;

SELECT ins_book('hII', 'Andy') As new_id;
SELECT ins_book('holiss', 'Lausas') As new_id;
*/

-- CREATE OR REPLACE FUNCTION ret_book_plsql()
-- RETURNS TABLE (id int, title text, autor text) AS
-- $$
   --  BEGIN
   -- RETURN QUERY
   --  SELECT * FROM new_books;
   --  END;
-- $$
-- LANGUAGE 'plsql' STABLE;

-- SELECT * FROM ret_books_plsql();
