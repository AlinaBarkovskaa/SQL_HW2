CREATE TRIGGER dbo.trgAfterUpdate11 ON dbo.media
AFTER INSERT, UPDATE 
AS
  UPDATE f set updated_at=GETDATE() 
  FROM 
  dbo.media AS f 
  INNER JOIN inserted 
  AS i 
  ON f.id = i.id 