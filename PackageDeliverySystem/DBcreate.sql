
DROP TABLE [Administrator]
go

DROP TABLE [Ponuda]
go

DROP TABLE [ZahtevZaPrevoz]
go

DROP TABLE [Kurir]
go

DROP TABLE [ZahtevAdminu]
go

DROP TABLE [Vozilo]
go

DROP TABLE [Opstina]
go

DROP TABLE [Grad]
go

DROP TABLE [Korisnik]
go

CREATE TABLE [Administrator]
( 
	[KorIme]             varchar(100)  NOT NULL 
)
go

CREATE TABLE [Grad]
( 
	[Naziv]              varchar(100)  NULL ,
	[PostanskiBroj]      varchar(100)  NULL ,
	[IdGrad]             int  IDENTITY  NOT NULL 
)
go

CREATE TABLE [Korisnik]
( 
	[Ime]                varchar(100)  NULL ,
	[Prezime]            varchar(100)  NULL ,
	[KorIme]             varchar(100)  NOT NULL ,
	[Sifra]              varchar(100)  NULL ,
	[BrPoslatihPaketa]   int  NULL 
	CONSTRAINT [Validation_Rule_323_1858091]
		CHECK  ( BrPoslatihPaketa >= 0 )
)
go

CREATE TABLE [Kurir]
( 
	[BrojIsporucenihPaketa] int  NULL 
	CONSTRAINT [Validation_Rule_323_695552666]
		CHECK  ( BrojIsporucenihPaketa >= 0 ),
	[OstvarenProfit]     decimal(10,3)  NULL ,
	[Status]             int  NULL 
	CONSTRAINT [Validation_Rule_321_560070124]
		CHECK  ( Status BETWEEN 0 AND 1 ),
	[KorIme]             varchar(100)  NOT NULL ,
	[RegistracijaBroj]   varchar(100)  NULL 
)
go

CREATE TABLE [Opstina]
( 
	[xKoordinata]        int  NULL ,
	[yKoordinata]        int  NULL ,
	[IdOpstina]          int  IDENTITY  NOT NULL ,
	[IdGrad]             int  NULL ,
	[Naziv]              varchar(100)  NULL 
)
go

CREATE TABLE [Ponuda]
( 
	[ProcenatCeneIsporuke] decimal(10,3)  NULL ,
	[IdPaket]            int  NULL ,
	[IdPonuda]           int  IDENTITY  NOT NULL ,
	[KorIme]             varchar(100)  NULL 
)
go

CREATE TABLE [Vozilo]
( 
	[RegistracijaBroj]   varchar(100)  NOT NULL ,
	[TipGoriva]          int  NULL 
	CONSTRAINT [Min0Max2]
		CHECK  ( TipGoriva BETWEEN 0 AND 2 ),
	[Potrosnja]          decimal(10,3)  NULL 
	CONSTRAINT [Validation_Rule_323_538932628]
		CHECK  ( Potrosnja >= 0 ),
	[Zauzeta]            int  NULL 
	CONSTRAINT [Validation_Rule_321_506202646]
		CHECK  ( Zauzeta BETWEEN 0 AND 1 ),
	[TrenutnaLokacija]   int  NULL 
)
go

CREATE TABLE [ZahtevAdminu]
( 
	[KorIme]             varchar(100)  NOT NULL ,
	[RegistracijaBroj]   varchar(100)  NULL 
)
go

CREATE TABLE [ZahtevZaPrevoz]
( 
	[IdPaket]            int  IDENTITY  NOT NULL ,
	[TipPaketa]          int  NULL 
	CONSTRAINT [Validation_Rule_316_1007410076]
		CHECK  ( TipPaketa BETWEEN 0 AND 2 ),
	[OpstinaSlanje]      int  NULL ,
	[OpstinaPrijem]      int  NULL ,
	[TezinaPaketa]       decimal(10,3)  NULL 
	CONSTRAINT [Validation_Rule_323_1965639831]
		CHECK  ( TezinaPaketa >= 0 ),
	[Posiljalac]         varchar(100)  NULL ,
	[StatusIsporuke]     int  NULL 
	CONSTRAINT [Validation_Rule_333_1922043227]
		CHECK  ( StatusIsporuke BETWEEN 0 AND 3 ),
	[Cena]               decimal(10,3)  NULL 
	CONSTRAINT [Validation_Rule_323_1438744122]
		CHECK  ( Cena >= 0 ),
	[VremePrihvatanjaZahteva] datetime  NULL ,
	[Kurir]              varchar(100)  NULL ,
	[CenaDostave]        decimal(10,3)  NULL 
)
go

ALTER TABLE [Administrator]
	ADD CONSTRAINT [XPKAdministrator] PRIMARY KEY  NONCLUSTERED ([KorIme] ASC)
go

ALTER TABLE [Grad]
	ADD CONSTRAINT [XPKGrad] PRIMARY KEY  NONCLUSTERED ([IdGrad] ASC)
go

ALTER TABLE [Grad]
	ADD CONSTRAINT [XAK1Grad] UNIQUE ([Naziv]  ASC)
go

ALTER TABLE [Grad]
	ADD CONSTRAINT [XAK2Grad] UNIQUE ([PostanskiBroj]  ASC)
go

ALTER TABLE [Korisnik]
	ADD CONSTRAINT [XPKKorisnik] PRIMARY KEY  NONCLUSTERED ([KorIme] ASC)
go

ALTER TABLE [Kurir]
	ADD CONSTRAINT [XPKKurir] PRIMARY KEY  NONCLUSTERED ([KorIme] ASC)
go

ALTER TABLE [Opstina]
	ADD CONSTRAINT [XPKOpstina] PRIMARY KEY  NONCLUSTERED ([IdOpstina] ASC)
go

ALTER TABLE [Opstina]
	ADD CONSTRAINT [XAK1Opstina] UNIQUE ([Naziv]  ASC)
go

ALTER TABLE [Ponuda]
	ADD CONSTRAINT [XPKPonuda] PRIMARY KEY  NONCLUSTERED ([IdPonuda] ASC)
go

ALTER TABLE [Vozilo]
	ADD CONSTRAINT [XPKVozilo] PRIMARY KEY  NONCLUSTERED ([RegistracijaBroj] ASC)
go

ALTER TABLE [ZahtevAdminu]
	ADD CONSTRAINT [XPKZahtevAdminu] PRIMARY KEY  CLUSTERED ([KorIme] ASC)
go

ALTER TABLE [ZahtevZaPrevoz]
	ADD CONSTRAINT [XPKZahtevZaPrevoz] PRIMARY KEY  CLUSTERED ([IdPaket] ASC)
go


ALTER TABLE [Administrator]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([KorIme]) REFERENCES [Korisnik]([KorIme])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Kurir]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([KorIme]) REFERENCES [Korisnik]([KorIme])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go

ALTER TABLE [Kurir]
	ADD CONSTRAINT [R_8] FOREIGN KEY ([RegistracijaBroj]) REFERENCES [Vozilo]([RegistracijaBroj])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Opstina]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([IdGrad]) REFERENCES [Grad]([IdGrad])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Ponuda]
	ADD CONSTRAINT [R_13] FOREIGN KEY ([IdPaket]) REFERENCES [ZahtevZaPrevoz]([IdPaket])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Ponuda]
	ADD CONSTRAINT [R_12] FOREIGN KEY ([KorIme]) REFERENCES [Kurir]([KorIme])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Vozilo]
	ADD CONSTRAINT [R_20] FOREIGN KEY ([TrenutnaLokacija]) REFERENCES [Opstina]([IdOpstina])
		ON DELETE SET NULL
		ON UPDATE NO ACTION
go


ALTER TABLE [ZahtevAdminu]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([KorIme]) REFERENCES [Korisnik]([KorIme])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevAdminu]
	ADD CONSTRAINT [R_18] FOREIGN KEY ([RegistracijaBroj]) REFERENCES [Vozilo]([RegistracijaBroj])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [ZahtevZaPrevoz]
	ADD CONSTRAINT [R_9] FOREIGN KEY ([OpstinaSlanje]) REFERENCES [Opstina]([IdOpstina])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevZaPrevoz]
	ADD CONSTRAINT [R_10] FOREIGN KEY ([OpstinaPrijem]) REFERENCES [Opstina]([IdOpstina])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevZaPrevoz]
	ADD CONSTRAINT [R_11] FOREIGN KEY ([Posiljalac]) REFERENCES [Korisnik]([KorIme])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevZaPrevoz]
	ADD CONSTRAINT [R_19] FOREIGN KEY ([Kurir]) REFERENCES [Kurir]([KorIme])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tU_Administrator ON Administrator FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Administrator */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorIme varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Korisnik  Administrator on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00016760", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="KorIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorIme = Korisnik.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Administrator because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Grad ON Grad FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Grad */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Grad  Opstina on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000103c5", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="IdGrad" */
    IF EXISTS (
      SELECT * FROM deleted,Opstina
      WHERE
        /*  %JoinFKPK(Opstina,deleted," = "," AND") */
        Opstina.IdGrad = deleted.IdGrad
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Grad because Opstina exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Grad ON Grad FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Grad */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdGrad int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Grad  Opstina on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00010f6b", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="IdGrad" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdGrad)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Opstina
      WHERE
        /*  %JoinFKPK(Opstina,deleted," = "," AND") */
        Opstina.IdGrad = deleted.IdGrad
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Grad because Opstina exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Korisnik ON Korisnik FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Korisnik */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevAdminu on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003816f", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="KorIme" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevAdminu
      WHERE
        /*  %JoinFKPK(ZahtevAdminu,deleted," = "," AND") */
        ZahtevAdminu.KorIme = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Korisnik because ZahtevAdminu exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevZaPrevoz on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Posiljalac" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.Posiljalac = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Korisnik because ZahtevZaPrevoz exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  Kurir on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorIme" */
    DELETE Kurir
      FROM Kurir,deleted
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.KorIme = deleted.KorIme

    /* erwin Builtin Trigger */
    /* Korisnik  Administrator on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="KorIme" */
    DELETE Administrator
      FROM Administrator,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.KorIme = deleted.KorIme


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Korisnik ON Korisnik FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Korisnik */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorIme varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevAdminu on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004e47d", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="KorIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevAdminu
      WHERE
        /*  %JoinFKPK(ZahtevAdminu,deleted," = "," AND") */
        ZahtevAdminu.KorIme = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Korisnik because ZahtevAdminu exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevZaPrevoz on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Posiljalac" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.Posiljalac = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Korisnik because ZahtevZaPrevoz exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Kurir on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorIme = inserted.KorIme
        FROM inserted
      UPDATE Kurir
      SET
        /*  %JoinFKPK(Kurir,@ins," = ",",") */
        Kurir.KorIme = @insKorIme
      FROM Kurir,inserted,deleted
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.KorIme = deleted.KorIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Korisnik update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Administrator on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="KorIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorIme = inserted.KorIme
        FROM inserted
      UPDATE Administrator
      SET
        /*  %JoinFKPK(Administrator,@ins," = ",",") */
        Administrator.KorIme = @insKorIme
      FROM Administrator,inserted,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.KorIme = deleted.KorIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Korisnik update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Kurir ON Kurir FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Kurir */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Kurir  ZahtevZaPrevoz on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001fe19", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="Kurir" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.Kurir = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because ZahtevZaPrevoz exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Ponuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="KorIme" */
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.KorIme = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because Ponuda exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Kurir ON Kurir FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Kurir */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorIme varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Kurir  ZahtevZaPrevoz on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004c03b", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="Kurir" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.Kurir = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Kurir because ZahtevZaPrevoz exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Ponuda on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="KorIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.KorIme = deleted.KorIme
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Kurir because Ponuda exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Vozilo  Kurir on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RegistracijaBroj" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RegistracijaBroj)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Vozilo
        WHERE
          /* %JoinFKPK(inserted,Vozilo) */
          inserted.RegistracijaBroj = Vozilo.RegistracijaBroj
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.RegistracijaBroj IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Kurir because Vozilo does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Kurir on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorIme = Korisnik.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Kurir because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Opstina ON Opstina FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Opstina */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Opstina  Vozilo on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0002e8ae", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Vozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="TrenutnaLokacija" */
    UPDATE Vozilo
      SET
        /* %SetFK(Vozilo,NULL) */
        Vozilo.TrenutnaLokacija = NULL
      FROM Vozilo,deleted
      WHERE
        /* %JoinFKPK(Vozilo,deleted," = "," AND") */
        Vozilo.TrenutnaLokacija = deleted.IdOpstina

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevoz on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="OpstinaPrijem" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.OpstinaPrijem = deleted.IdOpstina
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Opstina because ZahtevZaPrevoz exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevoz on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="OpstinaSlanje" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.OpstinaSlanje = deleted.IdOpstina
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Opstina because ZahtevZaPrevoz exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Opstina ON Opstina FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Opstina */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdOpstina int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Opstina  Vozilo on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00049852", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Vozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="TrenutnaLokacija" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdOpstina)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Vozilo
      WHERE
        /*  %JoinFKPK(Vozilo,deleted," = "," AND") */
        Vozilo.TrenutnaLokacija = deleted.IdOpstina
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Opstina because Vozilo exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevoz on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="OpstinaPrijem" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdOpstina)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.OpstinaPrijem = deleted.IdOpstina
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Opstina because ZahtevZaPrevoz exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevoz on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="OpstinaSlanje" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdOpstina)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevoz
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevoz,deleted," = "," AND") */
        ZahtevZaPrevoz.OpstinaSlanje = deleted.IdOpstina
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Opstina because ZahtevZaPrevoz exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Grad  Opstina on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="IdGrad" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(IdGrad)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Grad
        WHERE
          /* %JoinFKPK(inserted,Grad) */
          inserted.IdGrad = Grad.IdGrad
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.IdGrad IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Opstina because Grad does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_Ponuda ON Ponuda FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Ponuda */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdPonuda int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ZahtevZaPrevoz  Ponuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002e87d", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevoz"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="IdPaket" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(IdPaket)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ZahtevZaPrevoz
        WHERE
          /* %JoinFKPK(inserted,ZahtevZaPrevoz) */
          inserted.IdPaket = ZahtevZaPrevoz.IdPaket
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.IdPaket IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Ponuda because ZahtevZaPrevoz does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Ponuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="KorIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.KorIme = Kurir.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.KorIme IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Ponuda because Kurir does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Vozilo ON Vozilo FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Vozilo */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Vozilo  ZahtevAdminu on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000209a0", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="RegistracijaBroj" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevAdminu
      WHERE
        /*  %JoinFKPK(ZahtevAdminu,deleted," = "," AND") */
        ZahtevAdminu.RegistracijaBroj = deleted.RegistracijaBroj
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Vozilo because ZahtevAdminu exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Vozilo  Kurir on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RegistracijaBroj" */
    IF EXISTS (
      SELECT * FROM deleted,Kurir
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.RegistracijaBroj = deleted.RegistracijaBroj
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Vozilo because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Vozilo ON Vozilo FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Vozilo */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insRegistracijaBroj varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Vozilo  ZahtevAdminu on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003b6ad", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="RegistracijaBroj" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(RegistracijaBroj)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevAdminu
      WHERE
        /*  %JoinFKPK(ZahtevAdminu,deleted," = "," AND") */
        ZahtevAdminu.RegistracijaBroj = deleted.RegistracijaBroj
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Vozilo because ZahtevAdminu exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Vozilo  Kurir on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RegistracijaBroj" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(RegistracijaBroj)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Kurir
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.RegistracijaBroj = deleted.RegistracijaBroj
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Vozilo because Kurir exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  Vozilo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Vozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="TrenutnaLokacija" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(TrenutnaLokacija)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.TrenutnaLokacija = Opstina.IdOpstina
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.TrenutnaLokacija IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Vozilo because Opstina does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tU_ZahtevAdminu ON ZahtevAdminu FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ZahtevAdminu */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorIme varchar(100),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Vozilo  ZahtevAdminu on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002e3e9", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="RegistracijaBroj" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RegistracijaBroj)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Vozilo
        WHERE
          /* %JoinFKPK(inserted,Vozilo) */
          inserted.RegistracijaBroj = Vozilo.RegistracijaBroj
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.RegistracijaBroj IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevAdminu because Vozilo does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevAdminu on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevAdminu"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="KorIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorIme = Korisnik.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevAdminu because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_ZahtevZaPrevoz ON ZahtevZaPrevoz FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ZahtevZaPrevoz */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ZahtevZaPrevoz  Ponuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00010d1a", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevoz"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="IdPaket" */
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.IdPaket = deleted.IdPaket
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ZahtevZaPrevoz because Ponuda exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_ZahtevZaPrevoz ON ZahtevZaPrevoz FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ZahtevZaPrevoz */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insIdPaket int,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ZahtevZaPrevoz  Ponuda on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0006cb15", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevoz"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="IdPaket" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(IdPaket)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.IdPaket = deleted.IdPaket
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ZahtevZaPrevoz because Ponuda exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  ZahtevZaPrevoz on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="Kurir" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Kurir)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.Kurir = Kurir.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Kurir IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevoz because Kurir does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevZaPrevoz on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Posiljalac" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Posiljalac)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.Posiljalac = Korisnik.KorIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Posiljalac IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevoz because Korisnik does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevoz on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="OpstinaPrijem" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(OpstinaPrijem)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.OpstinaPrijem = Opstina.IdOpstina
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.OpstinaPrijem IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevoz because Opstina does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevoz on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevoz"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="OpstinaSlanje" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(OpstinaSlanje)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.OpstinaSlanje = Opstina.IdOpstina
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.OpstinaSlanje IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevoz because Opstina does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


/* Okidac */
CREATE TRIGGER TR_TransportOffer_izbrisiOstalePonude
   ON  Ponuda
   AFTER DELETE
AS 
BEGIN
	DELETE FROM Ponuda WHERE IdPaket = (Select IdPaket from deleted)

END
GO

/* Procedure */

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