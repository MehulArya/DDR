-- Create database
CREATE DATABASE ddr;
GO

-- Switch to database
USE ddr;
GO

-- Create ROLES table
CREATE TABLE ROLES (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(255),
    [description] VARCHAR(MAX)
);
GO

-- Insert into ROLES
INSERT INTO ROLES (role_name, [description]) VALUES 
('Admin', 'The Admin role possesses comprehensive control over the portal''s structure and user permissions.'), 
('Head', 'The Head role focuses on overseeing content and user actions within specific categories.'), 
('Faculty', 'The Faculty role primarily interacts with the portal for uploading, viewing, and managing their own files.');
GO

-- Create PERMISSIONS table
CREATE TABLE PERMISSIONS (
    prm_id INT IDENTITY(1,1) PRIMARY KEY,
    prm_name VARCHAR(50),
    prm_codename VARCHAR(50) UNIQUE NOT NULL,
    prm_description VARCHAR(MAX)
);
GO

-- Insert into PERMISSIONS
INSERT INTO PERMISSIONS (prm_name, prm_codename, prm_description) VALUES
('Access All Folders', 'A001', 'Admins have the ability to view and manage all existing folders within the portal.'),
('Create New Folder', 'A002', 'Capability to establish new organizational folders for content.'),
('Add New Column', 'A003', 'Ability to add new data fields or attributes (columns) to existing structures, likely for metadata or categorization.'),
('Permission Change', 'A004', 'Manage and modify user permissions across the portal.'),
('Password Change', 'A005', 'Reset or change passwords for other users.'),
('View History', 'A006', 'Uploaded history of faculty.'),
('Access Folders (according to Category)', 'H001', 'Heads can access and view folders relevant to their assigned categories.'),
('View Actions', 'H002', 'Monitor activities and changes made within their purview.'),
('Get Email on Incorrect Upload', 'H003', 'Receive notifications via email if an incorrect file upload occurs, ensuring data quality.'),
('Add Column', 'H004', 'Similar to Admin, Heads might have the ability to add columns within their specific categories.'),
('View History', 'H005', 'Uploaded history of faculty.'),
('Upload Files', 'F001', 'Faculty members can upload documents to the portal.'),
('View History', 'F002', 'Access a record of their past uploads and activities.'),
('Retrieve Files', 'F003', 'Download or access files they have previously uploaded.'),
('Update Files', 'F004', 'Modify or replace existing files.'),
('Get Email on Incorrect Upload', 'F005', 'Similar to the Head role, Faculty also receive notifications for their own incorrect uploads.');
GO

-- Create USER_ROLES table
CREATE TABLE USER_ROLES (
    user_id INT,
    role_id INT,
    assigned_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES user_auth(id),
    FOREIGN KEY (role_id) REFERENCES ROLES(role_id),
    PRIMARY KEY (user_id, role_id)
);
GO

-- Create FOLDERS table
CREATE TABLE FOLDERS (
    id INT IDENTITY(1,1) PRIMARY KEY,
    folder_name NVARCHAR(255) NOT NULL,
    parent_id INT NULL,
    category NVARCHAR(100),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),
    is_active BIT DEFAULT 1,

    CONSTRAINT FK_folders_parent FOREIGN KEY (parent_id) REFERENCES FOLDERS(id),
);

-- Add an index on parent_id for faster hierarchical queries
CREATE INDEX IX_folders_parent_id ON folders(parent_id);

-- Insert Into Folders
INSERT INTO FOLDERS (folder_name,parent_id,category,created_at,updated_at,is_active)
VALUES ('Academic Calendar', NULL, 'TLP', SYSDATETIME(), SYSDATETIME(), 1), 
('Coordinator Alumni Association (Department Level)', NULL, 'External', SYSDATETIME(), SYSDATETIME(), 1),
('Coordinator - Sports and Games', NULL, 'External', SYSDATETIME(), SYSDATETIME(), 1),
('CO-PO_Coordinator', NULL, 'OBE', SYSDATETIME(), SYSDATETIME(), 1),
('Course File, Lab manual & Handbook Coordinator', NULL, 'Audit', SYSDATETIME(), SYSDATETIME(), 1),
('SoDECA & Student Coordinator', NULL, 'MOOCs and Student Data', SYSDATETIME(), SYSDATETIME(), 1),
('SoDECA & Student Coordinator', NULL, 'MOOCs and Student Data', SYSDATETIME(), SYSDATETIME(), 1),
('ERP Coordinator-CSE', NULL, ' Internal', SYSDATETIME(), SYSDATETIME(), 1),
('ERP Coordinator-CSE(Allied)', NULL, 'Internal', SYSDATETIME(), SYSDATETIME(), 1),
('Events organized by department for students and faculty (Sponsored events & Non Sponsored events)', NULL, 'R & D', SYSDATETIME(), SYSDATETIME(), 1),
('Examination Result Analysis Coordinator', NULL, 'Exam and T&P Cell', SYSDATETIME(), SYSDATETIME(), 1),
('External Examination Coordinator', NULL, 'Exam and T&P Cell', SYSDATETIME(), SYSDATETIME(), 1),
('Faculty & Staff Basic Details/Personal', NULL, 'Audit', SYSDATETIME(), SYSDATETIME(), 1),
('Faculty & Staff Basic Details/Higher studies', NULL, 'Audit', SYSDATETIME(), SYSDATETIME(), 1),
('Incubation Cell Coordinator(Department)', NULL, 'R & D', SYSDATETIME(), SYSDATETIME(), 1),
('Industrial Training', NULL, 'Exam and T&P Cell', SYSDATETIME(), SYSDATETIME(), 1),
('Infosys Springboard & IBM Skills Build', NULL, 'Internal', SYSDATETIME(), SYSDATETIME(), 1),
('IOT Center of Excellence Coordinator', NULL, 'R & D', SYSDATETIME(), SYSDATETIME(), 1),
('Member - Red Cross Club', NULL, 'External', SYSDATETIME(), SYSDATETIME(), 1),
('Faculty & Staff Basic Details/Higher studies', NULL, ' Audit', SYSDATETIME(), SYSDATETIME(), 1),
('MoUs', NULL, 'TLP', SYSDATETIME(), SYSDATETIME(), 1),
('NAAC & Institute Ranking', NULL, 'Audit', SYSDATETIME(), SYSDATETIME(), 1),
('NIRF Data Format', NULL, 'External', SYSDATETIME(), SYSDATETIME(), 1),
('Oracle Academic & Red Hat Coordinator', NULL, 'Internal', SYSDATETIME(), SYSDATETIME(), 1),
('Placement Record', NULL, 'Exam and T&P Cell', SYSDATETIME(), SYSDATETIME(), 1),
('Publication and Patents (for faculty and Students) Coordinator', NULL, 'R & D', SYSDATETIME(), SYSDATETIME(), 1),
('Question Paper & Answer Sheet Vetting Committee', NULL, 'Exam and T&P Cell', SYSDATETIME(), SYSDATETIME(), 1),
('Remedial,Make-Up Classes Records',NULL,'TLP', SYSDATETIME(), SYSDATETIME(),1),
('Research Centre Coordinator',NULL,'R & D',SYSDATETIME(),SYSDATETIME(),1),
('Skill Development Cell',NULL,'Exam and T&P Cell',SYSDATETIME(),SYSDATETIME(),1),
('SKIT Times, SKIT Brochure Magazine Coordinator Website,Department Social media',NULL,'External',SYSDATETIME(),SYSDATETIME(),1),
('Sponosored Research, Grant Received and Consultancy',NULL,'R & D',SYSDATETIME(),SYSDATETIME(),1),
('Student Project Coordinator(Internal & External)',NULL,'R & D',SYSDATETIME(),SYSDATETIME(),1),
('Time Table CSE',NULL,'TLP',SYSDATETIME(),SYSDATETIME(),1),
('Virtual Lab Records',NULL,'Internal',SYSDATETIME(),SYSDATETIME(),1)
;