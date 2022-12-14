

/*  1) Il primo trigger controlla che la quantità di malto utilizzato per l'ammostamento sia disponibile
       tra le scorte in magazzino poichè ovviamente non possiamo utilizzare una quantità maggiore di
       quella che abbiamo in stock*/


    CREATE OR REPLACE TRIGGER Check_scorte_malto  
        BEFORE INSERT ON Ammostamento               
        FOR EACH ROW
        DECLARE
            notEnoughMalt EXCEPTION;
            maltNotInStock EXCEPTION;
            maltoQT NUMBER;  
        BEGIN
            SELECT quantitaMagazzino INTO maltoQT
            FROM Malto M 
            WHERE M.GTIN = :new.gtinMALTO;
            IF maltoQT IS NULL THEN RAISE maltNotInStock;
            ELSIF (:new.quantitaMalto > maltoQT)
                THEN RAISE notEnoughMalt;
            ELSIF (:new.quantitaMalto <= maltoQT)
                THEN UPDATE Malto SET quantitaMagazzino = quantitaMagazzino - :new.quantitaMalto WHERE GTIN = :new.gtinMALTO;
            END IF;
        EXCEPTION
            WHEN notEnoughMalt THEN  RAISE_APPLICATION_ERROR (-20107,'Malto in scorta insufficiente');
            WHEN maltNotInStock THEN  RAISE_APPLICATION_ERROR (-20104,'Malto non in scorta');
    END Check_scorte_malto;


/*  2) Il secondo trigger controlla che la quantità di luppolo utilizzato per l'ammostamento sia 
       disponibile tra le scorte in magazzino poichè ovviamente non possiamo utilizzare una quantità 
       maggiore di quella che abbiamo in stock*/

	CREATE OR REPLACE TRIGGER Check_scorte_luppolo  
		BEFORE INSERT ON MostoDolce               
		FOR EACH ROW
		DECLARE
		    notEnoughLupp EXCEPTION;
		    luppNotInStock EXCEPTION;
		    luppoloQT NUMBER;  
		BEGIN
		    SELECT quantitaMagazzino INTO luppoloQT
		    FROM Luppolo LU 
		    WHERE LU.GTIN = :new.gtinLuppoloUsato;
		    IF luppoloQT IS NULL THEN RAISE luppNotInStock;
		    ELSIF (:new.quantitaLuppUsato > luppoloQT)
		        THEN RAISE notEnoughLupp;
		    ELSIF (:new.quantitaLuppUsato <= luppoloQT)
		        THEN UPDATE Luppolo SET quantitaMagazzino = quantitaMagazzino - :new.quantitaLuppUsato WHERE GTIN = :new.gtinLuppoloUsato;
		    END IF;
		    EXCEPTION
		        WHEN notEnoughLupp THEN  RAISE_APPLICATION_ERROR (-20002,'Luppolo in scorta insufficiente');
		        WHEN luppNotInStock THEN  RAISE_APPLICATION_ERROR (-20003,'Luppolo non in scorta');
	    END Check_scorte_luppolo;


/*  3) Il terzo trigger controlla che la quantità di lievito utilizzato per la fermentazione sia 
       disponibile tra le scorte in magazzino poichè ovviamente non possiamo utilizzare una quantità 
       maggiore di quella che abbiamo in stock*/


    CREATE OR REPLACE TRIGGER Check_scorte_lievito  
        BEFORE INSERT ON Fermentazione               
        FOR EACH ROW
        DECLARE
            notEnoughLiev EXCEPTION;
            lievNotInStock EXCEPTION;
            lievitoQT NUMBER;  
        BEGIN
            SELECT quantitaMagazzino INTO lievitoQT
            FROM Lievito LI 
            WHERE LI.GTIN = :new.gtinLievitoUsato;
            IF lievitoQT IS NULL THEN RAISE lievNotInStock;
            ELSIF (:new.quantitaLievUsato > lievitoQT)
                THEN RAISE notEnoughLiev;
            ELSIF (:new.quantitaLievUsato <= lievitoQT)
                THEN UPDATE Lievito SET quantitaMagazzino = quantitaMagazzino - :new.quantitaLievUsato WHERE GTIN = :new.gtinLievitoUsato;
            END IF;
            EXCEPTION
                WHEN notEnoughLiev THEN  RAISE_APPLICATION_ERROR (-20004,'Lievito in scorta insufficiente');
                WHEN lievNotInStock THEN  RAISE_APPLICATION_ERROR (-20005,'Lievito non in scorta');
    END Check_scorte_lievito ;


/*  4) Questo trigger controlla che la quantità di malto e acqua utilizzati per l'ammostamento
       non sia superiore alla capacità di lavorazione del bollitore.*/

    CREATE OR REPLACE TRIGGER Check_lavorazione 
        BEFORE INSERT ON Ammostamento               
        FOR EACH ROW
        DECLARE
            notEnoughCapacity EXCEPTION;
            exc EXCEPTION;
            ContainerCap NUMBER;
        BEGIN
            SELECT capacitaLavorazione INTO ContainerCap
            FROM Contenitore C
            WHERE C.idContenitore = :new.idBollitore;
            IF (:new.quantitaAcqua > ContainerCap )
                THEN RAISE notEnoughCapacity;
            END IF;
        EXCEPTION
                WHEN notEnoughCapacity THEN  RAISE_APPLICATION_ERROR (-20006,'Capacità insufficiente');
    END Check_lavorazione;

/*  5) Questo trigger controlla che la quantità di mosto utilizzata per la fermentazione
       non sia superiore alla capacità di lavorazione del bollitore.*/

    CREATE OR REPLACE TRIGGER Check_lavorazione2 
        BEFORE INSERT ON Fermentazione               
        FOR EACH ROW
        DECLARE
        	qtMosto NUMBER;
            capacita NUMBER;
        	OverProduction EXCEPTION;
        BEGIN
        	SELECT quantitaMosto INTO qtMosto
        	FROM MostoDolce
        	WHERE codLotto = :new.numLottoFermentato;
        	
            select capacitaLavorazione 
              into capacita
              from Contenitore
             where idContenitore = :new.idFermentatore;

        	IF (qtMosto < capacita) THEN RAISE OverProduction;
            END IF;
           
        EXCEPTION
            WHEN OverProduction THEN  RAISE_APPLICATION_ERROR (-20017,'OverProduction');
    END Check_lavorazione2;


/*  6) Quando viene fatto un inserimento in lotto materia prima controlla che sia conforme alle 
       specifiche e aggiorna la quantità delle scorte.*/

    CREATE OR REPLACE TRIGGER Update_scorte_materiePrime  
        AFTER INSERT ON LottoMateriaPrima               
        FOR EACH ROW
        DECLARE
            pragma autonomous_transaction;
    BEGIN
     	IF (:new.tipo = 'Malto') 
            THEN UPDATE Malto SET quantitaMagazzino = quantitaMagazzino + :new.quantitaAcquistata 
            WHERE GTIN = :new.Gtin;
     	ELSIF(:new.tipo = 'Luppolo') 
            THEN UPDATE Luppolo SET quantitaMagazzino = quantitaMagazzino + :new.quantitaAcquistata 
            WHERE GTIN = :new.Gtin;
     	ELSIF(:new.tipo = 'Lievito')  
            THEN UPDATE Lievito SET quantitaMagazzino = quantitaMagazzino + :new.quantitaAcquistata 
            WHERE GTIN = :new.Gtin;
     	END IF;
     	COMMIT;
    END Update_scorte_materiePrime ;

/*  7) Durante un inserimento nell'ammostamento controlliamo che venga utilizzato un bollitore e non un
       fermentatore.*/

    CREATE OR REPLACE TRIGGER Check_Bollitore 
        BEFORE INSERT ON Ammostamento               
        FOR EACH ROW
        DECLARE
            tipoContenitore CHAR(20);
            wrongContainer EXCEPTION;
	BEGIN
        Select tipoContenitore INTO tipoContenitore 
        FROM Contenitore 
        WHERE idContenitore = :new.idBollitore;
        IF (tipoContenitore = 'Fermentatore') 
            THEN RAISE wrongContainer;
        END IF;
        EXCEPTION 
            WHEN wrongContainer THEN RAISE_APPLICATION_ERROR(-20007,'Wrong type container');
	END Check_Bollitore;


/*  8) Durante un inserimento nella fermentazione controlliamo che venga utilizzato un fermentatore e non un
       bollitore.*/

    CREATE OR REPLACE TRIGGER Check_Fermentatore
        BEFORE INSERT ON Fermentazione               
        FOR EACH ROW
        DECLARE
            tipoContenitore CHAR(20);
            wrongContainer EXCEPTION;
	BEGIN
        Select tipoContenitore INTO tipoContenitore 
        FROM Contenitore 
        WHERE idContenitore = :new.idFermentatore;
        IF (tipoContenitore = 'Bollitore') 
            THEN RAISE wrongContainer;
        END IF;
        EXCEPTION 
            WHEN wrongContainer THEN RAISE_APPLICATION_ERROR(-20009,'Wrong type container');
	END Check_Fermentatore;
	
/*9) Dopo aver prodotto della birra viene aggiornato il numero di fusti */	
	
	 CREATE OR REPLACE TRIGGER Update_scorte_birra
        AFTER INSERT ON BirraProdotta               
        FOR EACH ROW
        DECLARE
        pragma autonomous_transaction;
        BEGIN
        UPDATE TipoBirra SET NumeroFustiMagazzino = NumeroFustiMagazzino + :new.NumFustiProdotti WHERE GTIN  = :new.GTIN;
        COMMIT;
        END Update_scorte_birra;
        
/*10) Controlla che il numero di fusti venduti sia presente in magazzino e eventualmente aggiorna le scorte*/	

	 CREATE OR REPLACE TRIGGER CheckVendita
        BEFORE INSERT ON BirraVenduta               
        FOR EACH ROW
        DECLARE
        pragma autonomous_transaction;
        notEnoughtFusti EXCEPTION;
        nFustiDisp NUMBER;
        BEGIN
        SELECT TB.NumeroFustiMagazzino INTO nFustiDisp  FROM BirraProdotta BP join TipoBirra TB on BP.GTIN = TB.GTIN 
        WHERE CodLotto = :new.CodLotto;
        
        IF (nFustiDisp < :new.numFusti) THEN RAISE notEnoughtFusti
        ELSIF (nFustiDisp >= :new.numFusti) 
        THEN UPDATE TipoBirra SET NumeroFustiMagazzino = NumeroFustiMagazzino - :new.numFusti 
        WHERE GTIN = SELECT GTIN FROM BirraProdotta WHERE CodLotto = :new.CodLotto;
        COMMIT;
        ENDIF;
        END CheckVendita;
        
/*11) Aggiorna automaticamente la data di fine fermentazione con la data di produzione della birra fatta con il mosto fermentato*/	 
	CREATE OR REPLACE TRIGGER AutoUpdateFermentazione
        AFTER INSERT ON BirraProdotta               
        FOR EACH ROW
        DECLARE
        pragma autonomous_transaction;
        BEGIN
        UPDATE FERMENTAZIONE SET dataFine = :new.dataProduzione
        WHERE numLottoFermentato = :new.numLottoMostoDolce;
        COMMIT;
        END AutoUpdateFermentazione;
        
/*12) Controlla che non vengano eseguite fermentazioni in fermentatori già occupati*/	
	CREATE OR REPLACE TRIGGER CheckDisponibilitaFermentatore
	BEFORE INSERT ON Fermentazione
	FOR EACH ROW
        DECLARE
        FermentatoreOccupato EXCEPTION;
        occupato NUMBER;
        BEGIN
        SELECT COUNT(*) INTO occupato FROM FERMENTAZIONE WHERE idFermentatore=:new.idFermentatore AND dataFine IS NULL;
        
        IF (occupato > 0) THEN RAISE FermentatoreOccupato;
        END IF;
        EXCEPTION
        WHEN FermentatoreOccupato THEN RAISE_APPLICATION_ERROR(-20029,'Fermentatore Occupato');
        END CheckDisponibilitaFermentatore;
        

/*13) Controlla che quando viene inserita una materia prima in ammostamento questa sia un malto, in caso contrario lancia un eccezzione*/	

        CREATE OR REPLACE TRIGGER Check_IsMalt
        BEFORE INSERT ON AMMOSTAMENTO               
        FOR EACH ROW
        DECLARE
            tipoMateriaPrima CHAR(20);
            wrongMateriaPrima EXCEPTION;
	    BEGIN
            Select tipo INTO tipoMateriaPrima 
            FROM MateriaPrima 
            WHERE GTIN = :new.gtinMALTO;
            IF (tipoMateriaPrima <> 'Malto') 
                THEN RAISE wrongMateriaPrima;
            END IF;
        EXCEPTION 
            WHEN wrongMateriaPrima THEN RAISE_APPLICATION_ERROR(-20100,'Raw material is not malt');
	    END Check_IsMalt;

/*14) Controlla che quando viene inserita una materia prima in mosto dolce questa sia un luppolo, in caso contrario lancia un eccezzione*/	

         CREATE OR REPLACE TRIGGER Check_IsHop
        BEFORE INSERT ON MostoDolce               
        FOR EACH ROW
        DECLARE
            tipoMateriaPrima CHAR(20);
            wrongMateriaPrima2 EXCEPTION;
	    BEGIN
            Select tipo INTO tipoMateriaPrima 
            FROM MateriaPrima 
            WHERE GTIN = :new.gtinLuppoloUsato;
            IF (tipoMateriaPrima <> 'Luppolo') 
                THEN RAISE wrongMateriaPrima2;
            END IF;
        EXCEPTION 
            WHEN wrongMateriaPrima2 THEN RAISE_APPLICATION_ERROR(-20101,'Raw material is not hop');
	    END Check_IsHop;

/*15) Controlla che quando viene inserita una materia prima in fermentazione questa sia un lievito, in caso contrario lancia un eccezzione*/	

    CREATE OR REPLACE TRIGGER Check_IsYeast
        BEFORE INSERT ON Fermentazione               
        FOR EACH ROW
        DECLARE
            tipoMateriaPrima CHAR(20);
            wrongMateriaPrima3 EXCEPTION;
	    BEGIN
            Select tipo INTO tipoMateriaPrima 
            FROM MateriaPrima 
            WHERE GTIN = :new.gtinLievitoUsato;
            IF (tipoMateriaPrima <> 'Lievito') 
                THEN RAISE wrongMateriaPrima3;
            END IF;
        EXCEPTION 
            WHEN wrongMateriaPrima3 THEN RAISE_APPLICATION_ERROR(-20102,'Raw material is not yeast');
	END Check_IsYeast;

        
        
        
	
	    
    
