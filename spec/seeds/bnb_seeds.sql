-- To accompany these tables create a database called 'bnb' and 'bnb_test'

DROP TABLE IF EXISTS users, listings, dates_list, requests, converse;

CREATE TABLE users ("id" SERIAL PRIMARY KEY, "name" text, "email" text, "password" text);

CREATE TABLE listings ("id" SERIAL PRIMARY KEY, "user_id" int, "name" text, "description" text, "night_price" int,
    constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade);

CREATE TABLE dates_list ("id" SERIAL PRIMARY KEY, "listing_id" int, "date" date, "booked_status" boolean, "booker_id" int,
    constraint fk_listing foreign key(listing_id)
    references listings(id)
    on delete cascade);

CREATE TABLE requests ("id" SERIAL PRIMARY KEY, "user_id" int, "date_list_id" int,
    constraint fk_usermatch foreign key(user_id) references users(id) on delete cascade,
    constraint fk_datematch foreign key(date_list_id) references dates_list(id) on delete cascade);

CREATE TABLE converse ("id" SERIAL PRIMARY KEY, "receiver_user_id" int, "sender_user_id" text, "message_time" TIMESTAMP, "message_content" text, "date_list_id" int, "listing_name" text,
constraint fk_convo foreign key(receiver_user_id)
references users(id)
on delete cascade);


INSERT INTO users ("name", "email", "password") VALUES 
('Anna', 'anna@gmail.com', '1234'),
('Beelzebub', 'bezel@gmail.com', '666'),
('Qanon', 'thehoax@gmail.com', 'unbelievable'),
('Harriet', 'littleh@gmail.com', 'password'); 

INSERT INTO listings ("user_id", "name", "description", "night_price") VALUES
(1, 'MuddyShack', 'A surprisingly nice place to spend 10 minutes', 10000),
(2, 'Firey Pits', 'If you have ended up here, you will have to make the most of the experience. Low heating bills', 12900),
(2, 'Dark Satanic Mills', 'Probably the best option I have in my portfolio', 39900);

INSERT INTO dates_list ("listing_id", "date", "booked_status", "booker_id") VALUES
(1, '2023-01-20', FALSE, null),
(1, '2023-01-21', FALSE, null),
(1, '2023-01-22', FALSE, null),
(1, '2023-01-23', TRUE, 4),
(2, '2023-01-20', TRUE, 3),
(2, '2023-01-21', FALSE, null),
(2, '2023-01-22', FALSE, null),
(2, '2023-01-23', FALSE, null),
(3, '2023-02-02', FALSE, null),
(3, '2023-02-03', FALSE, null),
(3, '2023-02-04', FALSE, null),
(3, '2023-02-05', FALSE, null),
(3, '2023-02-06', TRUE, 1),
(3, '2023-02-07', FALSE, null),
(3, '2023-02-08', FALSE, null),
(1, '2023-03-01', FALSE, null),
(1, '2023-03-02', FALSE, null),
(1, '2023-03-03', FALSE, null),
(1, '2023-03-04', FALSE, null),
(2, '2023-04-01', TRUE, 4),
(2, '2023-04-02', TRUE, 4),
(2, '2023-04-03', TRUE, 4),
(2, '2023-04-04', TRUE, 4),
(3, '2023-04-01', FALSE, null),
(3, '2023-04-02', FALSE, null),
(3, '2023-04-03', FALSE, null),
(3, '2023-04-04', FALSE, null);

INSERT INTO requests ("user_id", "date_list_id") VALUES
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 9),
(1,24),
(1,26),
(1,27),
(1,4);

INSERT INTO converse ("id", "receiver_user_id", "sender_user_id", "message_time", "message_content", "date_list_id", "listing_name") VALUES
(1,1,4, '2022-11-10 12:18:57', 'hey, thanks for confirming my booking',4,'MuddyShack'),
(2,1,4, '2022-11-10 12:19:57', 'what happens with getting the key?',4,'MuddyShack'),
(3,4,1, '2022-11-10 13:19:57', 'thanks for booking! key will be left under the plant pot',4,'MuddyShack'),
(4,1,4, '2022-11-10 14:19:57', 'great - you got any good restaurant recommendations?',4,'MuddyShack'),
(5,4,1, '2022-11-10 15:19:57', 'i hear macdonalds is nice this time of year',4,'MuddyShack'),
(6,1,4, '2022-11-10 16:19:57', 'is that really the best thing around your way? nothing micheline starred?',4,'MuddyShack');