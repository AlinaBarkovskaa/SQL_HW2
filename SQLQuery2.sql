DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
go
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), 
	phone BIGINT  UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) 

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT  NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT  NULL,
    created_at DATETIME DEFAULT getdate(),
    hometown VARCHAR(100)
);

ALTER TABLE profiles ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE 

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	from_user_id BIGINT  NOT NULL,
    to_user_id BIGINT  NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT getdate(), 

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT  NOT NULL,
    target_user_id BIGINT  NOT NULL,
    status VARCHAR(10) CHECK (status IN('requested', 'approved', 'declined', 'unfriended')) DEFAULT 'requested',
	requested_at DATETIME DEFAULT getdate(),
	updated_at DATETIME,
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(150),
	admin_user_id BIGINT  NOT NULL,
	
	INDEX communities_name_idx(name), 
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT  NOT NULL,
	community_id BIGINT  NOT NULL,
  
	PRIMARY KEY (user_id, community_id), 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255), 
    created_at DATETIME DEFAULT getdate(),
	updated_at DATETIME,
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    media_type_id BIGINT  NOT NULL,
    user_id BIGINT  NOT NULL,
  	body text,
    filename VARCHAR(255),   	
    size INT,
	metadata VARCHAR(2550),
    created_at DATETIME DEFAULT getdate(),
	updated_at DATETIME,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id BIGINT  NOT NULL IDENTITY(1,1) PRIMARY KEY, 
    user_id BIGINT  NOT NULL,
    media_id BIGINT  NOT NULL,
    created_at DATETIME DEFAULT getdate()

);
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
    id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT getdate(),
);
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
    id BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT getdate(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);
go
ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);
go
ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);
go	
ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

