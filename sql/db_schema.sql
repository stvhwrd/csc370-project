DROP DATABASE IF EXISTS saiddit;
CREATE DATABASE saiddit;

USE saiddit;

/* Creates the database*/
create table Accounts(
	username VARCHAR(255) PRIMARY KEY,
	password CHAR(80) NOT NULL,
	reputation INT DEFAULT 0
);

create table Subsaiddits(
	title VARCHAR(255) PRIMARY KEY,
	description VARCHAR(512),
	creator_key VARCHAR(255) NOT NULL,
	creation_time DATETIME,
	front_page BOOLEAN DEFAULT 0,

	FOREIGN KEY (creator_key) REFERENCES Accounts(username) ON DELETE CASCADE
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    publish_time DATETIME,
    edit_time DATETIME,    
    title VARCHAR(255) NOT NULL,
    url VARCHAR(2048),    
    text TEXT,    
    upvotes INT DEFAULT 0,
    downvotes INT DEFAULT 0,
    subsaiddit VARCHAR(255) NOT NULL,
    author_key VARCHAR(255) NOT NULL,

    FOREIGN KEY (subsaiddit) REFERENCES Subsaiddits(title) ON DELETE CASCADE,
    FOREIGN KEY (author_key) REFERENCES Accounts(username) ON DELETE CASCADE 
);

create table Comments(
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    creation_time DATETIME,    
    text TEXT,
    parent_post INT NOT NULL,    
    upvotes INT,
    downvotes INT,
    parent_message INT,
    commentor_id VARCHAR(255) NOT NULL,

    FOREIGN KEY (parent_post) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (commentor_id) REFERENCES Accounts(username) ON DELETE CASCADE
);

create table Favourites(
    user_id VARCHAR(255),
    post_id INT,

    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Accounts(username) ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id VARCHAR(255) NOT NULL,
    friend_id VARCHAR(255) NOT NULL,

    PRIMARY KEY (user_id,friend_id),
    FOREIGN KEY (user_id) REFERENCES Accounts(username) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Accounts(username) ON DELETE CASCADE
);

CREATE TABLE Subscribes (
    user_id VARCHAR(255) NOT NULL,
    subsaidd_id VARCHAR(255) NOT NULL,

    PRIMARY KEY (user_id, subsaidd_id),
    FOREIGN KEY (user_id) REFERENCES Accounts(username) ON DELETE CASCADE,
    FOREIGN KEY (subsaidd_id) REFERENCES Subsaiddits(title) ON DELETE CASCADE
);

CREATE TABLE Votes (
    user_id VARCHAR(255) NOT NULL,
    vote BOOLEAN NOT NULL,
    post_id INT NOT NULL,
    
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Accounts(username) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

/* Triggers for adding current time for certain insertions */
CREATE TRIGGER create_time_subsaiddit BEFORE INSERT ON Subsaiddits FOR EACH ROW
    SET NEW.creation_time = NOW();

CREATE TRIGGER create_time_post BEFORE INSERT ON Posts FOR EACH ROW
    SET NEW.publish_time = NOW();

CREATE TRIGGER create_time_comment BEFORE INSERT ON Comments FOR EACH ROW
    SET NEW.creation_time = NOW();

/* Stored procedures for POST requests */
DELIMITER $$
CREATE DEFINER=`csc370`@`localhost` PROCEDURE `sp_createUser`(
    IN p_username VARCHAR(20),
    IN p_password VARCHAR(20)
)
BEGIN
    if ( select exists (select 1 from Accounts where username = p_username) ) THEN
        select 'Username Exists !!';
    ELSE
        insert into Accounts
        (
            user_username,
            user_password
        )
        values
        (
            p_username,
            p_password
        );
     
    END IF;
END$$
DELIMITER ;
