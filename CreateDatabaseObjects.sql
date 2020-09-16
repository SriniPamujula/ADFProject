USE ADFProject
GO
CREATE TABLE [dbo].[MedAptus_RoundingList](
	[Date] [date] NOT NULL,
	[MedAptusApplicationCode] [varchar](100) NOT NULL,
	[MedAptusGroupName] [varchar](100) NOT NULL,
	[RoundingListTotal] [int] NOT NULL,
	[SourceFilename] [varchar](100) NOT NULL,
	[InsertDateTime] [datetime] NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	[ModifiedDateTime] [datetime] NOT NULL
) ON [PRIMARY]

CREATE TYPE dbo.typ_multiFile AS TABLE (
    col1    CHAR(1) NOT NULL,
    col2    CHAR(1) NOT NULL,
    col3    CHAR(1) NOT NULL
)
GO


CREATE OR ALTER PROC dbo.usp_ins_myTable (
    @fileName       AS VARCHAR (100),
    @typ            AS dbo.typ_multiFile READONLY
    )
AS
SET NOCOUNT ON

INSERT INTO dbo.myTable ( [fileName], col1, col2, col3 )
SELECT @fileName, col1, col2, col3
FROM @typ 
