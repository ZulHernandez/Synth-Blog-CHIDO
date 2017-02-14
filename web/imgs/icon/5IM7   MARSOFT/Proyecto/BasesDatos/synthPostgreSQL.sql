CREATE TABLE intereses (
    idInteres INTEGER PRIMARY KEY NOT NULL,
    descripion TEXT
); 

CREATE TABLE tipoCuenta (
	idTipoCuenta INTEGER PRIMARY KEY NOT NULL,
    descripcion TEXT NOT NULL
);

CREATE TABLE cuenta (
    idCuenta INTEGER PRIMARY KEY NOT NULL,
    idTipoCuenta INTEGER,
    nombre TEXT,
    apellidos TEXT,
    usuario TEXT,
    clave TEXT,
    fechaNac DATE,
    correo TEXT,
    correoR TEXT,
    descripcion TEXT,
    foto TEXT,
    FOREIGN KEY (idTipoCuenta)
		REFERENCES tipoCuenta (idTipoCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE relInteresesCuenta (
    idRel INTEGER PRIMARY KEY NOT NULL,
    idCuenta INTEGER,
    idInteres INTEGER,
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (IdInteres)
		REFERENCES intereses(IdInteres)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE relSeguidorCuenta (
    idRel INTEGER PRIMARY KEY NOT NULL,
    idSeguidor INTEGER,
    idCuenta INTEGER,
    FOREIGN KEY (idSeguidor)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idcuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE teoria (
    idTeoria INTEGER PRIMARY KEY NOT NULL,
    fecha DATE,
    numConsultas INTEGER,
    titulo TEXT,
    descripcion TEXT,
    cuerpo TEXT
);

CREATE TABLE contenidoT (
    idContenido INTEGER PRIMARY KEY NOT NULL,
    idTeoria INTEGER,
    contenido TEXT,
    cabecera TEXT,
    FOREIGN KEY (idTeoria)
        REFERENCES teoria (idTeoria)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE post (
    idPost INTEGER PRIMARY KEY NOT NULL,
    idCuenta INTEGER,
    idInteres INTEGER,
    titulo TEXT,
    texto TEXT,
    fecha DATE,
    FOREIGN KEY (idCuenta)
        REFERENCES cuenta (idCuenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idInteres)
        REFERENCES intereses (idInteres)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contenidoP (
    idContenidoP INTEGER PRIMARY KEY NOT NULL,
    idPost INTEGER,
    contenido TEXT,
    cabecera TEXT,
    FOREIGN KEY (idPost)
        REFERENCES post (idPost)
        ON DELETE CASCADE ON UPDATE CASCADE
); 

create or replace view vwpost as 
select post.idCuenta, post.idPost, post.fecha, post.titulo, post.texto, cuenta.foto, cuenta.usuario, intereses.descripion, contenidoP.contenido, contenidoP.cabecera 
from post 
inner join cuenta on cuenta.idCuenta = post.idCuenta  
inner join intereses on intereses.idInteres = post.idInteres 
left join contenidoP on contenidoP.idPost = post.idPost;

CREATE OR REPLACE FUNCTION _obtenPost(in idC INTEGER)
RETURNS TABLE(idPost INTEGER, fecha DATE, titulo TEXT, cuerpo TEXT, contenido TEXT, cabecera TEXT, foto TEXT) AS $$
    BEGIN 
        RETURN QUERY SELECT * FROM vwpost WHERE vwpost.idCuenta = idC;
    END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _obtenCategorias()
RETURNS TABLE(idInteres TEXT, descripcion TEXT) AS $$
	BEGIN 
		RETURN QUERY SELECT * FROM intereses;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _obtenTeoria(IN idT INTEGER) 
RETURNS TABLE(idTeoria INTEGER, fecha DATE, numConsultas INTEGER, titulo TEXT, descripcion TEXT, cuerpo TEXT) AS $$
	DECLARE
		numcon INTEGER;
	BEGIN 
		IF(idT = -1) THEN 
			RETURN QUERY SELECT * FROM teoria;
		ELSE 
			SELECT teoria.numConsultas INTO numcon FROM teoria WHERE teoria.idTeoria = idT;
			UPDATE teoria SET numConsultas = numcon + 1 WHERE teoria.idTeoria = idT;
			RETURN QUERY SELECT * FROM teoria WHERE teoria.idTeoria = idT;
		END IF;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _obtenContenido(IN idT INTEGER)
RETURNS TABLE(idContenido INTEGER, idTeoria INTEGER, contenido TEXT, cabecera TEXT) AS $$
	DECLARE 
		existe INTEGER;
	BEGIN  
		SELECT COUNT(*) INTO existe FROM teoria WHERE teoria.idTeoria = idT;
		if (existe = 1) THEN 
			RETURN QUERY SELECT * FROM contenidoT WHERE contenidoT.idTeoria = idT;
		else 
			RETURN QUERY SELECT '-1'::INTEGER AS idContenido, '-1'::INTEGER AS idTeoria, ''::TEXT AS contenido, ''::TEXT AS cabecera;
		END if;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _activarCuenta(in token TEXT)
RETURNS TABLE (Activacion TEXT, corr TEXT, clave TEXT) AS $$
	DECLARE 
		msj TEXT;
		existe INTEGER;
		usr TEXT;
		pss TEXT;
	begin 
		select count(*) INTO existe from cuenta where foto=token;
		if existe = 0 then 
			msj:='No se encontro la cuenta';
			usr:='';
			pss:='';
		else 
			select correo into usr from cuenta where foto=token;
			select clave into pss from cuenta where foto=token;
			update cuenta set foto='/Synth_BLOG/img/fondomusica1.jpg' where foto=token;
			set msj='Cuenta activada';
		end if;
		RETURN QUERY select msj as Activacion,usr as corr,pss as clav;
	end;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _obtenIntereses()
RETURNS TABLE(interes INTEGER, genero TEXT) AS $$
    BEGIN 
		RETURN QUERY SELECT idInteres,descripion FROM intereses;
    END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _validaRecuperacion(in correoC TEXT, in corrRec TEXT)
RETURNS TABLE(Usr TEXT) AS $$
	DECLARE 
		msj TEXT;
		existe INTEGER;
	BEGIN 
		select count(*) INTO existe from cuenta where cuenta.correo=correoC and cuenta.correoR=corrRec;
		if existe = 1 then 
			msj := 'Existe';
		else 
			msj := 'No encontrado';
		end if;
		RETURN QUERY select msj as Usr;
    end;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _recuperarCuenta(in correoC TEXT, in corrRec TEXT,in nvaClav TEXT)
RETURN TABLE(Regreso TEXT, Token TEXT) AS $$
	DECLARE 
		msj TEXT;
        existe INTEGER;
        token TEXT;
	begin 
		select count(*) INTO existe from cuenta where correoC = cuenta.correo and cuenta.correoR = corrRec;
		if existe =0 then 
			msj := 'No existe';
			token := '';
		else 
			update cuenta set cuenta.clave = nvaClav, cuenta.foto = md5(nvaClav) where cuenta.correo = correoC and cuenta.correoR = corrRec;
			set msj='Cuenta recuperada';
			select cuenta.foto into token from cuenta where cuenta.correo=correoC and cuenta.correoR=corrRec;
		end if;
        RETURN QUERY SELECT msj,token;
    end;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _activarCuenta(in token TEXT)
RETURNS TABLE(Activacion TEXT) AS $$
	DECLARE 
		msj TEXT;
        existe INTEGER;
	begin 
		select count(*) into existe from cuenta where cuenta.foto=token;
		if existe = 0 then
			set msj='No se encontro la cuenta';
		else 
			update cuenta set foto='/Synth_BLOG/img/fondomusica1.jpg' where cuenta.foto=token;
			set msj='Cuenta activada';
		end if;
		RETURN QUERY select msj as Activacion;
	end;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _traePerfil(IN id INTEGER)
RETURNS TABLE(estado TEXT, nombre TEXT, contra TEXT, correo TEXT, descripc TEXT, fotoUsr TEXT) AS $$
	DECLARE 
		msj TEXT;
        exist INTEGER;
	BEGIN 
		SELECT count(*) INTO exist FROM cuenta WHERE idCuenta=id;
		IF exist = 0 THEN 
			msj :='No existe';
			RETURN QUERY SELECT msj, ''::TEXT AS a, ''::TEXT AS b, ''::TEXT AS c, ''::TEXT AS x, ''::TEXT AS y;
		ELSE 
			SET msj='Encontrado';
			RETURN QUERY SELECT msj, cuenta.usuario, cuenta.clave, cuenta.correo, cuenta.descripcion, cuenta.foto FROM cuenta WHERE cuenta.idCuenta = id;
		END IF;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _obtenCuenta(IN corr TEXT, IN con TEXT)
RETURNS TABLE (msg TEXT, us TEXT, activo TEXT, tipous INTEGER) AS $$
	DECLARE 
		existe INTEGER;
        msg TEXT;
        us TEXT;
        activo TEXT;
        tipous INTEGER;
	BEGIN 
		SELECT count(*) INTO existe FROM cuenta WHERE correo = corr and clave = con;
		IF existe = 1 THEN 
			SELECT idCuenta INTO msg FROM cuenta WHERE correo = corr and clave = con;
			SELECT usuario INTO us FROM cuenta WHERE correo = corr and clave = con;
            SELECT foto INTO activo FROM cuenta WHERE correo = corr and clave = con;
            SELECT idTipoCuenta INTO tipous FROM cuenta WHERE correo = corr and clave = con;
		ELSE 
			msg := '';
			us := '';
            activo := '';
            tipous := 0;
		END IF;
		RETURN QUERY SELECT msg,us,activo,tipous;
	END; 
 $$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _registraCuenta(IN nom TEXT, IN aP TEXT, IN usu TEXT, IN contra TEXT, IN fecha date, IN cor TEXT,IN corrR TEXT,IN des TEXT)
RETURNS TABLE(msg TEXT) AS $$
	DECLARE 
		idI INTEGER;
		existe INTEGER;
		msg TEXT;
	BEGIN 
		SELECT count(*) INTO existe FROM cuenta WHERE correo= cor;
		IF existe = 1 THEN 
			msg := 'Registro existente.';
		ELSE 
			SELECT COALESCE(max(idCuenta), 0) + 1 INTO idI FROM cuenta;
			INSERT INTO cuenta values (idI,2,nom,aP,usu,contra,fecha,cor,corrR,des,md5(cor));
			 msg := 'Registro exitoso.';
		END IF;
		RETURN QUERY SELECT msg;
	END ;
$$ LANGUAGE 'plpgsql' VOLATILE;
			
CREATE OR REPLACE FUNCTION _modificarCuenta(IN id INTEGER, IN contra TEXT,IN dato TEXT , IN tipoModif INTEGER)
RETURNS TABLE(Estado TEXT) AS $$
	DECLARE 
		existe INTEGER;
		intere TEXT;
		msj TEXT;
    BEGIN  
		SELECT count(*) INTO existe FROM cuenta WHERE idCuenta=id and clave=contra;
	    IF existe = 0 THEN 
			msj := 'Datos INcorrectos o contrASenia erronea.';
	    ELSE 
			IF tipoModif = 1 THEN 
				UPDATE cuenta SET usuario = dato WHERE idCuenta = id;
				msj := 'Nombre modIFicado.';
			ELSE 
				IF tipoModif=2 THEN 
					UPDATE cuenta SET clave = dato WHERE idCuenta = id;
					msj := 'Clave modIFicada';
				ELSE 
					IF tipoModif = 3 THEN 
						UPDATE cuenta SET correo = dato WHERE idCuenta=id;
						msj := 'Correo modIFicado';
					ELSE 
						IF tipoModIF = 4 THEN 
							SELECT count(*) INTO intere FROM itereses WHERE idInteres = dato;
							SELECT count(*) INTO existe FROM relInteresesCuenta WHERE idCuenta = id and idInteres = intere;
							IF existe = 0  THEN 
								IF intere=0 THEN  
									msj := 'intereses inexistente';
								ELSE 
									SELECT COALESCE(max(idRel), 0) + 1 INTO existe FROM relInteresesCuenta;
									INSERT INTO relInteresesCuenta values(existe,id,dato);
									msj := 'intereses modificado';
								END IF;
							ELSE 
								msj := 'intereses ya existente';
							END IF;
						ELSE 
							IF tipoModif=5 THEN 
								UPDATE cuenta SET descripcion=dato WHERE idCuenta=id;
								msj := 'Descripcion modificada';
							ELSE 
								IF tipoModif=6 THEN 
									UPDATE cuenta SET foto=dato WHERE idCuenta=id;
									msj := 'Foto modificada';
								ELSE 
									msj := 'Modificacion no disponible';
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
	   END IF;
	   RETURN QUERY SELECT msj; 
	END;
 $$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _eliminarCuenta(IN cor TEXT, IN contra TEXT)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE 
		existe INTEGER;
		msj TEXT;
	BEGIN  
		SELECT count(*) INTO existe FROM cuenta WHERE correo = cor and clave = contra;
		IF existe = 0 THEN 
			msj := 'Registio INexistente.';
		ELSE 
			DELETE FROM cuenta WHERE correo = cor and clave = contra;
			msj := 'Registro elimINado.';
		END IF;
		RETURN QUERY SELECT msj; 
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _registraSeguidor(IN id1 INTEGER, IN id2 INTEGER)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE  
		existe INTEGER;
		idI INTEGER;
		msj TEXT;
	BEGIN 
		SELECT count(*) INTO existe FROM relSeguidorCuenta WHERE idSeguidor = id1 and idCuenta =  id2;
		IF existe = 1 THEN 
			msj := 'Registio existente.';
		ELSE 
			SELECT COALESCE(max(idRel),0) + 1 INTO idI FROM relSeguidorCuenta;
			INSERT INTO relSeguidorCuenta values(idI,id1,id2);
			msj := 'Registro ejecutado.';
		END IF;
		RETURN QUERY SELECT msj; 
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _subirTeoria(IN title TEXT, IN des TEXT, IN body TEXT)
RETURNS TABLE(msj TEXT, idT INTEGER) AS $$ 
	DECLARE 
		existe INTEGER;
		idT INTEGER; 
		msj TEXT;
	BEGIN 
		SELECT count(*) INTO existe FROM teoria WHERE teoria.titulo = title and teoria.descripcion = des and teoria.cuerpo = body;
		SELECT COALESCE(max(teoria.idTeoria),0)+1 INTO idT FROM teoria; 
		IF(existe > 0) THEN 
			msj := 'Registro existente.';
			idT = -1;
		ELSE 
			INsert INto teoria (idTeoria, titulo, descripcion, cuerpo, fecha, numConsultAS) values (idT, title, des, body,now(),0);
			msj := 'Registro exitoso';
		END IF; 
		RETURN QUERY SELECT msj,idT;
	END;
 $$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _eliminarTeoria(IN idT INTEGER)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE 
		existe INTEGER; 
		msj TEXT;
	BEGIN 
		SELECT count(*) INTO existe FROM teoria WHERE idTeoria= idT; 
		IF(existe = 0) THEN 
			msj :='Registro INexistente.';
		ELSE  
			DELETE FROM teoria WHERE idTeoria=idT; 
			msj := 'Registro elimINado';
		END IF;
		RETURN QUERY SELECT msj;
	END;
 $$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _registraContenido(in idteo INTEGER, in cont TEXT, in cabe TEXT, in suich INTEGER)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE 
		idI INTEGER;
		msj TEXT;
	BEGIN 
		if (suich = 1) then 
			select COALESCE(max(idContenido), 0) + 1 into idI from contenidoT;
			insert into contenidoT values(idI,idteo,cont,cabe);
			msj := 'Registro de contenido exitoso.';
		else 
			if(suich = 2) then
				select COALESCE(max(idContenido), 0) + 1 into idI from contenidoP;
				insert into contenidoP values(idI,idteo,cont,cabe);
				msj :=  'Registro de contenido exitoso.';
			else
				msj := 'ERROR: No se registro el contenido debido a que no se reconocio la peticion';
			end if;
		end if;
		RETURN QUERY select msj;
	end;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _eliminaContenidoT(IN idd INTEGER)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE
		existe INTEGER;
		msj TEXT;
	BEGIN
		SELECT count(*) INTO existe FROM contenidoT WHERE idContenido = idd;
		IF existe = 0 THEN 
			msj := 'Registro inexistente.';
		ELSE 
			DELETE FROM contenidoT WHERE idContenido = idd;
			msj :=  'Registro eliminado.';
		END IF;
		RETURN QUERY SELECT msj; 
	END;
 $$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _nuevoPost(IN idC INTEGER, IN idI INTEGER, IN title TEXT, IN txt TEXT)
RETURNS TABLE(msj TEXT, idP INTEGER) AS $$
	DECLARE 
		existe  INTEGER; 
		idP INTEGER; 
		msj TEXT;
	BEGIN 
		SELECT count(*) INTO existe FROM post WHERE idCuenta=idC and titulo = title;
		IF(existe = 1) THEN 
			msj := 'Registro existente.'; 
			idP := -1;
		ELSE 
			SELECT COALESCE(max(idPost),0)+1 INTO idP FROM post; 
			INsert INto post (idPost, idCuenta, idInteres, titulo, texto, fecha) values (idP, idC, idI, title, txt, now());
			msj := 'Registro exitoso';
		END IF;
		RETURN QUERY SELECT msj,idP;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _modificarPost(IN title TEXT, IN txt TEXT, IN idI INTEGER, IN idP INTEGER)  
RETURNS TABLE(msj TEXT) AS $$
	DECLARE 
		msj TEXT;
		existe INTEGER; 
	BEGIN 
		SELECT count(*) INTO existe FROM post WHERE idP = idPost;
		IF(existe = 0) THEN 
			msj := 'Registro inexistente.';
		ELSE  
			UPDATE post SET texto = txt WHERE idInteres=idI and titulo=title;
			msj := 'Registro modificado';
		END IF; 
		RETURN QUERY SELECT msj;
	END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION _eliminarPost(IN idP INTEGER)
RETURNS TABLE(msj TEXT) AS $$
	DECLARE 
		existe INTEGER;
		msj TEXT; 
	BEGIN  
		SELECT count(*) INTO existe FROM post WHERE idPost=idP; 
		IF (existe = 0) THEN 
			msj := 'Registro INexistente.';
		ELSE 
			DELETE FROM post WHERE idPost=idP;
			msj :='Registro elimINado';
		END IF; 
		RETURN QUERY SELECT msj;
	END; 
$$ LANGUAGE 'plpgsql' VOLATILE;

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
INSERT INTO intereses values(16,'Electroduranguenze');

INSERT INTO tipoCuenta VALUES(1,'Administrador');
INSERT INTO tipoCuenta VALUES(2,'Alumno');

INSERT INTO cuenta VALUES(1,1,
						'Marsoft',
                        'Empresa',
                        'Marsoft',
                        'marsoft',
                        '2015-08-23',
                        'marsoft@gmail.com',
                        'beareating59814@gmail.com',
                        'Somos una empresa desarrolladora de software',
                        '/Synth_BLOG/img/fondomusica1.jpg');