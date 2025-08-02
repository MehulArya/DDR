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
),

  (
    'Virtual_Lab_Monthly_Usage',
    NULL,
    35,
    N'{
        "Virtual_Lab_Monthly_Usage": {
            "columns": [
                { "name": "Usage_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "Month", "type": "VARCHAR(20)" },
                { "name": "Workshop_Date", "type": "DATE" },
                { "name": "Branch", "type": "VARCHAR(50)" },
                { "name": "Year_Batch", "type": "VARCHAR(20)" },
                { "name": "No_of_Participants", "type": "INT" },
                { "name": "No_of_Labs_Performed", "type": "INT" },
                { "name": "No_of_Experiments_Performed", "type": "INT" },
                { "name": "Usage_Remark", "type": "VARCHAR(200)" }
            ]
        }
    }'
),
(
    'Master_Time_Table',
    'In this folder, I will manage data for Time table  of Classes, faculties, labs and Lecture rooms.',
    34,
    N'{
        "Master_Time_Table": {
            "columns": [
                { "name": "SN", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "Session", "type": "VARCHAR(20)" },
                { "name": "Class", "type": "VARCHAR(50)" },
                { "name": "Faculty", "type": "VARCHAR(100)" },
                { "name": "Subject_Name", "type": "VARCHAR(100)" },
                { "name": "Subject_Code", "type": "VARCHAR(20)" },
                { "name": "Subject_Type", "type": "VARCHAR(50)" },
                { "name": "Batch", "type": "VARCHAR(50)" }
            ]
        }
    }'
),
(
    'master_file_Research_centre_Records',
    'In this folder, we will manage Research Centre Records data',
     29,
    N'{
        "master_file_Research_centre_Records": {
            "columns": [
                { "name": "S_NO", "type": "INT", "constraints": "PRIMARY KEY NOT NULL" },
                { "name": "TEACHER_NAME", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "QUALIFICATION_AND_YEAR", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "RECOGNIZED_AS_RESEARCH_GUIDE", "type": "VARCHAR(10)", "constraints": "NOT NULL" },
                { "name": "YEAR_OF_RECOGNITION", "type": "INT", "constraints": "NOT NULL" },
                { "name": "IS_STILL_SERVING", "type": "VARCHAR(10)", "constraints": "NOT NULL" },
                { "name": "LAST_YEAR_OF_SERVICE", "type": "INT" },
                { "name": "SCHOLAR_NAME", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "SCHOLAR_REGISTRATION_YEAR", "type": "INT", "constraints": "NOT NULL" },
                { "name": "RTU_ENROLL_NO", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "THESIS_TITLE", "type": "TEXT", "constraints": "NOT NULL" },
                { "name": "YEAR_OF_COMPLETION", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Remedial_List_of_Students',
    'In this folder we are going to maintain the information such as attendance,time table ,list of student,Notice of remedial class .',
    28,
    N'{
        "Remedial_List_of_Students": {
            "columns": [
                { "name": "SL_NO", "type": "INT", "constraints": "NOT NULL" },
                { "name": "ROLL_NO", "type": "VARCHAR(20)", "constraints": "PRIMARY KEY NOT NULL" },
                { "name": "UNIVERSITY_REGISTER_NO", "type": "VARCHAR(30)", "constraints": "NOT NULL" },
                { "name": "NAME_OF_THE_STUDENT", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "CLASS", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "SUBJECT", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "ACADEMIC_YEAR", "type": "VARCHAR(10)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'NAAC_Research_Projects',
    'In this folder, detailed information related to accepted research projects as well as 
    consultancy projects of the faculty members of Computer Science and Engineering Department will be shared.',
    32,
    N'{
        "NAAC_Research_Projects": {
            "columns": [
                { "name": "PROJECT_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "PROJECT_NAME", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "PRINCIPAL_INVESTIGATOR", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "DEPARTMENT", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "YEAR_OF_AWARD", "type": "INT", "constraints": "NOT NULL" },
                { "name": "AMOUNT_SANCTIONED", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "PROJECT_DURATION", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "FUNDING_AGENCY", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "FUNDING_TYPE", "type": "VARCHAR(20)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Master_table_of_Expert_Lectures',
    'In this folder, detailed information related to the expert or guest lecturers held under any activity will be shared. The folder will have all the related
    documents such as approval, brochure, attendance, PPTs of expert, etc.',
    32,
    N'{
        "Master_table_of_Expert_Lectures": {
            "columns": [
                { "name": "EVENT_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "EVENT_TITLE", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "EVENT_LEVEL", "type": "VARCHAR(20)", "constraints": "NOT NULL" },
                { "name": "SESSION_TITLE", "type": "VARCHAR(255)" },
                { "name": "LECTURE_TITLE", "type": "VARCHAR(255)" },
                { "name": "EXPERT_NAME", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "EXPERT_AFFILIATION", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "EVENT_DATE", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "VENUE", "type": "VARCHAR(200)", "constraints": "NOT NULL" },
                { "name": "DURATION_DAYS", "type": "INT", "constraints": "NOT NULL" },
                { "name": "FUNDING_AGENCY", "type": "VARCHAR(150)" },
                { "name": "FUNDING_TYPE", "type": "VARCHAR(20)" },
                { "name": "AMOUNT_INR", "type": "DECIMAL(15,2)" }
            ]
        }
    }'
),
(
    'Master_Table_Research_Projects',
    'In this folder, detailed information related to accepted research projects as well
    as consultancy projects of the faculty members of
    Computer Science and Engineering Department will be shared.',
    32,
    N'{
        "Master_Table_Research_Projects": {
            "columns": [
                { "name": "Project_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "Faculty_Name", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Project_Title", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "Role", "type": "VARCHAR(10)", "constraints": "NOT NULL" },
                { "name": "External_PI_Details", "type": "VARCHAR(255)" },
                { "name": "Collaborating_Institutions", "type": "TEXT" },
                { "name": "Funding_Agency", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "Funding_Agency_Type", "type": "VARCHAR(20)", "constraints": "NOT NULL" },
                { "name": "Project_Category", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "Project_Duration_Months", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Start_Date", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "End_Date", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "Amount_INR", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "Status", "type": "VARCHAR(20)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'NAAC_Expert_Lectures',
    'In this folder, detailed information related to the expert or guest lecturers held under any activity will be shared. The folder will have all the related
    documents such as approval, brochure, attendance, PPTs of expert, etc.',
    32,
    N'{
        "NAAC_Expert_Lectures": {
            "columns": [
                { "name": "PROJECT_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "PROJECT_NAME", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "PRINCIPAL_INVESTIGATOR", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "DEPARTMENT", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "YEAR_OF_AWARD", "type": "INT", "constraints": "NOT NULL" },
                { "name": "AMOUNT_SANCTIONED", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "PROJECT_DURATION", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "FUNDING_AGENCY", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "FUNDING_TYPE", "type": "VARCHAR(20)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'NAAC_External_Project_Proposal',
    'In this folder, detailed information related to accepted research projects as well as consultancy projects of the students 
    of Computer Science and Engineering Department will be shared.',
     33,
    N'{
        "NAAC_External_Project_Proposal": {
            "columns": [
                { "name": "PROJECT_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "PROJECT_NAME", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "PRINCIPAL_INVESTIGATOR", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "DEPARTMENT", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "YEAR_OF_AWARD", "type": "INT", "constraints": "NOT NULL" },
                { "name": "AMOUNT_SANCTIONED", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "PROJECT_DURATION", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "FUNDING_AGENCY", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "FUNDING_TYPE", "type": "VARCHAR(20)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Master_table_of_External_project_proposal',
    'In this folder, detailed information related to accepted research projects as well as consultancy projects of the students 
    of Computer Science and Engineering Department will be shared.',
    33,
    N'{
        "Master_table_of_External_project_proposal": {
            "columns": [
                { "name": "DETAIL_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "PROJECT_ID", "type": "INT", "constraints": "NOT NULL, FOREIGN KEY REFERENCES NAAC_External_Project_Proposal(PROJECT_ID)" },
                { "name": "PROJECT_NAME", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "NAME_OF_SUMIT", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "ROLE", "type": "VARCHAR(10)", "constraints": "NOT NULL" },
                { "name": "EXTERNAL_PI_NAME_AFFILIATION", "type": "VARCHAR(255)" },
                { "name": "COLLABORATING_INSTITUTIONS", "type": "TEXT" },
                { "name": "FUNDING_AGENCY", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "FUNDING_TYPE", "type": "VARCHAR(20)", "constraints": "NOT NULL" },
                { "name": "CATEGORY", "type": "VARCHAR(50)", "constraints": "NOT NULL" },
                { "name": "DURATION_MONTHS", "type": "INT", "constraints": "NOT NULL" },
                { "name": "START_DATE", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "END_DATE", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "AMOUNT_INR", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "STATUS", "type": "VARCHAR(20)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'NAAC_Student_Internship',
    'In this folder, we will manage final year student project list, Mentor approval letters, various sample like Abstract, form-1, form-2, form-3, 
    ,SRS, PPT, Project Report, Demo Video etc.',
    33,
    N'{
        "NAAC_Student_Internship": {
            "columns": [
                { "name": "INTERNSHIP_ID", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "PROGRAM_NAME", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "PROGRAM_CODE", "type": "VARCHAR(50)" },
                { "name": "ROLL_NUMBER", "type": "VARCHAR(50)", "constraints": "NOT NULL UNIQUE" },
                { "name": "STUDENT_NAME", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "FIRM_NAME_ADDRESS", "type": "TEXT", "constraints": "NOT NULL" },
                { "name": "START_DATE", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "END_DATE", "type": "DATE", "constraints": "NOT NULL" },
                { "name": "GOOGLE_DRIVE_LINK", "type": "TEXT" }
            ]
        }
    }'
),
(
    'Master_Table_of_Student_Internship',
    'In this folder, we will manage final year student project list, Mentor approval letters, various sample like Abstract, form-1, form-2, form-3, 
    ,SRS, PPT, Project Report, Demo Video etc.',
    33,
    N'{
        "Master_Table_of_Student_Internship": {
            "columns": [
                { "name": "SNO", "type": "INT", "constraints": "PRIMARY KEY IDENTITY(1,1)" },
                { "name": "ROLL_NUMBER", "type": "VARCHAR(50)", "constraints": "NOT NULL, FOREIGN KEY REFERENCES NAAC_Student_Internship(ROLL_NUMBER)" },
                { "name": "STUDENT_NAME", "type": "VARCHAR(100)" },
                { "name": "PROJECT_TITLE", "type": "VARCHAR(200)" },
                { "name": "PROJECT_MENTOR", "type": "VARCHAR(100)" }
            ]
        }
    }'
),
(
    'UG_Higher_Studies',
    'NULL',
    23,
    N'{
        "UG_Higher_Studies": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Dept", "type": "VARCHAR(200)", "constraints": "NOT NULL" },
                { "name": "Session", "type": "VARCHAR(200)", "constraints": "NOT NULL" },
                { "name": "No_of_Students", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
 ),
 (
    'PG_Higher_Studies',
    'NULL',
    23,
    N'{
        "PG_Higher_Studies": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Dept", "type": "VARCHAR(200)", "constraints": "NOT NULL" },
                { "name": "Session", "type": "VARCHAR(200)", "constraints": "NOT NULL" },
                { "name": "No_of_Students", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Patents',
    'NULL',
    23,
    N'{
        "Patents": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Deptartment", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "Calendar_Year", "type": "YEAR", "constraints": "NOT NULL" },
                { "name": "Number_of_Published", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Number_of_Granted", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Sponsored_Research_Detail',
    'NULL',
    23,
    N'{
        "Sponsored_Research_Detail": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Dept", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "Financial_Year", "type": "VARCHAR(9)", "constraints": "NOT NULL" },
                { "name": "Number_of_Projects", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Number_of_Funding_Agencies", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Amount_Received_Rs", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "Amount_in_Words", "type": "VARCHAR(255)", "constraints": "NOT NULL" }
            ]
        }
    }'
),(
    'Consultancy_Projects_Details',
    'NULL',
    23,
    N'{
        "Consultancy_Projects_Details": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Dept", "type": "VARCHAR(100)", "constraints": "NOT NULL" },
                { "name": "Financial_Year", "type": "VARCHAR(9)", "constraints": "NOT NULL" },
                { "name": "Number_of_Projects", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Number_of_Client_Originations", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Amount_Received_Rs", "type": "DECIMAL(15,2)", "constraints": "NOT NULL" },
                { "name": "Amount_in_Words", "type": "VARCHAR(255)", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'ERP_Total_Student_Strength',
    'NULL',
    23,
    N'{
        "ERP_Total_Student_Strength": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Program", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "Male_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Female_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Total_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Within_State", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Outside_State", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Outside_Country", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Economically_Backward", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Socially_Challenged", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'ERP_PhD_Student_Strength_Doctoral_Program',
    'NULL',
    23,
    N'{
        "ERP_PhD_Student_Strength_Doctoral_Program": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Program_Year", "type": "VARCHAR(20)", "constraints": "NOT NULL" },
                { "name": "Full_Time_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Part_Time_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Total_Students", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'PhD_Student_Strength',
    'NULL',
    23,
    N'{
        "PhD_Student_Strength": {
            "columns": [
                { "name": "ID", "type": "INT", "constraints": "AUTO_INCREMENT PRIMARY KEY" },
                { "name": "Program_Year", "type": "VARCHAR(20)", "constraints": "NOT NULL" },
                { "name": "Full_Time_Students", "type": "INT", "constraints": "NOT NULL" },
                { "name": "Part_Time_Students", "type": "INT", "constraints": "NOT NULL" }
            ]
        }
    }'
),
(
    'Placement_UG_4_Year_Program',
    'NULL',
    23,
    N'{
        "Placement_UG_4_Year_Program": {
            "columns": [
                { "name": "Academic_Year_Intake", "type": "VARCHAR(9)", "constraints": "" },
                { "name": "First_Year_Intake", "type": "INT", "constraints": "" },
                { "name": "First_Year_Admitted", "type": "INT", "constraints": "" },

                { "name": "Academic_Year_Lateral_Entry", "type": "VARCHAR(9)", "constraints": "" },
                { "name": "Lateral_Entry_Admitted", "type": "INT", "constraints": "" },

                { "name": "Academic_Year_Graduated", "type": "VARCHAR(9)", "constraints": "" },
                { "name": "Graduated_In_Time", "type": "INT", "constraints": "" },

                { "name": "Students_Placed", "type": "INT", "constraints": "" },
                { "name": "Median_Salary_Rs", "type": "DECIMAL(12,2)", "constraints": "" },
                { "name": "Median_Salary_Words", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Higher_Studies_Count", "type": "INT", "constraints": "" }
            ]
        }
    }'
),
(
    'PG_2_Year_Program',
    'NULL',
    23,
    N'{
        "PG_2_Year_Program": {
            "columns": [
                { "name": "Academic_Year", "type": "VARCHAR(9)", "constraints": "" },
                { "name": "First_Year_Intake", "type": "INT", "constraints": "" },
                { "name": "First_Year_Admitted", "type": "INT", "constraints": "" },

                { "name": "Academic_Year_Graduated", "type": "VARCHAR(9)", "constraints": "" },
                { "name": "Graduated_In_Time", "type": "INT", "constraints": "" },

                { "name": "Students_Placed", "type": "INT", "constraints": "" },
                { "name": "Median_Salary_Rs", "type": "DECIMAL(12,2)", "constraints": "" },
                { "name": "Median_Salary_Words", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Higher_Studies_Count", "type": "INT", "constraints": "" }
            ]
        }
    }'
);
(
    'Oracle_nimish',
    'In this folder, we will manage Memorandum of understanding (MoU) with Oracle.',
    24,
    N'{
        "Oracle_nimish": {
            "columns": [
                { "name": "Organisation_MoU_Signed_With", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Institution_Or_Industry_Name", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "MoU_Signing_Year", "type": "DATE", "constraints": "" },
                { "name": "MoU_Duration", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "MoU_Activities_Yearwise", "type": "TEXT", "constraints": "" },
                { "name": "Participants_Count", "type": "INT", "constraints": "" }
            ]
        }
    }'
),
(
    'Average_Placement_of_Student',
    'In this folder, we will manage : Average Placement of Students',
    25,
    N'{
        "Average_Placement_of_Student": {
            "columns": [
                { "name": "Year", "type": "VARCHAR(10)", "constraints": "PRIMARY KEY (Year, Category)" },
                { "name": "Category", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Count", "type": "INT", "constraints": "" }
            ]
        }
    }'
),
(
    'Placement_Data',
    'In this folder, we will manage : Placement Data',
    25,
    N'{
        "Placement_Data": {
            "columns": [
                { "name": "S_No", "type": "INT", "constraints": "PRIMARY KEY" },
                { "name": "Roll_No", "type": "VARCHAR(20)", "constraints": "" },
                { "name": "Student_Name", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Email", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Contact_No", "type": "VARCHAR(20)", "constraints": "" },
                { "name": "Company_Name", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Selection", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Package_LPA", "type": "DECIMAL(5,2)", "constraints": "" },
                { "name": "Date", "type": "DATE", "constraints": "" },
                { "name": "Venue", "type": "VARCHAR(100)", "constraints": "" }
            ]
        }
    }'
),
(
    'NAAC_Journal_Publication',
    'In this folder, we will manage faculties and students conference, journal, book, book chapter, patent, publications.',
    26,
    N'{
        "NAAC_Journal_Publication": {
            "columns": [
                { "name": "Title of paper", "type": "VARCHAR(500)", "constraints": "NOT NULL" },
                { "name": "Name of the author/s", "type": "VARCHAR(300)", "constraints": "NOT NULL" },
                { "name": "Department of the teacher", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Name of journal", "type": "VARCHAR(255)", "constraints": "NOT NULL" },
                { "name": "Year of publication", "type": "INT", "constraints": "NOT NULL" },
                { "name": "ISSN number", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Link to the recognition in UGC enlistment of the Journal /Digital Object Identifier (doi) number", "type": "TEXT", "constraints": "" },
                { "name": "Link to website of the Journal", "type": "TEXT", "constraints": "" },
                { "name": "Link to article/paper/abstract of the article", "type": "TEXT", "constraints": "" },
                { "name": "Is it listed in UGC Care list/Scopus/Web of Science/other, mention", "type": "VARCHAR(100)", "constraints": "" }
            ]
        }
    }'
),
(
    'Qiv_Journal_Publication',
    'In this folder, we will manage faculties and students conference, journal, book, book chapter, patent, publications.',
    26,
    N'{
        "QIV_Journal_Publication": {
            "columns": [
                { "name": "S.No.", "type": "INT", "constraints": "PRIMARY KEY" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Contributing faculty members from concerned department", "type": "VARCHAR(300)", "constraints": "NOT NULL" },
                { "name": "Title of the Paper", "type": "VARCHAR(500)", "constraints": "NOT NULL" },
                { "name": "International/National Level", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Publishers Name", "type": "VARCHAR(200)", "constraints": "" },
                { "name": "Journals Name", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Indexing (SCI/ SCIE/ Scopus)", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "ISSN No.", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "ISBN No.", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Volume", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Issue", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Year", "type": "INT", "constraints": "" },
                { "name": "Article Id/ Page No.", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Date of Publication", "type": "DATE", "constraints": "" },
                { "name": "Is co-authored by faculty members from different departments of parent Institute (Yes/ No)", "type": "VARCHAR(10)", "constraints": "" },
                { "name": "Proof Enclosed (Yes/ No)", "type": "VARCHAR(10)", "constraints": "" }
            ]
        }
    }'
),
(
    'NBA_Journal_Publication',
    'In this folder, we will manage faculties and students conference, journal, book, book chapter, patent, publications.',
    26,
    N'{
        "NBA_Journal_Publication": {
            "columns": [
                { "name": "Title of paper", "type": "VARCHAR(500)", "constraints": "NOT NULL" },
                { "name": "Name of the author/s", "type": "VARCHAR(300)", "constraints": "NOT NULL" },
                { "name": "Department of the teacher", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Name of journal", "type": "VARCHAR(300)", "constraints": "NOT NULL" },
                { "name": "Year of publication", "type": "INT", "constraints": "NOT NULL" },
                { "name": "ISSN number", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Link to the recognition in UGC enlistment of the Journal /Digital Object Identifier (doi) number", "type": "VARCHAR(500)", "constraints": "" },
                { "name": "Link to website of the Journal", "type": "VARCHAR(500)", "constraints": "" },
                { "name": "Link to article/paper/abstract of the article", "type": "VARCHAR(500)", "constraints": "" },
                { "name": "Is it listed in UGC Care list/Scopus/Web of Science/other, mention", "type": "VARCHAR(150)", "constraints": "" }
            ]
        }
    }'
),
(
    'Master_Journal_Publications',
    'In this folder, we will manage faculties and students conference, journal, book, book chapter, patent, publications.',
    26,
    N'{
        "Master_Journal_Publications": {
            "columns": [
                { "name": "Name of Faculty", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "NOT NULL" },
                { "name": "Title of Paper", "type": "VARCHAR(500)", "constraints": "NOT NULL" },
                { "name": "Role(Author/Editor/Other)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "List of Authors /Editors(as per the paper sequence)", "type": "TEXT", "constraints": "" },
                { "name": "Name of journal", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Publishers Name", "type": "VARCHAR(200)", "constraints": "" },
                { "name": "Volume, Issue", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Article Id/ Page No.", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Date of Publication", "type": "DATE", "constraints": "" },
                { "name": "ISSN Number", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "ISBN Number", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "DOI", "type": "VARCHAR(200)", "constraints": "" },
                { "name": "Status", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Indexing (SCI/ SCIE/ Scopus)", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Link to website of the Journal", "type": "VARCHAR(500)", "constraints": "" },
                { "name": "Link to article/paper/abstract of the article", "type": "VARCHAR(500)", "constraints": "" },
                { "name": "Attach the Paper", "type": "VARCHAR(500)", "constraints": "" }
            ]
        }
    }'
),
(
    'NAAC_Faculty_Participation',
    'In this folder, we will manage faculties participation Professional Development programs
    like FDPs/ Workshops/Seminars/STTPs/Orientation/Induction/Refresher course/training program and conferences.',
    26,
    N'{
        "NAAC_Faculty_Participation": {
            "columns": [
                { "name": "S.No.", "type": "INT", "constraints": "PRIMARY KEY" },
                { "name": "Emp ID", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Name of faculty member", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Title of Program", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Conference/FDPs/Workshop/Semnar/STTP", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Mode(Online/Offline)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Level(National/International)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Organizer", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Sponsored by", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Duration", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Session", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "No.of Days", "type": "INT", "constraints": "" },
                { "name": "Proof Enclosed", "type": "VARCHAR(10)", "constraints": "" }
            ]
        }
    }'
),
(
    'QIV_Faculty_Participation',
    'In this folder, we will manage faculties participation Professional Development programs
    like FDPs/ Workshops/Seminars/STTPs/Orientation/Induction/Refresher course/training program and conferences.',
    26,
    N'{
        "QIV_Faculty_Participation": {
            "columns": [
                { "name": "S.No.", "type": "INT", "constraints": "PRIMARY KEY" },
                { "name": "Name of the Faculty", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Title of Event/Program", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Type Conference/Workshop/Seminar/STTP", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "International/National Level", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Organizer", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Duration From| To", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Proof Enclosed (Yes/ No)", "type": "VARCHAR(10)", "constraints": "" }
            ]
        }
    }'
),
(
    'NBA_Faculty_Participation',
    'In this folder, we will manage faculties participation Professional Development programs
    like FDPs/ Workshops/Seminars/STTPs/Orientation/Induction/Refresher course/training program and conferences.',
    26,
    N'{
        "NBA_Faculty_Participation": {
            "columns": [
                { "name": "S.No.", "type": "INT", "constraints": "" },
                { "name": "Emp ID", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Name of faculty member", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Title of Program", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Conference/FDPs/Workshop/Semnar/STTP", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Mode(Online/Offline)", "type": "VARCHAR(20)", "constraints": "" },
                { "name": "Level(National/International)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Organizer", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Grant Received from SKIT (YES/NO)", "type": "VARCHAR(5)", "constraints": "" },
                { "name": "Duration", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Session", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "No.of Days", "type": "INT", "constraints": "" },
                { "name": "Proof Enclosed", "type": "VARCHAR(10)", "constraints": "" }
            ]
        }
    }'
),
(
    'Master_Faculty_Participation',
    'In this folder, we will manage faculties participation Professional Development programs
    like FDPs/ Workshops/Seminars/STTPs/Orientation/Induction/Refresher course/training program and conferences.',
    26,
    N'{
        "Master_Faculty_Participation": {
            "columns": [
                { "name": "S.No.", "type": "INT", "constraints": "" },
                { "name": "Emp ID", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Department", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Name of faculty member", "type": "VARCHAR(150)", "constraints": "" },
                { "name": "Title of Program", "type": "VARCHAR(300)", "constraints": "" },
                { "name": "Conference/FDPs/Workshop/Semnar/STTP", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Mode(Online/Offline)", "type": "VARCHAR(20)", "constraints": "" },
                { "name": "Level(National/International)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Organizer", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Sponsored by", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Grant Received from SKIT (Y/N)", "type": "VARCHAR(3)", "constraints": "" },
                { "name": "Duration", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Session", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "No.of Days", "type": "INT", "constraints": "" },
                { "name": "Proof Enclosed(Y/N)", "type": "VARCHAR(3)", "constraints": "" }
            ]
        }
    }'
),
(
    'NAAC_INDUSTRIAL_TRAINING',
    'In this folder, detailed information related to summer internship of V semester students is shared.',
    16,
    N'{
        "NAAC_INDUSTRIAL_TRAINING": {
            "columns": [
                { "name": "ProgrammeName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "ProgramCode", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "RollNo", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "StudentName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "FirmNameAddress", "type": "TEXT", "constraints": "" },
                { "name": "DurationFrom", "type": "DATE", "constraints": "" },
                { "name": "DurationTo", "type": "DATE", "constraints": "" },
                { "name": "ProofLink", "type": "TEXT", "constraints": "" }
            ]
        }
    }'
),
(
    'QIV_INDUSTRIAL_TRAINING',
    'In this folder, detailed information related to summer internship of V semester students is shared.',
    16,
    N'{
        "QIV_INDUSTRIAL_TRAINING": {
            "columns": [
                { "name": "SNo", "type": "INT", "constraints": "PRIMARY KEY AUTO_INCREMENT" },
                { "name": "EmailAddress", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "RollNo", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "TrainingTitle", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "StipendAmount", "type": "DECIMAL(10, 2)", "constraints": "" },
                { "name": "StudentName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "CompanyName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "DateFrom", "type": "DATE", "constraints": "" },
                { "name": "DateTo", "type": "DATE", "constraints": "" },
                { "name": "CertificateLink", "type": "TEXT", "constraints": "" },
                { "name": "EvaluationFormLink", "type": "TEXT", "constraints": "" },
                { "name": "InformationVerified", "type": "BOOLEAN", "constraints": "" },
                { "name": "StipendProofLink", "type": "TEXT", "constraints": "" }
            ]
        }
    }'
),
(
    'NBA_INDUSTRIAL_TRAINING',
    '',
    16,
    N'{
        "NBA_INDUSTRIAL_TRAINING": {
            "columns": [
                { "name": "SNo", "type": "INT", "constraints": "PRIMARY KEY AUTO_INCREMENT" },
                { "name": "EmailAddress", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "RollNo", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "TrainingTitle", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "StipendAmount", "type": "DECIMAL(10, 2)", "constraints": "" },
                { "name": "StudentName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "CompanyName", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "DateFrom", "type": "DATE", "constraints": "" },
                { "name": "DateTo", "type": "DATE", "constraints": "" },
                { "name": "CertificateLink", "type": "TEXT", "constraints": "" },
                { "name": "EvaluationFormLink", "type": "TEXT", "constraints": "" },
                { "name": "InformationVerified", "type": "BOOLEAN", "constraints": "" },
                { "name": "StipendProofLink", "type": "TEXT", "constraints": "" }
            ]
        }
    }'
),
(
    'StudentCourses',
    'In this folder, we will manage : Template for SKIT TIMES Data',
    17,
    N'{
        "StudentCourses": {
            "columns": [
                { "name": "S. No.", "type": "INT", "constraints": "PRIMARY KEY" },
                { "name": "Roll No.", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Enrolment No.", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Student Name", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "E-mail (SKIT Domain)", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "E-mail (Personal)", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Branch", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Section", "type": "VARCHAR(10)", "constraints": "" },
                { "name": "Name of Course 1", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Attach Course 1 Certificate", "type": "BLOB", "constraints": "" },
                { "name": "Name of Course 2", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Attach Course 2 Certificate", "type": "BLOB", "constraints": "" }
            ]
        }
    }'
),
(
    'COE_Event_Training_Report',
    'In this folder, detailed information related to IoT CoE.',
    18,
    N'{
        "COE_Event_Training_Report": {
            "columns": [
                { "name": "Sr. No.", "type": "INT", "constraints": "PRIMARY KEY AUTO_INCREMENT" },
                { "name": "Dates (from-to) (in DD.MM.YYYY format only)", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Departments / Cell / Committees / Labs /COE", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Name of Faculty Coordinator (s)", "type": "TEXT", "constraints": "" },
                { "name": "Title of the professional development program organised for students", "type": "TEXT", "constraints": "" },
                { "name": "Title of the professional development program organised for teaching staff", "type": "TEXT", "constraints": "" },
                { "name": "Title of the administrative training program organised for non-teaching staff", "type": "TEXT", "constraints": "" },
                { "name": "No. of participants", "type": "INT", "constraints": "" },
                { "name": "Academic Session", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Collaboration-Details (If any)", "type": "TEXT", "constraints": "" },
                { "name": "Grant Received (YES/NO)", "type": "VARCHAR(3)", "constraints": "" },
                { "name": "Grant Details", "type": "TEXT", "constraints": "" },
                { "name": "Association with professional societies for organization of event", "type": "TEXT", "constraints": "" },
                { "name": "Number of SKIT students participated (Provided list of students with their RTU roll no. & Certificates)", "type": "TEXT", "constraints": "" },
                { "name": "Number of staff member participated (Provide list of staff member with their EMPLOYEE ID & Certificates)", "type": "TEXT", "constraints": "" },
                { "name": "Event report attached in proper format (YES/NO)", "type": "VARCHAR(3)", "constraints": "" },
                { "name": "Remarks", "type": "TEXT", "constraints": "" }
            ]
        }
    }'
),
(
    'NAAC_QIV_NBA_MoU_Report',
    'In this folder, we will manage Memorandum of understanding (MoU) with Microsoft.',
    21,
    N'{
        "NAAC_QIV_NBA_MoU_Report": {
            "columns": [
                { "name": "Organization with which MoU is signed", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Name of the institution/ industry/ corporate house", "type": "VARCHAR(255)", "constraints": "" },
                { "name": "Year of signing MoU", "type": "YEAR", "constraints": "" },
                { "name": "Duration", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "List the actual activities under each MOU year wise", "type": "TEXT", "constraints": "" },
                { "name": "Number of students/teachers participated under MoUs", "type": "INT", "constraints": "" }
            ]
        }
    }'
),
(
    'MASTER_format_faculty_higher_study',
    'In this folder, we will manage faculty’s Higher study data',
    14,
    N'{
        "MASTER_format_faculty_higher_study": {
            "columns": [
                { "name": "Sr_No", "type": "INT", "constraints": "" },
                { "name": "Name", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Department", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Designation", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Employee_ID", "type": "VARCHAR(50)", "constraints": "" },
                { "name": "Qualification", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Joining_Date", "type": "DATE", "constraints": "" },
                { "name": "Promotion_Date", "type": "DATE", "constraints": "" },
                { "name": "Retirement_Date", "type": "DATE", "constraints": "" },
                { "name": "Offer_Letter_Status", "type": "BOOLEAN", "constraints": "" },
                { "name": "Appointment_Letter_Status", "type": "BOOLEAN", "constraints": "" },
                { "name": "Highest_Degree", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Degree_Awarding_University", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "PhD_Pursuing", "type": "BOOLEAN", "constraints": "" },
                { "name": "PhD_Registration_Date", "type": "DATE", "constraints": "" },
                { "name": "PAN_No", "type": "VARCHAR(20)", "constraints": "" },
                { "name": "Area_of_Specialization", "type": "VARCHAR(100)", "constraints": "" },
                { "name": "Date_of_Birth", "type": "DATE", "constraints": "" },
                { "name": "Info_Correct_As_Per_Knowledge", "type": "BOOLEAN", "constraints": "" },
                { "name": "Awards_Recognitions_Extension_Activities", "type": "TEXT", "constraints": "" }
            ]
        }
    }'
),
(
    'AICTE_format_faculty_personal_data',
    'In this folder, we will manage faculties Personal data',
    13,
    N'{
        "AICTE_format_faculty_personal_data": {
            "columns": [
                { "name": "Sr_No", "type": "INT" },
                { "name": "Faculty_Name", "type": "VARCHAR(100)" },
                { "name": "Department", "type": "VARCHAR(100)" },
                { "name": "PAN_No", "type": "VARCHAR(20)" },
                { "name": "Aadhaar_No", "type": "VARCHAR(20)" },
                { "name": "AICTE_Unique_ID", "type": "VARCHAR(50)" },
                { "name": "Valid_Vidwan_ID", "type": "VARCHAR(50)" },
                { "name": "Caste_Category", "type": "VARCHAR(50)" },
                { "name": "RCI_Status", "type": "VARCHAR(50)" },
                { "name": "Faculty_Status", "type": "VARCHAR(50)" },
                { "name": "All_India_Council_Status", "type": "VARCHAR(50)" },
                { "name": "Designation", "type": "VARCHAR(100)" },
                { "name": "Date_of_Joining", "type": "DATE" },
                { "name": "Date_of_Confirmation", "type": "DATE" },
                { "name": "Name_as_per_Degree", "type": "VARCHAR(100)" },
                { "name": "Qualification", "type": "VARCHAR(100)" },
                { "name": "Additional_Qualification", "type": "VARCHAR(100)" },
                { "name": "Faculty_ID", "type": "VARCHAR(50)" },
                { "name": "Email_ID", "type": "VARCHAR(100)" },
                { "name": "Mobile_No", "type": "VARCHAR(15)" },
                { "name": "Highest_Qualification", "type": "VARCHAR(100)" },
                { "name": "Program_Taught", "type": "VARCHAR(100)" },
                { "name": "UG_or_PG_or_PhD", "type": "VARCHAR(20)" },
                { "name": "Appointment_Type", "type": "VARCHAR(50)" },
                { "name": "Date_of_Appraisal", "type": "DATE" },
                { "name": "FDP_Attended", "type": "VARCHAR(100)" },
                { "name": "FDP_Duration", "type": "VARCHAR(50)" },
                { "name": "FDP_Certificate_Uploaded", "type": "BOOLEAN" },
                { "name": "Guide_Ship_Status", "type": "BOOLEAN" },
                { "name": "PG_Guide", "type": "BOOLEAN" },
                { "name": "Doctorate_Guide", "type": "BOOLEAN" },
                { "name": "Common_Subject_Teacher_FY", "type": "BOOLEAN" }
            ]
        }
    }'
),
(
    'NAAC_format_faculty_higher_study',
    'In this folder, we will manage faculties Personal data',
    13,
    N'{
        "NAAC_format_faculty_higher_study": {
            "columns": [
                { "name": "Sr_No", "type": "INT" },
                { "name": "Name", "type": "VARCHAR(100)" },
                { "name": "Department", "type": "VARCHAR(100)" },
                { "name": "Designation", "type": "VARCHAR(100)" },
                { "name": "Employee_ID", "type": "VARCHAR(50)" },
                { "name": "Qualification", "type": "VARCHAR(100)" },
                { "name": "Joining_Date", "type": "DATE" },
                { "name": "Promotion_Date", "type": "DATE" },
                { "name": "Retirement_Date", "type": "DATE" },
                { "name": "Offer_Letter_Status", "type": "BOOLEAN" },
                { "name": "Appointment_Letter_Status", "type": "BOOLEAN" },
                { "name": "Highest_Degree", "type": "VARCHAR(100)" },
                { "name": "Degree_Awarding_University", "type": "VARCHAR(100)" },
                { "name": "PhD_Pursuing", "type": "BOOLEAN" },
                { "name": "PhD_Registration_Date", "type": "DATE" },
                { "name": "PhD_Area_of_Specialization", "type": "VARCHAR(100)" },
                { "name": "Date_of_Birth", "type": "DATE" },
                { "name": "Information_Verified", "type": "BOOLEAN" },
                { "name": "Awards_and_Recognitions", "type": "TEXT" }
            ]
        }
    }'
);






