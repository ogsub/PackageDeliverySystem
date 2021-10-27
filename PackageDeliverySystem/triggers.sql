CREATE TRIGGER TR_TransportOffer_izbrisiOstalePonude
   ON  Ponuda
   AFTER DELETE
AS 
BEGIN
	DELETE FROM Ponuda WHERE IdPaket = (Select IdPaket from deleted)

END
GO
