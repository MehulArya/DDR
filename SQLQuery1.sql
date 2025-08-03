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
('Create New Folder', 'A001', 'Capability to establish new organizational folders for content.'),
('Permission Change', 'A002', 'Manage and modify user permissions across the portal.'),
('Delete Folders', 'A003', 'To remove unutilized folders'),
('Access Folders', 'H001', 'Admins have the ability to view and manage all existing folders within the portal.'),
('View Actions', 'H002', 'Monitor activities and changes made within their purview.'),
('Add Column', 'H003', 'Similar to Admin, Heads might have the ability to add columns within their specific categories.'),
('Delete Column', 'H004', 'Similar to Admin, Heads might have the ability to add columns within their specific categories.'),
('Upload Files', 'F001', 'Faculty members can upload documents to the portal.'),
('View History', 'F002', 'Access a record of their past uploads and activities.'),
('Retrieve Files', 'F003', 'Download or access files they have previously uploaded.'),
('Update Files', 'F004', 'Modify or replace existing files.'); 
GO

-- Create Role_Permissions
CREATE TABLE ROLE_PERMISSIONS (
    role_id INT NOT NULL,
    permission_code VARCHAR(50) NOT NULL,
    PRIMARY KEY (role_id, permission_code),
    FOREIGN KEY (role_id) REFERENCES ROLES(role_id),
    FOREIGN KEY (permission_code) REFERENCES PERMISSIONS(prm_codename)
);
GO

-- Insert into ROLE_PERMISSIONS
INSERT INTO ROLE_PERMISSIONS (role_id, permission_code) VALUES
(1, 'A001'), 
(1, 'A002'),
(1, 'A003'),
(1, 'H001'),
(1, 'H002'),
(1, 'H003'),
(1, 'H004'),
(1, 'F001'),
(1, 'F002'),
(1, 'F003'),
(1, 'F004'),
(2, 'H001'),
(2, 'H002'),
(2, 'H003'),
(2, 'H004'),
(2, 'F001'),
(2, 'F002'),
(2, 'F003'),
(2, 'F004'),
(3, 'F001'),
(3, 'F002'),
(3, 'F003'),
(3, 'F004');  



-- Create USER_ROLES table
CREATE TABLE USER_ROLES (
    user_id INT,
    role_id INT,
    assigned_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES auth_user(id),
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
('Chief Batch Counselor(CBC) - CSE', NULL, 'TLP', SYSDATETIME(), SYSDATETIME(), 1),
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

-- Create Documents Table
CREATE TABLE DOCUMENTS (
    id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    folder_id INT,   
    dynamic_data NVARCHAR(MAX),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (folder_id) REFERENCES FOLDERS(id)
);

CREATE INDEX idx_folder_latest ON DOCUMENTS (folder_id);

INSERT INTO DOCUMENTS (
    title,
    description,
    folder_id,
    dynamic_data
)
VALUES (
        'Academic Calender',
        'In this folder, we will manage Academic Calender of the CSE department.',
        1,
        N'{
      "Academic_Calendar":{
      "columns": [
        { "name": "Semester", "type": "INT", "constraints": "NOT NULL, CHECK (Semester BETWEEN 1 AND 8), PRIMARY KEY" },
        { "name": "Commencement_of_Classes", "type": "DATE" },
        { "name": "Assignment1_Release_Dates", "type": "DATE" },
        { "name": "Assignment1_Submission_Dates", "type": "DATE" },
        { "name": "Commencement_of_First_Mid_Term_I_Theory_Exams", "type": "DATE" },
        { "name": "Last_Date_of_Showing_Answer_Sheets_of_MT1_to_Students", "type": "DATE" },
        { "name": "Submission_of_Marks_of_MT1_to_Exam_Cell", "type": "DATE" },
        { "name": "Remedial_Classes_for_Weak_Students", "type": "VARCHAR(255)" },
        { "name": "Commencement_of_I_Internal_Practical_Exams", "type": "DATE" },
        { "name": "Release_of_Marks_of_I_Internal_Practical_Exams", "type": "DATE" },
        { "name": "Assignment2_Release_Dates", "type": "DATE" },
        { "name": "Assignment2_Submission_Dates", "type": "DATE" },
        { "name": "Commencement_of_Mid_Term_II_Theory_Exams", "type": "DATE" },
        { "name": "Last_Date_of_Showing_Answer_Sheets_of_MT2_to_Students", "type": "DATE" },
        { "name": "Submission_of_Marks_of_MT2_to_Exam_Cell", "type": "DATE" },
        { "name": "Commencement_of_II_Internal_Practical_Exams", "type": "DATE" },
        { "name": "Release_of_Marks_of_II_Internal_Practical_Exams", "type": "DATE" },
        { "name": "Last_Working_Day", "type": "DATE" },
        { "name": "Commencement_of_University_Practical_Exam", "type": "DATE" },
        { "name": "Commencement_of_End_Term_Theory_Exam", "type": "DATE" },
        { "name": "Project_Report_Hardware_Submission", "type": "DATE" },
        { "name": "DPAQIC_Meeting_for_Selection_of_Optional_Subjects_for_Next_Semester", "type": "DATE" },
        { "name": "Subjects_Allotment_to_Faculty_Members_for_Next_Semester", "type": "DATE" },
        { "name": "Commencement_of_Classes_for_Even_Semester", "type": "DATE" }
      ]
        }'
    ),
    (
       'Alumni Activity Records',
        'Alumni Records – it contain complete list of Alumni who have been registered on portal.',
        2,
        N'{"Alumni_Activities_Record":{
          "columns": [
            { "name": "S_No", "type": "INT", "constraints": "PRIMARY KEY" },
            { "name": "Date", "type": "DATE" },
            { "name": "Event_Name", "type": "VARCHAR(255)" },
            { "name": "Owner_of_Event", "type": "VARCHAR(100)" },
            { "name": "Alumni_Name", "type": "VARCHAR(100)" },
            { "name": "Branch", "type": "VARCHAR(50)" },
            { "name": "Pass_Out_Year", "type": "INT" },
            { "name": "Email_ID", "type": "VARCHAR(100)" },
            { "name": "Mobile_Number", "type": "VARCHAR(15)" },
            { "name": "Participant_List", "type": "TEXT" },
            { "name": "Poster", "type": "TEXT" },
            { "name": "Notice", "type": "TEXT" },
            { "name": "Summary_of_Event", "type": "TEXT" },
            { "name": "Photos_of_Event", "type": "TEXT" },
            { "name": "Feedback", "type": "TEXT" }
          ]
        }'
        ),
        (
        'Alumni Records',
        'Alumni Records – it contain complete list of Alumni who have been registered on portal',
        2,
         N'{
          "Alumni_Master_File": {
            "columns": [
              { "name": "Name", "type": "VARCHAR(100)" "constraints": "PRIMARY KEY" },
              { "name": "Department", "type": "VARCHAR(100)" },
              { "name": "Roll_Number", "type": "VARCHAR(50)" },
              { "name": "Registration_Number", "type": "VARCHAR(50)" },
              { "name": "Course", "type": "VARCHAR(100)" },
              { "name": "Batch_Year", "type": "INT" },
              { "name": "Email", "type": "VARCHAR(100)" },
              { "name": "Phone", "type": "VARCHAR(15)" },
              { "name": "Current_Address", "type": "TEXT" },
              { "name": "Permanent_Address", "type": "TEXT" },
              { "name": "City", "type": "VARCHAR(50)" },
              { "name": "State", "type": "VARCHAR(50)" },
              { "name": "Pincode", "type": "VARCHAR(10)" },
              { "name": "Country", "type": "VARCHAR(50)" },
              { "name": "Membership_Status", "type": "VARCHAR(50)" },
              { "name": "Membership_Number", "type": "VARCHAR(50)" },
              { "name": "Course_Completed", "type": "VARCHAR(100)" },
              { "name": "Institution", "type": "VARCHAR(100)" },
              { "name": "Current_Workplace", "type": "VARCHAR(100)" },
              { "name": "LinkedIn_Profile", "type": "VARCHAR(255)" },
              { "name": "Facebook_Profile", "type": "VARCHAR(255)" },
              { "name": "Instagram_Profile", "type": "VARCHAR(255)" },
              { "name": "Years_of_Experience", "type": "INT" },
              { "name": "Technical_Skills", "type": "TEXT" },
              { "name": "Worked_in_Abroad", "type": "VARCHAR(10)" },
              { "name": "Date_of_Birth", "type": "DATE" },
              { "name": "Gender", "type": "VARCHAR(10)" },
              { "name": "Alumni_Type", "type": "VARCHAR(50)" }
            ],
          }'
        ),
        (
        'SODECA Marks distribution',
        'In this File we will manage SODECA Marks for CSE students',
        6,
            N'{
              "SODECA_Marks_Distribution": {
                "columns": [
                  { "name": "S_No", "type": "INT" "constraints": "PRIMARY KEY"},
                  { "name": "Sem", "type": "INT" },
                  { "name": "Batch", "type": "VARCHAR(50)" },
                  { "name": "Batch_Counselor", "type": "VARCHAR(100)" },
                  { "name": "University_Roll_No", "type": "VARCHAR(50)" },
                  { "name": "Name_of_Student", "type": "VARCHAR(100)" },
                  { "name": "Discipline_Marks", "type": "INT" },
                  { "name": "Games_Sports_Field_Activity", "type": "INT" },
                  { "name": "Cultural_Literary_Activities", "type": "INT" },
                  { "name": "Academic_Technical_Professional_Development_Activities", "type": "INT" },
                  { "name": "Social_Outreach_Personal_Development_Activities", "type": "INT" },
                  { "name": "Anandan_Program_Activities", "type": "INT" },
                  { "name": "Total_Marks", "type": "INT" }
                ]
              },'
            ),
            (
            'Sports Achievements NAAC Format',
            'Number of awards/medals for outstanding performance in sports at university/state/national / international level (award for a team event should be counted as one) during the year.',
            3,
            N'{
                "NAAC_Sports_Format": {
            "columns": [
              { "name": "Year", "type": "INT" },
              { "name": "Award_Name", "type": "VARCHAR(255)" },
              { "name": "Team_Or_Individual", "type": "VARCHAR(50)" },
              { "name": "Level", "type": "VARCHAR(50)" },
              { "name": "Sports_Or_Cultural", "type": "VARCHAR(50)" },
              { "name": "Student_Name", "type": "VARCHAR(100)" },
              { "name": "Proof_Link", "type": "TEXT" }
            ],
            "constraints": {
              "primary_key": ["Year", "Award_Name", "Student_Name"]
            }
          }'),
         ('Sports Achievements QIV Format',
            'Number of awards/medals for outstanding performance in sports at university/state/national / international level (award for a team event should be counted as one) during the year.',
            3,
            N'{
            "QIV_Sports_Format": {
            "columns": [
              { "name": "Event_Title", "type": "VARCHAR(255)" },
              { "name": "Activity_Name", "type": "VARCHAR(255)" },
              { "name": "Type", "type": "VARCHAR(50)" },
              { "name": "Awarding_Organization", "type": "VARCHAR(255)" },
              { "name": "Level", "type": "VARCHAR(50)" },
              { "name": "Activity_Date_From", "type": "DATE" },
              { "name": "Activity_Date_To", "type": "DATE" },
              { "name": "Team_Members_Count", "type": "INT" },
              { "name": "Position", "type": "VARCHAR(50)" },
              { "name": "Proof_Enclosed", "type": "VARCHAR(10)" }
            ],
            "constraints": {
              "primary_key": ["Event_Title", "Activity_Name", "Activity_Date_From"]
            }
            }
          }'),
          ('Sports Achievements NBA Format',
            'Number of awards/medals for outstanding performance in sports at university/state/national / international level (award for a team event should be counted as one) during the year.',
            3,
            N'{
            "NBA_Sports_Format": {
            "columns": [
              { "name": "Year", "type": "INT" },
              { "name": "Award_Name", "type": "VARCHAR(255)" },
              { "name": "Team_Or_Individual", "type": "VARCHAR(50)" },
              { "name": "Level", "type": "VARCHAR(50)" },
              { "name": "Sports_Or_Cultural", "type": "VARCHAR(50)" },
              { "name": "Student_Name", "type": "VARCHAR(100)" }
            ],
            "constraints": {
              "primary_key": ["Year", "Award_Name", "Student_Name"]
            }
            }
            }'
           ),
            (
            'CO-PO-PSO Mapping and Attainment Practical_Midterm_Performance',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
            N'{
            "Practical_Midterm_Performance": {
            "columns": [
              { "name": "S_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "RTU_Roll_Number", "type": "VARCHAR(50)", "constraints": ["NOT NULL"] },
              { "name": "Student_Name", "type": "VARCHAR(100)" },
              { "name": "Q1", "type": "INT" },
              { "name": "Q2", "type": "INT" },
              { "name": "Total", "type": "INT" },
              { "name": "Viva", "type": "INT" },
              { "name": "Lab_Performance", "type": "INT" },
              { "name": "File_Work", "type": "INT" },
              { "name": "Attendance", "type": "INT" },
              { "name": "Mapped_CO_Q1", "type": "VARCHAR(10)" },
              { "name": "Mapped_CO_Q2", "type": "VARCHAR(10)" }
            ]
            }
          }'),
            (
            'CO-PO-PSO Mapping and Attainment Practical_CO_Attainment_Sectionwise',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
            N'{
            "Practical_CO_Attainment_Sectionwise": {
            "columns": [
              { "name": "S_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "Roll_No", "type": "VARCHAR(50)" },
              { "name": "Student_Name", "type": "VARCHAR(100)" },
              { "name": "I_Midterm_Exam", "type": "INT" },
              { "name": "I_Viva", "type": "INT" },
              { "name": "I_Lab_Performance", "type": "INT" },
              { "name": "I_File_Work", "type": "INT" },
              { "name": "I_Attendance", "type": "INT" },
              { "name": "Total_A", "type": "INT" },
              { "name": "II_Midterm_Exam", "type": "INT" },
              { "name": "II_Viva", "type": "INT" },
              { "name": "II_Lab_Performance", "type": "INT" },
              { "name": "II_File_Work", "type": "INT" },
              { "name": "II_Attendance", "type": "INT" },
              { "name": "Total_B", "type": "INT" },
              { "name": "Average_Internal_Marks", "type": "DECIMAL(5,2)" },
              { "name": "External_Lab_Performance", "type": "INT" },
              { "name": "External_Viva", "type": "INT" },
              { "name": "Total_External_Marks", "type": "INT" },
              { "name": "Total_Marks", "type": "INT" }
            ]
            }
          }'),
          (
            'CO-PO-PSO Mapping and Attainment Practical_CO_Attainment_Summary',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
            N'{
            "Practical_CO_Attainment_Summary": {
            "columns": [
              { "name": "Course_Code", "type": "VARCHAR(20)", "constraints": ["PRIMARY KEY"] },
              { "name": "Course_Name", "type": "VARCHAR(100)" },
              { "name": "Attainment_I_Midterm_Evaluation", "type": "DECIMAL(5,2)" },
              { "name": "Attainment_II_Midterm_Evaluation", "type": "DECIMAL(5,2)" },
              { "name": "Attainment_External_Lab_Performance", "type": "DECIMAL(5,2)" },
              { "name": "Attainment_External_Viva", "type": "DECIMAL(5,2)" },
              { "name": "Average_CO_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Consolidated_Attainment_Level", "type": "DECIMAL(5,2)" }
            ]
            }
          }'),
          (
            'CO-PO-PSO Mapping and Attainment Theory_Midterm_Attainment',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
            N'{
            "Theory_Midterm_Attainment": {
            "columns": [
              { "name": "S_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "Section", "type": "VARCHAR(20)" },
              { "name": "Roll_No", "type": "VARCHAR(50)" },
              { "name": "Part_A", "type": "INT" },
              { "name": "Part_B", "type": "INT" },
              { "name": "Part_C", "type": "INT" },
              { "name": "Total_20", "type": "INT" },
              { "name": "Assignment_10", "type": "INT" },
              { "name": "Total_30", "type": "INT" },
              { "name": "CO1", "type": "VARCHAR(10)" },
              { "name": "CO2", "type": "VARCHAR(10)" },
              { "name": "CO3", "type": "VARCHAR(10)" },
              { "name": "CO4", "type": "VARCHAR(10)" },
              { "name": "CO5", "type": "VARCHAR(10)" },
              { "name": "CO6", "type": "VARCHAR(10)" },
              { "name": "CO7", "type": "VARCHAR(10)" },
              { "name": "CO8", "type": "VARCHAR(10)" }
            ]
            }
          }'),
          (
            'CO-PO-PSO Mapping and Attainment Theory_CO_Attainment_Summary',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
          N'{
            "Theory_CO_Attainment_Summary": {
            "columns": [
              { "name": "Course_Code", "type": "VARCHAR(20)", "constraints": ["PRIMARY KEY"] },
              { "name": "Course_Name", "type": "VARCHAR(100)" },
              { "name": "CO1_Percentage", "type": "DECIMAL(5,2)" },
              { "name": "CO1_Level", "type": "VARCHAR(10)" },
              { "name": "CO2_Percentage", "type": "DECIMAL(5,2)" },
              { "name": "CO2_Level", "type": "VARCHAR(10)" },
              { "name": "CO3_Percentage", "type": "DECIMAL(5,2)" },
              { "name": "CO3_Level", "type": "VARCHAR(10)" },
              { "name": "CO4_Percentage", "type": "DECIMAL(5,2)" },
              { "name": "CO4_Level", "type": "VARCHAR(10)" },
              { "name": "CO5_Percentage", "type": "DECIMAL(5,2)" },
              { "name": "CO5_Level", "type": "VARCHAR(10)" }
            ]
          }
          }'
          ),
          (
            'CO-PO-PSO Mapping and Attainment Theory_CO_Attainment_Batchwise',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
          N'{
          "Theory_CO_Attainment_Batchwise": {
            "columns": [
              { "name": "S_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "Semester", "type": "INT" },
              { "name": "Subject_Code", "type": "VARCHAR(20)" },
              { "name": "Subject_Name", "type": "VARCHAR(100)" },
              { "name": "CO1", "type": "DECIMAL(5,2)" },
              { "name": "CO2", "type": "DECIMAL(5,2)" },
              { "name": "CO3", "type": "DECIMAL(5,2)" },
              { "name": "CO4", "type": "DECIMAL(5,2)" },
              { "name": "CO5", "type": "DECIMAL(5,2)" },
              { "name": "CO6", "type": "DECIMAL(5,2)" },
              { "name": "Internal_Exam_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Assignment_Unit_Test_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Internal_Assessment_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "External_Exam_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Overall_Attainment_Level", "type": "DECIMAL(5,2)" }
            ]
          }
          }'),
          (
            'CO-PO-PSO Mapping and Attainment Practical_CO_Attainment_Batchwise',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
          N'{
          "Practical_CO_Attainment_Batchwise": {
            "columns": [
              { "name": "Sr_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "Semester", "type": "INT" },
              { "name": "Subject_Code", "type": "VARCHAR(20)" },
              { "name": "Subject_Name", "type": "VARCHAR(100)" },
              { "name": "CO1", "type": "DECIMAL(5,2)" },
              { "name": "CO2", "type": "DECIMAL(5,2)" },
              { "name": "CO3", "type": "DECIMAL(5,2)" },
              { "name": "CO4", "type": "DECIMAL(5,2)" },
              { "name": "CO5", "type": "DECIMAL(5,2)" },
              { "name": "CO6", "type": "DECIMAL(5,2)" },
              { "name": "I_Midterm_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "II_Midterm_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Internal_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "External_Attainment", "type": "DECIMAL(5,2)" },
              { "name": "Consolidated_Attainment_Level", "type": "DECIMAL(5,2)" }
            ]
          }
          }'),
          (
            'CO-PO-PSO Mapping and Attainment PO_PSO_Attainment_Summary',
            'In this folder, we will manage Session wise / Batch-wise Course Mappings and Attainments of CO-PO and PSO',
            4,
          N'{
            "PO_PSO_Attainment_Summary": {
            "columns": [
              { "name": "S_No", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "Course_Code", "type": "VARCHAR(20)" },
              { "name": "Course_Name", "type": "VARCHAR(100)" },
              { "name": "Consolidated_CO", "type": "VARCHAR(20)" },
              { "name": "PO1", "type": "DECIMAL(5,2)" },
              { "name": "PO2", "type": "DECIMAL(5,2)" },
              { "name": "PO3", "type": "DECIMAL(5,2)" },
              { "name": "PO4", "type": "DECIMAL(5,2)" },
              { "name": "PO5", "type": "DECIMAL(5,2)" },
              { "name": "PO6", "type": "DECIMAL(5,2)" },
              { "name": "PO7", "type": "DECIMAL(5,2)" },
              { "name": "PO8", "type": "DECIMAL(5,2)" },
              { "name": "PO9", "type": "DECIMAL(5,2)" },
              { "name": "PO10", "type": "DECIMAL(5,2)" },
              { "name": "PO11", "type": "DECIMAL(5,2)" },
              { "name": "PO12", "type": "DECIMAL(5,2)" },
              { "name": "PSO1", "type": "DECIMAL(5,2)" },
              { "name": "PSO2", "type": "DECIMAL(5,2)" },
              { "name": "PSO3", "type": "DECIMAL(5,2)" }
            ]
          }
          }'
),
        ('Course File',
                'The course file will be reviewed on the basis of the availability of following documents (as listed in Table1) in the said sequence only.',
                5,
               N'{
            "Course_File": {
            "columns": [
              { "name": "Institute_Vision_Mission_Quality_Policy", "type": "TEXT" },
              { "name": "Department_Vision_Mission", "type": "TEXT" },
              { "name": "RTU_Scheme_Syllabus", "type": "TEXT" },
              { "name": "Prerequisite_of_Course", "type": "TEXT" },
              { "name": "List_of_Text_and_Reference_Books", "type": "TEXT" },
              { "name": "Time_Table", "type": "TEXT" },
              { "name": "Syllabus_Deployment_Course_Plan", "type": "TEXT" },
              { "name": "Coverage", "type": "TEXT" },
              { "name": "PO_PSO_Indicators_Competency", "type": "TEXT" },
              { "name": "COs_Competency_Level_1", "type": "TEXT" },
              { "name": "CO_PO_PSO_Mapping_Using_Performance_Indicators_PIs", "type": "TEXT" },
              { "name": "CO_PO_PSO_Mapping_Formula_Justification", "type": "TEXT" },
              { "name": "Attainment_Level_Internal_Assessment", "type": "TEXT" },
              { "name": "Learning_Level_Students_Through_Marks_1st_Test_Quiz", "type": "TEXT" },
              { "name": "Planning_Remedial_Classes_Below_Average_Students", "type": "TEXT" },
              { "name": "Teaching_Learning_Methodology", "type": "TEXT" },
              { "name": "RTU_Papers_Previous_Years", "type": "TEXT" },
              { "name": "Mid_Term_Papers_Blooms_Taxonomy_COs", "type": "TEXT" },
              { "name": "Tutorial_Sheets_WITH_EMD_Analysis", "type": "TEXT" },
              { "name": "Technical_Quiz_Papers", "type": "TEXT" },
              { "name": "Assignments_RTU_Format", "type": "TEXT" },
              { "name": "Efforts_to_Fill_Gap_Between_COs_and_POs", "type": "TEXT" },
              { "name": "Lecture_Notes", "type": "TEXT" }
            ]
          }
        }'),
        ('Handbook',
                'The faculty handbooks will be reviewed on the basis of the availability of following documents.',
                5,
               N'{
            "Handbook": {
            "columns": [
              { "name": "Institute_Vision_Mission_Quality_Policy", "type": "TEXT" },
              { "name": "Department_Vision_Mission", "type": "TEXT" },
              { "name": "PEO_PO_PSO", "type": "TEXT" },
              { "name": "Time_Table", "type": "TEXT" },
              { "name": "RTU_Syllabus", "type": "TEXT" },
              { "name": "Syllabus_Deployment_Course_Plan", "type": "TEXT" },
              { "name": "Course_Coverage", "type": "TEXT" },
              { "name": "Student_Details", "type": "TEXT" },
              { "name": "Attendance_Mark_Properly", "type": "TEXT" },
              { "name": "Listing_Total_Students_Present_Absent_Total", "type": "TEXT" },
              { "name": "List_of_Text_and_Reference_Books", "type": "TEXT" }
            ]
          }
        }'
        ),
        ('SODECA NAAC Format - 1',
                'Number of awards/medals for outstanding performance in sports/cultural activities at university/state/national / international level (award for a team event should be counted as one) during the year.',
                7,
               N'{
          "Naac_format_DECA_1": {
            "columns": [
              { "name": "Year_", "type": "YEAR" },
              { "name": "Name_of_the_award_or_medal", "type": "VARCHAR(30)" },
              { "name": "Team_or_Individual", "type": "ENUM", "values": ["Team", "Individual"] },
              { "name": "level", "type": "ENUM", "values": ["University", "State", "National", "International"] },
              { "name": "sports_or_cultural", "type": "ENUM", "values": ["sports", "cultural"] },
              { "name": "Student_name", "type": "VARCHAR(50)" },
              { "name": "Proof_link", "type": "VARCHAR(80)" }
            ]
          }
        }'
        ),
        ('SODECA NAAC Format - 2',
                'Average number of sports,technical and cultural activities/events in which students of the Institution participated during this year (organised by the institution/other institutions) (20)',
                7,
               N'{
          "NAAC_format_DECA_2": {
            "columns": [
              { "name": "Date_of_event", "type": "DATE" },
              { "name": "Name_of_event", "type": "VARCHAR(30)" },
              { "name": "Roll_no", "type": "VARCHAR(20)" },
              { "name": "Name_of_student_participated", "type": "VARCHAR(30)" },
              { "name": "Link_of_proof", "type": "VARCHAR(50)" }
            ]
          }
        }'
        ),
        ('SODECA QIV Format - 1',
                'Number of awards/medals for outstanding performance in sports/cultural activities at university/state/national / international level (award for a team event should be counted as one) during the year.',
                7,
               N'{
          "QIV_format_DECA_1": {
            "columns": [
              { "name": "Title_of_event", "type": "VARCHAR(50)" },
              { "name": "Name_of_activity", "type": "VARCHAR(50)" },
              { "name": "Type_", "type": "ENUM('Faculty', 'Student')" },
              { "name": "Awarding_Organization", "type": "VARCHAR(50)" },
              { "name": "level_", "type": "ENUM('International', 'National')" },
              { "name": "Date_to", "type": "DATE" },
              { "name": "Date_from", "type": "DATE" },
              { "name": "No_of_members_in_team", "type": "INT" },
              { "name": "Position", "type": "INT" },
              { "name": "Proof_enclosed", "type": "ENUM('Yes', 'No')" }
            ]
          }
        }'
        ),
        ('SODECA QIV Format - 2',
                'Average number of sports,technical and cultural activities/events in which students of the Institution participated during this year (organised by the institution/other institutions) (20)',
                7,
               N'{
          "QIV_format_DECA_2": {
            "columns": [
              { "name": "Title_of_event", "type": "VARCHAR(50)" },
              { "name": "Choose_", "type": "ENUM('Faculty', 'Student', 'Coordinator')" },
              { "name": "Name_of_faculty_or_Student_Coordinator", "type": "VARCHAR(30)" },
              { "name": "Awarding_Organization", "type": "VARCHAR(50)" },
              { "name": "level_", "type": "ENUM('International', 'National')" },
              { "name": "Type_", "type": "ENUM('Curricular', 'Co-curricular')" },
              { "name": "Date_to", "type": "DATE" },
              { "name": "Date_from", "type": "DATE" },
              { "name": "Position", "type": "INT" },
              { "name": "Department", "type": "VARCHAR(30)" },
              { "name": "Proof_enclosed", "type": "ENUM('Yes', 'No')" }
            ]
          }
        }'
        ),
        ('SODECA NBA Format',
                'Number of awards/medals for outstanding performance in sports/cultural activities at university/state/national / international level (award for a team event should be counted as one) during the year.',
                7,
               N'{
          "NBA_format_DECA": {
            "columns": [
              { "name": "Session_", "type": "VARCHAR(20)" },
              { "name": "Name_of_student_or_team_members", "type": "VARCHAR(80)" },
              { "name": "Name_of_award", "type": "VARCHAR(30)" },
              { "name": "Event_date_to", "type": "DATE" },
              { "name": "Event_date_from", "type": "DATE" },
              { "name": "Event_Name", "type": "VARCHAR(60)" },
              { "name": "Event_Venue", "type": "VARCHAR(90)" },
              { "name": "level_", "type": "ENUM('International', 'National', 'State', 'College_level')" },
              { "name": "Category", "type": "VARCHAR(60)" },
              { "name": "Proof_link", "type": "VARCHAR(90)" }
            ]
          }
        }'
        ),
        ('SODECA NIRF Format',
                'NULL',
                7,
               N'{
          "NIRF_format_DECA": {
            "columns": [
              { "name": "Dept", "type": "VARCHAR(20)" },
              { "name": "S_No", "type": "INT", "constraints": ["AUTO_INCREMENT", "PRIMARY KEY"] },
              { "name": "Enrollment_Number", "type": "INT" },
              { "name": "Name_of_the_award", "type": "VARCHAR(40)" },
              { "name": "Name_of_International_institution", "type": "VARCHAR(50)" },
              { "name": "Address_of_the_Agency_giving_award", "type": "VARCHAR(90)" },
              { "name": "Contact_Email_ID_of_the_institution", "type": "VARCHAR(60)" },
              { "name": "Year_of_receiving_award", "type": "YEAR" },
              { "name": "Email_ID_of_the_Student", "type": "VARCHAR(50)" },
              { "name": "Contact_no_of_the_Student", "type": "CHAR(10)" }
            ]
          }
        }'
        ),
        ('Events Organized ',
                'In this folder, we will manage data which is relevant to events like workshop, FDP, Conference, Seminar, etc Organized for Faculty and Students.',
                10,
               N'{
          "Naac_Format_event_organized": {
            "columns": [
              { "name": "sn", "type": "INT", "constraints": ["AUTO_INCREMENT", "PRIMARY KEY"] },
              { "name": "from_date", "type": "DATE" },
              { "name": "to_date", "type": "DATE" },
              { "name": "Title_of_the_professional_development_program_organised_for_teaching_staff", "type": "VARCHAR(255)" },
              { "name": "Title_of_the_administrative_training_program_organised_for_non_teaching_staff", "type": "VARCHAR(255)" },
              { "name": "Total_no._of_participants_Teaching_or_Non_teaching", "type": "INT" },
              { "name": "Link_to_the_report_of_the_Program", "type": "TEXT" },
              { "name": "Link_to_the_list_of_participant_with_Employee_code", "type": "TEXT" }
            ]
          }
        }'
        ),
        ('Events Organized ',
                'In this folder, we will manage data which is relevant to events like workshop, FDP, Conference, Seminar, etc Organized for Faculty and Students.',
                10,
               N'{
          "event_master_table": {
            "columns": [
              { "name": "sr_no", "type": "INT", "constraints": ["PRIMARY KEY"] },
              { "name": "start_date_of_event", "type": "DATE" },
              { "name": "end_date_of_event", "type": "DATE" },
              { "name": "dates_from_to", "type": "VARCHAR(100)" },
              { "name": "name_of_faculty_coordinator", "type": "VARCHAR(200)" },
              { "name": "title_of_the_professional_development_event_for_students", "type": "VARCHAR(200)" },
              { "name": "title_of_the_administrative_training_program_for_teaching_staff", "type": "VARCHAR(200)" },
              { "name": "Title_of_the_administrative_training_program_Title_of_the_administrative_training_program_for_non_teaching_staff", "type": "VARCHAR(200)" },
              { "name": "no_of_participants", "type": "INT" },
              { "name": "Academic_Departmentor_Cell_or_Committees", "type": "VARCHAR(150)" },
              { "name": "academic_session", "type": "VARCHAR(100)" },
              { "name": "collaboration_details", "type": "TEXT" },
              { "name": "grant_received_YES_NO", "type": "ENUM('YES', 'NO')" },
              { "name": "grant_details", "type": "TEXT" },
              { "name": "association_with_professional_societies_for_organization_of_event", "type": "TEXT" },
              { "name": "no_of_skit_students_participated", "type": "INT" },
              { "name": "no_of_staff_skit_members_participated", "type": "INT" },
              { "name": "event_report_attached_in_proper_format_YES_NO", "type": "ENUM('YES', 'NO')" },
              { "name": "link_to_the_activity_report", "type": "VARCHAR(300)" },
              { "name": "any_other_remarks", "type": "TEXT" },
              { "name": "date_format", "type": "VARCHAR(20)" },
              { "name": "program_for_students", "type": "BOOLEAN" },
              { "name": "program_for_teaching_staff", "type": "BOOLEAN" },
              { "name": "program_for_non_teaching_staff", "type": "BOOLEAN" },
              { "name": "labs_or_coe", "type": "VARCHAR(150)" },
              { "name": "organization_of_event_details", "type": "TEXT" },
              { "name": "student_list_attached", "type": "TEXT" },
              { "name": "staff_list_attached", "type": "TEXT" },
              { "name": "report_format_verified_YES_NO", "type": "ENUM('YES', 'NO')" },
              { "name": "report_on_website_link", "type": "VARCHAR(300)" }
            ]
          }
        }'
        ),
        ('Result Analysis',
                'In this folder, we will manage the result analysis of CSE, AI,DS and IoT',
                11,
               N'{
          "nirf_result_analysis": {
            "columns": [
              { "name": "academic_year", "type": "VARCHAR(9)" },
              { "name": "No._of_first_year_students_intake_in_the_year", "type": "INT" },
              { "name": "No._of_first_year_students_admitted_in_the_year", "type": "INT" },
              { "name": "Academic_Year", "type": "INT" },
              { "name": "No._of_students_admitted_through_lateral_entry", "type": "INT" },
              { "name": "No._of_student_graduating_in_minimum_stipulated_time", "type": "INT" },
              { "name": "No._of_students_places", "type": "INT" },
              { "name": "Median_salary_of_placed_graduates_per_annum_Amount_in_Rs", "type": "DECIMAL(10, 2)" },
              { "name": "Median_salary_of_placed_graduates_per_annum_Amount_in_Words", "type": "VARCHAR(255)" },
              { "name": "No._of_students_selected_for_Higher_Studies", "type": "INT" }
            ]
          }
        }'
        ),
        ('Result Analysis',
                'In this folder, we will manage the result analysis of CSE, AI,DS and IoT',
                11,
               N'{
          "qiv_result_analysis": {
            "columns": [
              { "name": "sn", "type": "INT", "attributes": ["AUTO_INCREMENT", "PRIMARY KEY"] },
              { "name": "University_Roll_no", "type": "VARCHAR(50)" },
              { "name": "Student_name", "type": "VARCHAR(255)" },
              { "name": "Branch", "type": "VARCHAR(100)" },
              { "name": "Percentage", "type": "DECIMAL(5,2)" },
              { "name": "Result", "type": "VARCHAR(50)" }
            ]
          }
        }'
        ),
        ('Result Analysis',
                'In this folder, we will manage the result analysis of CSE, AI,DS and IoT',
                11,
               N'{
          "qiv_result_analysis": {
            "columns": [
              { "name": "sn", "type": "INT", "attributes": ["AUTO_INCREMENT", "PRIMARY KEY"] },
              { "name": "University_Roll_no", "type": "VARCHAR(50)" },
              { "name": "Student_name", "type": "VARCHAR(255)" },
              { "name": "Branch", "type": "VARCHAR(100)" },
              { "name": "Percentage", "type": "DECIMAL(5,2)" },
              { "name": "Result", "type": "VARCHAR(50)" }
            ]
          }
        }'
        ),
        ('External Examination Coordinator',
                'In this folder, we will manage External Examination Records data',
                12,
               N'{
          "external_examination_records_master": {
            "columns": [
              { "name": "sr_no", "type": "INT", "attributes": ["PRIMARY KEY"] },
              { "name": "Date_of_Exam", "type": "DATE" },
              { "name": "Name_of_Lab", "type": "VARCHAR(100)" },
              { "name": "External_Examiner_no", "type": "VARCHAR(50)" },
              { "name": "Name_of_External_Examiner", "type": "VARCHAR(100)" },
              { "name": "Name_of_Internal_Examiner", "type": "VARCHAR(100)" },
              { "name": "No_of_Students_to_be_Examined", "type": "INT" }
            ]
          }
        }'
        ),
        ('External Examination Coordinator',
                'In this folder, we will manage External Examination Records data',
                12,
               N'{
          "external_examination_records_master": {
            "columns": [
              { "name": "Sr_No.", "type": "INT", "attributes": ["PRIMARY KEY"] },
              { "name": "Date_of_Exam", "type": "DATE" },
              { "name": "Name_of_Lab", "type": "VARCHAR(100)" },
              { "name": "External_Examiner_no", "type": "VARCHAR(50)" },
              { "name": "Name_of_External_Examiner", "type": "VARCHAR(100)" },
              { "name": "Name_of_Internal_Examiner", "type": "VARCHAR(100)" },
              { "name": "No_of_Students_to_be_Examined", "type": "INT" }
            ]
          }
        }'
);