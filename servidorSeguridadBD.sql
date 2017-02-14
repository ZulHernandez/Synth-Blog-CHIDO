drop database if exists ss;
create database ss;
use ss;

create table usuarios(
idUsuario int(3) primary key not null,
usr nvarchar(100) not null,
pass nvarchar(100) not null,
tipoUsr int(2) not null,
visitas int(4) not null,
enLinea int(1) not null
);

create table catEstadosLinea(
idEstado int(1) primary key not null,
descripcion nvarchar(100) not null);

insert into catEstadosLinea values(1,'Online');
insert into catEstadosLinea values(0,'Offline');
insert into catEstadosLinea values(2,'Affaire');
use ss;
select * from usuarios;

drop procedure if exists  sp_agregarRegistro;
delimiter **
create procedure sp_agregarRegistro(in us nvarchar(100), in pas nvarchar(100), in tipo int(2))
begin
	declare msj nvarchar(32);
    declare existe int(1);
    declare idUsr int(3);
    
    set existe=(select count(*) from usuarios where usr=us and pass=pas);
    if existe= 1 then
		set msj='Registro existente';
	else
		
        set idUsr=(select ifnull(max(idUsuario),0) +1 from usuarios);
        insert into usuarios values(idUsr,us,pas,tipo,0,2);
        set msj='Agregado';
	end if;
    select msj as Estado;
    end; **
delimiter ;

use ss;
select * from usuarios;
drop procedure if exists sp_activarRegistro;
delimiter **
create procedure sp_activarRegistro(in us nvarchar(100) , in pas nvarchar(100))
begin
	declare msj nvarchar(100);
    declare existe int(1);
    
    set existe=(select count(*) from usuarios where usr=us and pass=pas);
    if existe = 0 then
		set msj='No existe';
	else
		set msj='Activado';
		update usuarios set enLinea=0 where usr=us and pass=pas;
	end if;
    select msj as Resultado;
end; **
delimiter ;
 
 drop procedure if exists sp_eliminarRegistro;
 delimiter **
 create procedure sp_eliminarRegistro(in us nvarchar(100), in pas nvarchar(100))
 begin
	declare msj nvarchar(100);
    declare existe int(1);
    set existe =(select count(*) from usuarios where usr=us and pass=pas);
    if existe = 0 then
		set msj='No encontrado';
	else
		set existe=(select idUsuario from usuarios where usr=us and pass=pas);
		set msj='Eliminado';
        delete  from usuarios where idUsuario=existe;
	end if;
    select msj as Resultado;
    end; **
delimiter ;
        
drop procedure if exists sp_entraUsuario;
delimiter **
create procedure sp_entraUsuario(in us nvarchar(100),in pas nvarchar(100))
begin 
	declare msj nvarchar(100);
    declare usuar int(3);
    declare existe int(1);
    set existe=(select count(*) from usuarios where usr=us and pass=pas);
    if existe = 0 then
		set msj='No existe';
        set usuar=0;
	else
		set existe=(select enLinea from usuarios where usr=us and pass=pas);
        if existe= 2 then
        set msj='No activado';
        set usuar=0;
        else
			set msj='Acceso';
			set usuar=(select idUsuario as usr from usuarios where usr=us and pass=pas);
			update usuarios set enLinea=1 where usr=us and pass=pas;
		end if;
	end if;
    select msj as Acceso, usuar as Identificador;
    end; **
delimiter ;

    
  drop procedure if exists sp_desactivarRegistro;
  delimiter **
  create procedure sp_desactivarRegistro(in us nvarchar(100), pas nvarchar(100))
  begin
	declare existe int(1);
    declare msj nvarchar(100);
    set existe=(select count(*) from usuarios where usr=us);
    if existe =0 then
		set msj='No encontrado';
	else 
		set msj='Desactivado';
        update usuarios set enLinea=2,pass=pas where usr=us;
	end if;
    select msj as Resultado;
    end; **
delimiter ;
    
drop procedure if exists sp_cambiarContra;
delimiter **
create procedure sp_cambiarContra(in ide int(3),in pas nvarchar(100),in tip int(1),in nvDato nvarchar(100))
begin
	declare msj nvarchar(100);
    declare existe int(1);
    set existe=(select count(*) from usuarios where idUsuario=ide and pass=pas);
    if existe =0 then
		set msj='No existe';
	else
		if tip=2 then
				set msj='Cambiado';
				update usuarios set pass=nvDato where idUsuario=ide and pass=pas;
		else
			if tip=3 then
				set msj='Cambiado';
                update usuarios set usr=nvDato where idUsuario=ide;
			end if;
		end if;
	end if;
    select msj as Regreso;
end; ** 
delimiter ;
    
drop procedure if exists sp_offline;
delimiter **
create procedure sp_offline(in ide int(3))
begin
	declare msj nvarchar(100);
    declare existe int(1);
    set existe=(select count(*) from usuarios where idUsuario=ide);
    if existe=0 then
		set msj='No encontrado';
	else 
		set msj='Offline';
        update usuarios set enLinea=0 where idUsuario=ide;
	end if;
    select msj as Regreso;
end; **
delimiter ;
#lineas modificadas
insert into usuarios values
(1,'marsoft@gmail.com','marsoft',1,0,0),
(2,'correo2@gmail.com','Clave2',2,0,0),
(3,'correo3@gmail.com','Clave3',2,0,0);
select * from usuarios;
    

    
    
    
    
    
    
    
    
        