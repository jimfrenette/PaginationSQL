USE [Chinook]
GO

/****** Object:  StoredProcedure [dbo].[sp_ArtistsByPage]    Script Date: 02/06/2011 14:45:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ArtistsByPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ArtistsByPage]
GO

USE [Chinook]
GO

/****** Object:  StoredProcedure [dbo].[sp_ArtistsByPage]    Script Date: 02/06/2011 14:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ArtistsByPage]
(
	@pageSize INT,
	@pageNumber INT
)
AS
 
DECLARE	
	@firstRow INT,
	@lastRow INT
 
SELECT	@firstRow = (@pageNumber - 1) * @pageSize + 1,
	@lastRow = (@pageNumber - 1) * @pageSize + @pageSize ;
 
WITH Artist  AS
(
	SELECT ROW_NUMBER() OVER (ORDER BY Name ASC) AS RowNumber,
	COUNT(*) OVER () AS TotalCount, * FROM dbo.Artist
)
SELECT	* FROM	Artist
	WHERE RowNumber BETWEEN @firstRow AND @lastRow
GO
