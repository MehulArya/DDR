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
            'Sports Achievements',
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
          },
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
          },
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
            }'
            ),
            (
            'CO-PO-PSO Mapping and Attainment',
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
          },
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
          },
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
          },
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
          },
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
          },
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
          },
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
          },
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
          }'
);