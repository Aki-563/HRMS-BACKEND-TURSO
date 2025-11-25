BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "employee_teams" (
	"id"	INTEGER,
	"employee_id"	INTEGER,
	"team_id"	INTEGER,
	"assigned_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("employee_id") REFERENCES "employees"("id") ON DELETE CASCADE,
	FOREIGN KEY("team_id") REFERENCES "teams"("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "employees" (
	"id"	INTEGER,
	"organisation_id"	INTEGER,
	"first_name"	TEXT,
	"last_name"	TEXT,
	"email"	TEXT,
	"phone"	TEXT,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"gender"	TEXT,
	"img_url"	TEXT,
	"role"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("organisation_id") REFERENCES "organisations"("id")
);
CREATE TABLE IF NOT EXISTS "logs" (
	"id"	INTEGER,
	"organisation_id"	INTEGER,
	"user_id"	INTEGER,
	"action"	TEXT,
	"timestamp"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "organisations" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "teams" (
	"id"	INTEGER,
	"organisation_id"	INTEGER,
	"name"	TEXT NOT NULL,
	"description"	TEXT,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	"img_url"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("organisation_id") REFERENCES "organisations"("id")
);
CREATE TABLE IF NOT EXISTS "users" (
	"id"	INTEGER,
	"organisation_id"	INTEGER,
	"email"	TEXT NOT NULL UNIQUE,
	"password_hash"	TEXT NOT NULL,
	"name"	TEXT,
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("organisation_id") REFERENCES "organisations"("id")
);
INSERT INTO "employee_teams" VALUES (1,1,1,'2025-11-21 03:16:57');
INSERT INTO "employee_teams" VALUES (2,2,2,'2025-11-21 03:16:57');
INSERT INTO "employee_teams" VALUES (3,3,3,'2025-11-21 03:16:57');
INSERT INTO "employee_teams" VALUES (4,5,7,'2025-11-21 11:45:15');
INSERT INTO "employee_teams" VALUES (5,8,7,'2025-11-21 11:45:15');
INSERT INTO "employee_teams" VALUES (6,10,7,'2025-11-21 11:53:08');
INSERT INTO "employee_teams" VALUES (9,12,6,'2025-11-21 11:56:07');
INSERT INTO "employee_teams" VALUES (10,6,5,'2025-11-21 11:57:08');
INSERT INTO "employee_teams" VALUES (15,10,4,'2025-11-21 11:57:57');
INSERT INTO "employee_teams" VALUES (17,13,4,'2025-11-21 11:59:02');
INSERT INTO "employee_teams" VALUES (18,4,4,'2025-11-21 11:59:02');
INSERT INTO "employee_teams" VALUES (19,7,4,'2025-11-21 11:59:02');
INSERT INTO "employee_teams" VALUES (20,11,4,'2025-11-21 11:59:02');
INSERT INTO "employee_teams" VALUES (28,7,5,'2025-11-22 11:03:54');
INSERT INTO "employee_teams" VALUES (33,13,5,'2025-11-22 11:08:51');
INSERT INTO "employee_teams" VALUES (38,6,6,'2025-11-22 13:03:10');
INSERT INTO "employee_teams" VALUES (39,5,6,'2025-11-22 13:43:58');
INSERT INTO "employee_teams" VALUES (40,7,6,'2025-11-22 13:43:58');
INSERT INTO "employee_teams" VALUES (41,16,6,'2025-11-22 13:43:58');
INSERT INTO "employee_teams" VALUES (42,6,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (43,4,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (44,5,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (45,8,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (46,11,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (47,13,8,'2025-11-22 13:53:31');
INSERT INTO "employee_teams" VALUES (48,19,8,'2025-11-22 13:53:31');
INSERT INTO "employees" VALUES (1,1,'John','Doe','john.doe@techcorp.com','1234567890','2025-11-21 03:14:58',NULL,NULL,NULL);
INSERT INTO "employees" VALUES (2,1,'Jane','Smith','jane.smith@techcorp.com','0987654321','2025-11-21 03:14:58',NULL,NULL,NULL);
INSERT INTO "employees" VALUES (3,2,'Mike','Johnson','mike.johnson@innovatex.com','1122334455','2025-11-21 03:14:58',NULL,NULL,NULL);
INSERT INTO "employees" VALUES (4,7,'Laila','sharma','lailas@jadentech.com','9876543210','2025-11-21 09:05:57','female','https://media.istockphoto.com/id/1987655119/photo/smiling-young-businesswoman-standing-in-the-corridor-of-an-office.jpg?s=612x612&w=0&k=20&c=5N_IVGYsXoyj-H9vEiZUCLqbmmineaemQsKt2NTXGms=','Manager');
INSERT INTO "employees" VALUES (5,7,'Rahul','kumar','rahulk@jadentech.com','9876590210','2025-11-21 09:06:44','male','https://as2.ftcdn.net/jpg/04/32/89/63/1000_F_432896398_99o08tTgBYj8YP2eatvF4zaJu3AdF40E.jpg','Senior Manager');
INSERT INTO "employees" VALUES (6,7,'Aadharsh','abaian','aadharshab@jadentech.com','0739702989','2025-11-21 09:07:15','male','https://res.cloudinary.com/deonwh9i9/image/upload/v1744864922/samples/smile.jpg','VP (Vice President)');
INSERT INTO "employees" VALUES (7,7,'Arjun','karthik','arjunr@jadentech.com','8826792010','2025-11-21 09:09:25','male','https://media.istockphoto.com/id/1399565382/photo/young-happy-mixed-race-businessman-standing-with-his-arms-crossed-working-alone-in-an-office.jpg?s=612x612&w=0&k=20&c=buXwOYjA_tjt2O3-kcSKqkTp2lxKWJJ_Ttx2PhYe3VM=','Associate');
INSERT INTO "employees" VALUES (8,7,'Keerthana','manohar','keerthm@jadentech.com','8826782010','2025-11-21 09:10:10','female','https://img.freepik.com/premium-photo/portrait-successful-business-woman-suit-gray-isolated-background-serious-office-female-worker-manager-employees-female-employee-young-secretary_545934-15955.jpg','Associate');
INSERT INTO "employees" VALUES (9,7,'Abinaya','jayaram','abhijay@jadentech.com','9820782910','2025-11-21 09:11:17','female','https://www.shutterstock.com/image-photo/portrait-young-successful-indian-woman-260nw-2333600425.jpg','Intern');
INSERT INTO "employees" VALUES (10,7,'Madhumitha','basor','madhub@jadentech.com','9820778910','2025-11-21 09:12:48','female','https://img.freepik.com/premium-photo/portrait-indian-business-manager-employee-suit_753390-10898.jpg','Director');
INSERT INTO "employees" VALUES (11,7,'Pooja','kumaari','poojak@jadentech.com','9820908910','2025-11-21 09:14:30','female','https://img.freepik.com/premium-photo/confident-indian-woman-professional-attire-standing-studio-portrait_1168123-41653.jpg','Lead');
INSERT INTO "employees" VALUES (12,7,'Vasanth','kumar','vasanthakum@jadentech.com','9890008910','2025-11-21 09:16:25','male','https://www.shutterstock.com/image-photo/portrait-casual-smiling-caucasian-male-260nw-1105355777.jpg','Senior Associate');
INSERT INTO "employees" VALUES (13,7,'Karthik','raja','karthikr@jadentech.com','9892228910','2025-11-21 09:16:56','male','https://thumbs.dreamstime.com/b/profile-picture-caucasian-male-employee-posing-office-happy-young-worker-look-camera-workplace-headshot-portrait-smiling-190186649.jpg','Associate');
INSERT INTO "employees" VALUES (15,7,'Vinoth','mariraj','vinothmari@jadentech.com','7397029847','2025-11-21 12:11:18','male','https://img.freepik.com/free-photo/confident-entrepreneur-looking-camera-with-arms-folded-smiling_1098-18840.jpg?semt=ais_hybrid&w=740','intern');
INSERT INTO "employees" VALUES (16,7,'Adithi','malhotra','aditimalho@jadentech.com','9985654456','2025-11-21 12:12:57','female','https://photos.peopleimages.com/picture/202302/2628087-happy-smile-and-portrait-of-indian-woman-at-desk-for-management-planning-and-data.-research-innovation-and-vision-with-face-of-employee-in-office-for-information-website-and-professional--fit_400_400.jpg','intern');
INSERT INTO "employees" VALUES (17,7,'Geetha','selvam','geethasel@jadentech.com','9985654489','2025-11-21 12:14:40','female','https://t3.ftcdn.net/jpg/05/47/05/56/360_F_547055652_UTp7QLnRuiVl7GVOqLvtZOyOwBDi8hBB.jpg','intern');
INSERT INTO "employees" VALUES (19,7,'Kalyani','Priya','kalyanipr@jadentech.com','9876543210','2025-11-22 05:28:53','female','https://t3.ftcdn.net/jpg/01/87/83/26/360_F_187832626_Z0K54NuFDzPM10NZw6gWdRYMC763xJQM.jpg','React Developer');
INSERT INTO "logs" VALUES (1,1,1,'Logged in','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (2,1,2,'Updated profile','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (3,2,3,'Created team','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (4,1,1,'Logged out','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (5,2,3,'Deleted a team','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (6,1,2,'Added a new employee','2025-11-21 03:50:49');
INSERT INTO "logs" VALUES (7,7,6,'Organisation Registered','2025-11-21 04:27:27');
INSERT INTO "logs" VALUES (8,7,6,'User 6 Logged In','2025-11-21 04:48:49');
INSERT INTO "logs" VALUES (9,7,6,'User 6 Logged In','2025-11-21 04:49:40');
INSERT INTO "logs" VALUES (10,7,6,'User 6 Logged In','2025-11-21 09:03:11');
INSERT INTO "logs" VALUES (11,7,6,'Added Employee 4 by User 6','2025-11-21 09:05:57');
INSERT INTO "logs" VALUES (12,7,6,'Added Employee 5 by User 6','2025-11-21 09:06:44');
INSERT INTO "logs" VALUES (13,7,6,'Added Employee 6 by User 6','2025-11-21 09:07:15');
INSERT INTO "logs" VALUES (14,7,6,'Added Employee 7 by User 6','2025-11-21 09:09:25');
INSERT INTO "logs" VALUES (15,7,6,'Added Employee 8 by User 6','2025-11-21 09:10:10');
INSERT INTO "logs" VALUES (16,7,6,'Added Employee 9 by User 6','2025-11-21 09:11:17');
INSERT INTO "logs" VALUES (17,7,6,'Added Employee 10 by User 6','2025-11-21 09:12:48');
INSERT INTO "logs" VALUES (18,7,6,'Added Employee 11 by User 6','2025-11-21 09:14:30');
INSERT INTO "logs" VALUES (19,7,6,'Added Employee 12 by User 6','2025-11-21 09:16:25');
INSERT INTO "logs" VALUES (20,7,6,'Added Employee 13 by User 6','2025-11-21 09:16:56');
INSERT INTO "logs" VALUES (21,7,6,'Updated Employee 4 by User 6','2025-11-21 09:21:05');
INSERT INTO "logs" VALUES (22,7,6,'Updated Employee 6 by User 6','2025-11-21 09:50:41');
INSERT INTO "logs" VALUES (23,7,6,'Updated Employee 7 by User 6','2025-11-21 09:58:37');
INSERT INTO "logs" VALUES (24,7,6,'Updated Employee 13 by User 6','2025-11-21 09:58:54');
INSERT INTO "logs" VALUES (25,7,6,'Updated Employee 5 by User 6','2025-11-21 09:59:03');
INSERT INTO "logs" VALUES (26,7,6,'Updated Employee 12 by User 6','2025-11-21 09:59:11');
INSERT INTO "logs" VALUES (27,7,6,'Updated Employee 9 by User 6','2025-11-21 09:59:41');
INSERT INTO "logs" VALUES (28,7,6,'Updated Employee 8 by User 6','2025-11-21 09:59:49');
INSERT INTO "logs" VALUES (29,7,6,'Updated Employee 4 by User 6','2025-11-21 09:59:54');
INSERT INTO "logs" VALUES (30,7,6,'Updated Employee 10 by User 6','2025-11-21 10:00:01');
INSERT INTO "logs" VALUES (31,7,6,'Updated Employee 11 by User 6','2025-11-21 10:00:07');
INSERT INTO "logs" VALUES (32,7,6,'User 6 Logged In','2025-11-21 10:05:25');
INSERT INTO "logs" VALUES (33,7,6,'Updated Employee 6 by User 6','2025-11-21 10:07:29');
INSERT INTO "logs" VALUES (34,7,6,'Updated Employee 6 by User 6','2025-11-21 10:08:33');
INSERT INTO "logs" VALUES (35,7,6,'Updated Employee 6 by User 6','2025-11-21 10:09:17');
INSERT INTO "logs" VALUES (36,7,6,'Updated Employee 6 by User 6','2025-11-21 10:11:54');
INSERT INTO "logs" VALUES (37,7,6,'Updated Employee 6 by User 6','2025-11-21 10:13:11');
INSERT INTO "logs" VALUES (38,7,6,'Updated Employee 9 by User 6','2025-11-21 10:14:03');
INSERT INTO "logs" VALUES (39,7,6,'Updated Employee 7 by User 6','2025-11-21 10:14:40');
INSERT INTO "logs" VALUES (40,7,6,'Updated Employee 13 by User 6','2025-11-21 10:15:00');
INSERT INTO "logs" VALUES (41,7,6,'Updated Employee 8 by User 6','2025-11-21 10:15:30');
INSERT INTO "logs" VALUES (42,7,6,'Updated Employee 4 by User 6','2025-11-21 10:15:48');
INSERT INTO "logs" VALUES (43,7,6,'Updated Employee 10 by User 6','2025-11-21 10:16:05');
INSERT INTO "logs" VALUES (44,7,6,'Updated Employee 11 by User 6','2025-11-21 10:16:22');
INSERT INTO "logs" VALUES (45,7,6,'Updated Employee 5 by User 6','2025-11-21 10:16:51');
INSERT INTO "logs" VALUES (46,7,6,'Updated Employee 12 by User 6','2025-11-21 10:17:05');
INSERT INTO "logs" VALUES (47,7,6,'Updated Employee 9 by User 6','2025-11-21 11:03:56');
INSERT INTO "logs" VALUES (48,7,6,'Updated Employee 8 by User 6','2025-11-21 11:04:33');
INSERT INTO "logs" VALUES (49,7,6,'Updated Employee 12 by User 6','2025-11-21 11:05:17');
INSERT INTO "logs" VALUES (50,7,6,'User 6 Logged In','2025-11-21 11:06:53');
INSERT INTO "logs" VALUES (51,7,6,'Updated Employee 11 by User 6','2025-11-21 11:07:48');
INSERT INTO "logs" VALUES (52,7,6,'Updated Employee 4 by User 6','2025-11-21 11:08:15');
INSERT INTO "logs" VALUES (53,7,6,'Updated Employee 5 by User 6','2025-11-21 11:08:48');
INSERT INTO "logs" VALUES (54,7,6,'Updated Employee 10 by User 6','2025-11-21 11:09:19');
INSERT INTO "logs" VALUES (55,7,6,'Updated Employee 6 by User 6','2025-11-21 11:09:42');
INSERT INTO "logs" VALUES (56,7,6,'Updated Employee 7 by User 6','2025-11-21 11:09:58');
INSERT INTO "logs" VALUES (57,7,6,'Updated Employee 13 by User 6','2025-11-21 11:10:05');
INSERT INTO "logs" VALUES (58,7,6,'Added Team 4 by User 6','2025-11-21 11:19:22');
INSERT INTO "logs" VALUES (59,7,6,'Added Team 5 by User 6','2025-11-21 11:21:09');
INSERT INTO "logs" VALUES (60,7,6,'Added Team 6 by User 6','2025-11-21 11:22:45');
INSERT INTO "logs" VALUES (61,7,6,'Added Team 7 by User 6','2025-11-21 11:23:44');
INSERT INTO "logs" VALUES (62,7,6,'Added Team 8 by User 6','2025-11-21 11:25:14');
INSERT INTO "logs" VALUES (63,7,6,'Team 8 updated by User 6','2025-11-21 11:32:42');
INSERT INTO "logs" VALUES (64,7,6,'Team 7 updated by User 6','2025-11-21 11:33:50');
INSERT INTO "logs" VALUES (65,7,6,'Team 6 updated by User 6','2025-11-21 11:34:37');
INSERT INTO "logs" VALUES (66,7,6,'Team 5 updated by User 6','2025-11-21 11:35:16');
INSERT INTO "logs" VALUES (67,7,6,'Team 4 updated by User 6','2025-11-21 11:35:55');
INSERT INTO "logs" VALUES (68,7,6,'Team 9 created by User 6','2025-11-21 11:38:09');
INSERT INTO "logs" VALUES (69,7,6,'Team 9 Deleted by User 6','2025-11-21 11:38:44');
INSERT INTO "logs" VALUES (70,7,6,'Assigned employees [5, 8] to team ID 7 by User 6','2025-11-21 11:45:15');
INSERT INTO "logs" VALUES (71,7,6,'Assigned employees 10 to team 7 by user 6','2025-11-21 11:53:08');
INSERT INTO "logs" VALUES (72,7,6,'Assigned employees  to team 7 by user 6','2025-11-21 11:53:20');
INSERT INTO "logs" VALUES (73,7,6,'Assigned employees  to team 7 by user 6','2025-11-21 11:53:45');
INSERT INTO "logs" VALUES (74,7,6,'Assigned employees 11, 5, 12 to team 6 by user 6','2025-11-21 11:56:07');
INSERT INTO "logs" VALUES (75,7,6,'Assigned employees 6, 13, 12 to team 5 by user 6','2025-11-21 11:57:08');
INSERT INTO "logs" VALUES (76,7,6,'Assigned employees 6, 8, 10 to team 4 by user 6','2025-11-21 11:57:57');
INSERT INTO "logs" VALUES (77,7,6,'Assigned employees 9, 13, 4, 7, 11, 12 to team 4 by user 6','2025-11-21 11:59:02');
INSERT INTO "logs" VALUES (78,7,6,'Assigned employees 9, 13, 4, 7, 11, 12 to team 8 by user 6','2025-11-21 12:01:20');
INSERT INTO "logs" VALUES (79,7,6,'User 6 Logged In','2025-11-21 12:08:44');
INSERT INTO "logs" VALUES (80,7,6,'Added Employee 14 by User 6','2025-11-21 12:09:24');
INSERT INTO "logs" VALUES (81,7,6,'Added Employee 15 by User 6','2025-11-21 12:11:18');
INSERT INTO "logs" VALUES (82,7,6,'Added Employee 16 by User 6','2025-11-21 12:12:57');
INSERT INTO "logs" VALUES (83,7,6,'Added Employee 17 by User 6','2025-11-21 12:14:40');
INSERT INTO "logs" VALUES (84,7,6,'User 6 Logged In','2025-11-21 12:23:27');
INSERT INTO "logs" VALUES (85,7,6,'Removed employees [9, 8, 100] from team ID 4 by User 6','2025-11-21 12:25:59');
INSERT INTO "logs" VALUES (86,7,6,'Removed employees [12] from team ID 4 by User 6','2025-11-21 12:26:55');
INSERT INTO "logs" VALUES (87,7,6,'Added Employee 18 by User 6','2025-11-21 12:46:17');
INSERT INTO "logs" VALUES (88,7,6,'Updated Employee 18 by User 6','2025-11-21 12:47:28');
INSERT INTO "logs" VALUES (89,7,6,'User 6 Logged In','2025-11-21 15:18:37');
INSERT INTO "logs" VALUES (90,7,6,'User 6 Logged In','2025-11-21 15:19:51');
INSERT INTO "logs" VALUES (91,7,6,'User 6 Logged In','2025-11-21 15:20:19');
INSERT INTO "logs" VALUES (92,7,6,'User 6 Logged In','2025-11-21 15:22:16');
INSERT INTO "logs" VALUES (93,7,6,'User 6 Logged In','2025-11-21 15:22:22');
INSERT INTO "logs" VALUES (94,7,6,'User 6 Logged In','2025-11-21 15:22:32');
INSERT INTO "logs" VALUES (95,7,6,'User 6 Logged In','2025-11-21 15:22:36');
INSERT INTO "logs" VALUES (96,7,6,'User 6 Logged In','2025-11-21 15:23:14');
INSERT INTO "logs" VALUES (97,7,6,'User 6 Logged In','2025-11-21 15:24:04');
INSERT INTO "logs" VALUES (98,7,6,'User 6 Logged In','2025-11-21 15:24:47');
INSERT INTO "logs" VALUES (99,7,6,'User 6 Logged In','2025-11-21 15:24:52');
INSERT INTO "logs" VALUES (100,7,6,'User 6 Logged In','2025-11-21 15:25:09');
INSERT INTO "logs" VALUES (101,7,6,'User 6 Logged In','2025-11-21 15:25:27');
INSERT INTO "logs" VALUES (102,7,6,'User 6 Logged In','2025-11-21 15:26:22');
INSERT INTO "logs" VALUES (103,7,6,'User 6 Logged In','2025-11-21 15:26:24');
INSERT INTO "logs" VALUES (104,7,6,'User 6 Logged In','2025-11-21 15:28:52');
INSERT INTO "logs" VALUES (105,7,6,'User 6 Logged In','2025-11-21 15:30:26');
INSERT INTO "logs" VALUES (106,7,6,'User 6 Logged In','2025-11-21 15:30:28');
INSERT INTO "logs" VALUES (107,7,6,'User 6 Logged In','2025-11-21 15:31:03');
INSERT INTO "logs" VALUES (108,7,6,'User 6 Logged In','2025-11-21 15:34:54');
INSERT INTO "logs" VALUES (109,7,6,'User 6 Logged In','2025-11-21 15:42:25');
INSERT INTO "logs" VALUES (110,7,6,'User 6 Logged In','2025-11-21 15:43:59');
INSERT INTO "logs" VALUES (111,7,6,'User 6 Logged In','2025-11-21 15:49:33');
INSERT INTO "logs" VALUES (112,7,6,'User 6 Logged In','2025-11-21 15:50:32');
INSERT INTO "logs" VALUES (113,7,6,'User 6 Logged In','2025-11-21 15:55:05');
INSERT INTO "logs" VALUES (114,7,6,'User 6 Logged In','2025-11-21 15:55:38');
INSERT INTO "logs" VALUES (115,7,6,'User 6 Logged In','2025-11-21 16:17:06');
INSERT INTO "logs" VALUES (116,7,6,'User 6 Logged In','2025-11-21 16:56:01');
INSERT INTO "logs" VALUES (117,7,6,'User 6 Logged In','2025-11-22 02:47:41');
INSERT INTO "logs" VALUES (118,7,6,'Updated Employee 6 by User 6','2025-11-22 04:43:16');
INSERT INTO "logs" VALUES (119,7,6,'Updated Employee 6 by User 6','2025-11-22 04:43:30');
INSERT INTO "logs" VALUES (120,7,6,'Updated Employee 6 by User 6','2025-11-22 04:45:21');
INSERT INTO "logs" VALUES (121,7,6,'Updated Employee 6 by User 6','2025-11-22 04:45:29');
INSERT INTO "logs" VALUES (122,7,6,'Updated Employee 6 by User 6','2025-11-22 04:45:35');
INSERT INTO "logs" VALUES (123,7,6,'Updated Employee 6 by User 6','2025-11-22 04:46:33');
INSERT INTO "logs" VALUES (124,7,6,'Updated Employee 6 by User 6','2025-11-22 04:46:38');
INSERT INTO "logs" VALUES (125,7,6,'Updated Employee 6 by User 6','2025-11-22 04:46:45');
INSERT INTO "logs" VALUES (126,7,6,'Updated Employee 6 by User 6','2025-11-22 04:47:11');
INSERT INTO "logs" VALUES (127,7,6,'Updated Employee 6 by User 6','2025-11-22 04:48:04');
INSERT INTO "logs" VALUES (128,7,6,'Updated Employee 6 by User 6','2025-11-22 04:50:10');
INSERT INTO "logs" VALUES (129,7,6,'Added Employee 19 by User 6','2025-11-22 05:28:53');
INSERT INTO "logs" VALUES (130,7,6,'Deleted Employee 18 by User 6','2025-11-22 05:58:16');
INSERT INTO "logs" VALUES (131,7,6,'Deleted Employee 14 by User 6','2025-11-22 05:59:00');
INSERT INTO "logs" VALUES (132,7,6,'Team 10 created by User 6','2025-11-22 07:36:46');
INSERT INTO "logs" VALUES (133,7,6,'Team 10 updated by User 6','2025-11-22 07:52:42');
INSERT INTO "logs" VALUES (134,7,6,'Team 10 updated by User 6','2025-11-22 07:52:45');
INSERT INTO "logs" VALUES (135,7,6,'Team 10 updated by User 6','2025-11-22 07:52:50');
INSERT INTO "logs" VALUES (136,7,6,'Team 10 updated by User 6','2025-11-22 07:52:56');
INSERT INTO "logs" VALUES (137,7,6,'Team 10 updated by User 6','2025-11-22 07:53:04');
INSERT INTO "logs" VALUES (138,7,6,'Team 10 updated by User 6','2025-11-22 07:53:29');
INSERT INTO "logs" VALUES (139,7,6,'Team 10 updated by User 6','2025-11-22 07:53:33');
INSERT INTO "logs" VALUES (140,7,6,'Team 10 updated by User 6','2025-11-22 07:53:37');
INSERT INTO "logs" VALUES (141,7,6,'Team 10 updated by User 6','2025-11-22 07:53:41');
INSERT INTO "logs" VALUES (142,7,6,'Team 10 updated by User 6','2025-11-22 07:54:05');
INSERT INTO "logs" VALUES (143,7,6,'User 6 Logged In','2025-11-22 08:56:01');
INSERT INTO "logs" VALUES (144,7,6,'Unassigned employees [13] from team ID 8 by User 6','2025-11-22 09:12:17');
INSERT INTO "logs" VALUES (145,7,6,'Assigned employees  to team 4 by user 6','2025-11-22 09:34:45');
INSERT INTO "logs" VALUES (146,7,6,'Unassigned employees [6] from team ID 4 by User 6','2025-11-22 09:44:46');
INSERT INTO "logs" VALUES (147,7,6,'User 6 Logged In','2025-11-22 10:23:55');
INSERT INTO "logs" VALUES (148,7,6,'Assigned employees 7, 8 to team 5 by user 6','2025-11-22 11:03:54');
INSERT INTO "logs" VALUES (149,7,6,'Assigned employees 11 to team 5 by user 6','2025-11-22 11:05:22');
INSERT INTO "logs" VALUES (150,7,6,'Assigned employees 4 to team 5 by user 6','2025-11-22 11:07:28');
INSERT INTO "logs" VALUES (151,7,6,'Unassigned employees [11, 4, 8] from team ID 5 by User 6','2025-11-22 11:07:38');
INSERT INTO "logs" VALUES (152,7,6,'Unassigned employees [13] from team ID 5 by User 6','2025-11-22 11:07:55');
INSERT INTO "logs" VALUES (153,7,6,'Unassigned employees [12] from team ID 5 by User 6','2025-11-22 11:08:34');
INSERT INTO "logs" VALUES (154,7,6,'Assigned employees 12, 13, 15, 16 to team 5 by user 6','2025-11-22 11:08:51');
INSERT INTO "logs" VALUES (155,7,6,'Unassigned employees [12] from team ID 5 by User 6','2025-11-22 11:08:57');
INSERT INTO "logs" VALUES (156,7,6,'Assigned employees 12 to team 5 by user 6','2025-11-22 11:09:02');
INSERT INTO "logs" VALUES (157,7,6,'Assigned employees 11 to team 5 by user 6','2025-11-22 11:21:10');
INSERT INTO "logs" VALUES (158,7,6,'Unassigned employees [15, 16, 12, 11] from team ID 5 by User 6','2025-11-22 11:21:33');
INSERT INTO "logs" VALUES (159,7,6,'Team 10 updated by User 6','2025-11-22 11:21:51');
INSERT INTO "logs" VALUES (160,8,7,'Organisation 8 Registered','2025-11-22 12:28:31');
INSERT INTO "logs" VALUES (161,8,7,'User 7 Logged In','2025-11-22 12:29:27');
INSERT INTO "logs" VALUES (162,7,6,'User 6 Logged In','2025-11-22 12:52:11');
INSERT INTO "logs" VALUES (163,7,6,'User 6 Logged In','2025-11-22 12:52:18');
INSERT INTO "logs" VALUES (164,7,6,'Assigned employees 6 to team 6 by user 6','2025-11-22 13:03:10');
INSERT INTO "logs" VALUES (165,7,6,'User 6 Logged In','2025-11-22 13:22:43');
INSERT INTO "logs" VALUES (166,7,6,'User 6 Logged In','2025-11-22 13:41:59');
INSERT INTO "logs" VALUES (167,7,6,'Unassigned employees [11, 5] from team ID 6 by User 6','2025-11-22 13:43:49');
INSERT INTO "logs" VALUES (168,7,6,'Assigned employees 5, 7, 16 to team 6 by user 6','2025-11-22 13:43:58');
INSERT INTO "logs" VALUES (169,7,6,'Updated Employee 6 by User 6','2025-11-22 13:46:37');
INSERT INTO "logs" VALUES (170,7,6,'Updated Employee 6 by User 6','2025-11-22 13:46:46');
INSERT INTO "logs" VALUES (171,7,6,'Updated Employee 6 by User 6','2025-11-22 13:46:52');
INSERT INTO "logs" VALUES (172,7,6,'Updated Employee 6 by User 6','2025-11-22 13:47:04');
INSERT INTO "logs" VALUES (173,7,6,'Updated Employee 6 by User 6','2025-11-22 13:47:14');
INSERT INTO "logs" VALUES (174,7,6,'Updated Employee 9 by User 6','2025-11-22 13:48:03');
INSERT INTO "logs" VALUES (175,7,6,'Updated Employee 16 by User 6','2025-11-22 13:48:19');
INSERT INTO "logs" VALUES (176,7,6,'Updated Employee 7 by User 6','2025-11-22 13:48:30');
INSERT INTO "logs" VALUES (177,7,6,'Updated Employee 17 by User 6','2025-11-22 13:48:40');
INSERT INTO "logs" VALUES (178,7,6,'Updated Employee 13 by User 6','2025-11-22 13:48:57');
INSERT INTO "logs" VALUES (179,7,6,'Updated Employee 8 by User 6','2025-11-22 13:49:07');
INSERT INTO "logs" VALUES (180,7,6,'Updated Employee 4 by User 6','2025-11-22 13:49:22');
INSERT INTO "logs" VALUES (181,7,6,'Updated Employee 10 by User 6','2025-11-22 13:49:36');
INSERT INTO "logs" VALUES (182,7,6,'Updated Employee 11 by User 6','2025-11-22 13:49:46');
INSERT INTO "logs" VALUES (183,7,6,'Updated Employee 5 by User 6','2025-11-22 13:49:58');
INSERT INTO "logs" VALUES (184,7,6,'Updated Employee 12 by User 6','2025-11-22 13:51:15');
INSERT INTO "logs" VALUES (185,7,6,'Updated Employee 15 by User 6','2025-11-22 13:51:25');
INSERT INTO "logs" VALUES (186,7,6,'Unassigned employees [12, 11, 7, 4, 9] from team ID 8 by User 6','2025-11-22 13:53:04');
INSERT INTO "logs" VALUES (187,7,6,'Assigned employees 6, 4, 5, 8, 11, 13, 19 to team 8 by user 6','2025-11-22 13:53:31');
INSERT INTO "logs" VALUES (188,7,6,'User 6 Logged In','2025-11-22 14:07:29');
INSERT INTO "logs" VALUES (189,7,6,'Added Employee 20 by User 6','2025-11-22 14:34:01');
INSERT INTO "logs" VALUES (190,7,6,'Deleted Employee 20 by User 6','2025-11-22 14:34:10');
INSERT INTO "logs" VALUES (191,7,6,'Added Employee 21 by User 6','2025-11-22 14:37:43');
INSERT INTO "logs" VALUES (192,7,6,'Deleted Employee 21 by User 6','2025-11-22 14:37:50');
INSERT INTO "logs" VALUES (193,7,6,'Updated Employee 6 by User 6','2025-11-22 14:58:13');
INSERT INTO "logs" VALUES (194,7,6,'Updated Employee 6 by User 6','2025-11-22 14:58:39');
INSERT INTO "logs" VALUES (195,7,6,'Updated Employee 6 by User 6','2025-11-22 14:58:48');
INSERT INTO "logs" VALUES (196,7,6,'Added Employee 22 by User 6','2025-11-22 14:59:30');
INSERT INTO "logs" VALUES (197,7,6,'Deleted Employee 22 by User 6','2025-11-22 14:59:43');
INSERT INTO "logs" VALUES (198,7,6,'Team 11 created by User 6','2025-11-22 15:02:49');
INSERT INTO "logs" VALUES (199,7,6,'Team 11 Deleted by User 6','2025-11-22 15:03:01');
INSERT INTO "logs" VALUES (200,7,6,'Team 7 updated by User 6','2025-11-22 15:43:48');
INSERT INTO "logs" VALUES (201,7,6,'Team 4 updated by User 6','2025-11-22 15:44:24');
INSERT INTO "logs" VALUES (202,7,6,'Team 10 updated by User 6','2025-11-22 15:45:29');
INSERT INTO "logs" VALUES (203,7,6,'User 6 Logged In','2025-11-22 15:45:46');
INSERT INTO "organisations" VALUES (1,'TechCorp','2025-11-21 03:05:39');
INSERT INTO "organisations" VALUES (2,'InnovateX','2025-11-21 03:05:39');
INSERT INTO "organisations" VALUES (3,'Alpha Solutions','2025-11-21 03:05:39');
INSERT INTO "organisations" VALUES (6,'NewTech','2025-11-21 04:23:05');
INSERT INTO "organisations" VALUES (7,'JadenTech','2025-11-21 04:27:27');
INSERT INTO "organisations" VALUES (8,'test','2025-11-22 12:28:31');
INSERT INTO "teams" VALUES (1,1,'Development','Handles all product development','2025-11-21 03:16:28',NULL);
INSERT INTO "teams" VALUES (2,1,'Marketing','Handles marketing campaigns','2025-11-21 03:16:28',NULL);
INSERT INTO "teams" VALUES (3,2,'Design','UI/UX design team','2025-11-21 03:16:28',NULL);
INSERT INTO "teams" VALUES (4,7,'HR & Operations','HR & Operations at Jadentech takes care of all the important people-related and day-to-day activities inside the company. They handle hiring new employees, supporting team members with any work issues, managing office tasks, and organizing daily operations so that everything runs without stress. Their job is to make sure employees feel comfortable, the work environment stays positive, and the company’s processes move forward efficiently. In short, they are the backbone that keeps the whole company steady, organized, and running smoothly every single day.','2025-11-21 11:19:22','https://img.freepik.com/premium-photo/concept-human-resource-management-organization-businessman-shows-chart-job-allocation-show-level-global-hr-management-company-recruitment-hrm_48954-626.jpg');
INSERT INTO "teams" VALUES (5,7,'Finance Team','The Finance team manages all the money at Jadentech. They track expenses, salaries, budgets, and make sure the company stays financially healthy.','2025-11-21 11:21:09','https://thumbs.dreamstime.com/b/coins-financial-growth-chart-blue-background-finance-investment-concepts-coins-financial-growth-chart-blue-344575282.jpg');
INSERT INTO "teams" VALUES (6,7,'Sales & Marketing Team','The Sales & Marketing team brings customers to Jadentech. They promote the company, run ads, find new leads, and help increase business.','2025-11-21 11:22:45','https://www.salesforce.com/blog/wp-content/uploads/sites/2/2024/04/Sales-and-Marketing.jpg?w=889');
INSERT INTO "teams" VALUES (7,7,'Product & Design Team','This team at Jadentech carefully plans how every feature in the product should work and appear on the screen. They think from the user’s point of view and design the flow step by step, making sure nothing feels confusing. Their goal is to create clean, simple, and easy-to-understand designs so that anyone using the app or website can navigate it smoothly without needing help. They focus on clear layouts, neat visuals, and user-friendly interactions, ensuring the final experience feels comfortable, fast, and enjoyable for everyone.','2025-11-21 11:23:44','https://s44783.pcdn.co/in/wp-content/uploads/sites/3/2022/05/product-design-2.jpg.webp');
INSERT INTO "teams" VALUES (8,7,'Engineering Team','The Engineering team at Jadentech builds and tests all the software. They write the code, fix bugs, and make sure everything works smoothly.','2025-11-21 11:25:14','https://www.clarkson.edu/sites/default/files/2023-06/Software-Engineering-Hero-1600x900.jpg');
INSERT INTO "teams" VALUES (10,7,'Test','"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"','2025-11-22 07:36:46','https://img.freepik.com/free-photo/successful-happy-business-team_53876-74892.jpg?semt=ais_hybrid&w=740&q=80');
INSERT INTO "users" VALUES (1,1,'alice@techcorp.com','hashedpwd1','Alice','2025-11-21 03:07:54');
INSERT INTO "users" VALUES (2,1,'bob@techcorp.com','hashedpwd2','Bob','2025-11-21 03:07:54');
INSERT INTO "users" VALUES (3,2,'carol@innovatex.com','hashedpwd3','Carol','2025-11-21 03:07:54');
INSERT INTO "users" VALUES (4,4,'sam@hozo.com','$2b$10$wgpZr9ovPCuQua1KCLdEtuZdWJUX1hN1o/etlry8E/KH0fm9deOma','Sam','2025-11-21 04:20:48');
INSERT INTO "users" VALUES (5,6,'david@newtech.com','$2b$10$0JVH1E4LjjWwVa1LWxA.keDqmp2myZpr2Uisg7VoetKVGjQjWUpEi','David','2025-11-21 04:23:05');
INSERT INTO "users" VALUES (6,7,'jaden@jadentech.com','$2b$10$EePB2GdxmtWzH81ntvCRl.NI28hOXP5rUSpsswHVkbemM5WY8.7tm','Jaden','2025-11-21 04:27:27');
INSERT INTO "users" VALUES (7,8,'test@gmial.com','$2b$10$me95NZp/Fyk1HfPUZElb5ukO36kNjc1EvoXoo23CJXYcNHvZ1Z/W2','test','2025-11-22 12:28:31');
COMMIT;
