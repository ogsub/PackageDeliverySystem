CREATE PROCEDURE [dbo].[ZahtevOdobren]
	-- Add the parameters for the stored procedure here
	@username varchar(100)
AS
BEGIN
	INSERT INTO Kurir (KorIme, RegistracijaBroj, BrojIsporucenihPaketa, OstvarenProfit, Status) VALUES (@username,
	(select Z.RegistracijaBroj
	 from ZahtevAdminu Z
	 where Z.KorIme = @username
	),0,0,0)
	DELETE FROM [dbo].[ZahtevAdminu] WHERE KorIme = @username
END