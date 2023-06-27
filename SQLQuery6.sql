ALTER TABLE likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES media(id);
go
ALTER TABLE likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES users(id);
go	
ALTER TABLE profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);


