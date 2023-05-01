-- Creating Database QualityManagement
IF NOT EXISTS
(
    SELECT *
    FROM sys.databases
    WHERE name = 'QualityManagement'
)
BEGIN
    CREATE DATABASE QualityManagement;
END;
GO

USE QualityManagement;
GO

-- Authentication Entities
IF OBJECT_ID(N'dbo.Roles', N'U') IS NULL
    CREATE TABLE dbo.Roles
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(20) NOT NULL
    );

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
    CREATE TABLE dbo.Users
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        RoleId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Roles (Id),
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        FullName NVARCHAR(150) NOT NULL,
        Email VARCHAR(250) NOT NULL
            UNIQUE,
        PW NVARCHAR(MAX) NOT NULL
    );

-- QualityManagement Tables Set
IF OBJECT_ID(N'dbo.Levels', N'U') IS NULL
    CREATE TABLE dbo.Levels
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL,
        LevelOrder INT NULL,
    );

IF OBJECT_ID(N'dbo.Grades', N'U') IS NULL
    CREATE TABLE dbo.Grades
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL,
        GradeOrder INT NULL,
    );

IF OBJECT_ID(N'dbo.TrainingTypes', N'U') IS NULL
    CREATE TABLE dbo.TrainingTypes
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL
    );
GO

IF OBJECT_ID(N'dbo.SemesterTypes', N'U') IS NULL
    CREATE TABLE dbo.SemesterTypes
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL
    );
GO

IF OBJECT_ID(N'dbo.Companies', N'U') IS NULL
    CREATE TABLE dbo.Companies
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        PhoneNumber1 VARCHAR(20) NULL,
        PhoneNumber2 VARCHAR(20) NULL,
        Address1 NVARCHAR(200) NULL,
        Address2 NVARCHAR(200) NULL,
        Email VARCHAR(250) NULL,
        Website VARCHAR(250) NULL,
        Brief NVARCHAR(500) NULL,
        Notes NVARCHAR(500) NULL,
    );

IF OBJECT_ID(N'dbo.Professors', N'U') IS NULL
    CREATE TABLE dbo.Professors
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        UserId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Users (Id) ON DELETE CASCADE ON UPDATE CASCADE,
        PhoneNumber1 VARCHAR(20) NULL,
        PhoneNumber2 VARCHAR(20) NULL,
        DateOfJoin DATE NULL,
        ManagementWorkDesc NVARCHAR(MAX) NULL,
        CV VARBINARY(MAX) NULL,
        CVName NVARCHAR(100) NULL,
    );

IF OBJECT_ID(N'dbo.TeachingAssistants', N'U') IS NULL
    CREATE TABLE dbo.TeachingAssistants
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        FullName NVARCHAR(150) NOT NULL,
        Email VARCHAR(250) NULL,
        PhoneNumber1 VARCHAR(20) NULL,
        PhoneNumber2 VARCHAR(20) NULL,
        ManagementWorkDesc NVARCHAR(MAX) NULL,
        DateOfJoin DATE NULL,
        CV VARBINARY(MAX) NULL,
        CVName NVARCHAR(100) NULL
    );
GO

IF OBJECT_ID(N'dbo.Rosters', N'U') IS NULL
    CREATE TABLE dbo.Rosters
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Document VARBINARY(MAX) NULL,
        DocumentName NVARCHAR(100) NULL,
        IsDefault BIT NOT NULL
    );
GO

IF OBJECT_ID(N'dbo.Trainings', N'U') IS NULL
    CREATE TABLE dbo.Trainings
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        TypeId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.TrainingTypes (Id),
        CompanyId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Companies (Id),
        ProfessorId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        Name NVARCHAR(100) NOT NULL,
        Year INT NULL
    );
GO

IF OBJECT_ID(N'dbo.TrainingGrades', N'U') IS NULL
    CREATE TABLE dbo.TrainingGrades
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        TrainingId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Trainings (Id),
        RosterId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.Rosters (Id),
        GradeBased BIT NOT NULL,
        GradeACount INT NULL,
        GradeBCount INT NULL,
        GradeCCount INT NULL,
        GradeDCount INT NULL,
        GradeFCount INT NULL,
        PassCount INT NULL,
        FailCount INT NULL,
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.TrainingFiles', N'U') IS NULL
    CREATE TABLE dbo.TrainingFiles
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        TrainingId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Trainings (Id),
        UploadedOn DATE NOT NULL,
        Name NVARCHAR(100) NULL,
        Document VARBINARY(MAX) NULL,
        DocumentName NVARCHAR(100) NULL,
    );
GO


IF OBJECT_ID(N'dbo.GraduationProjects', N'U') IS NULL
    CREATE TABLE dbo.GraduationProjects
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        ProfessorId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        TeachingAssistantId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.TeachingAssistants (Id),
        Year INT NOT NULL,
        IsSoftware BIT NULL,
        IsHardware BIT NULL,
        Name NVARCHAR(100) NOT NULL,
        Brief NVARCHAR(500) NULL,
        Notes NVARCHAR(500) NULL,
        DocumentationFile VARBINARY(MAX) NULL,
        DocumentationFileName NVARCHAR(100) NULL,
    );
GO

IF OBJECT_ID(N'dbo.GPStudents', N'U') IS NULL
    CREATE TABLE dbo.GPStudents
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        GPId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.GraduationProjects (Id) ON DELETE CASCADE ON UPDATE CASCADE,
        GradeId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.Grades (Id),
        Name NVARCHAR(100) NOT NULL,
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.Courses', N'U') IS NULL
    CREATE TABLE dbo.Courses
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        HeadProfessorId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        SecondaryProfessorId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        LevelId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Levels (Id),
        RosterId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Rosters (Id),
		ScheduledSemester UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.SemesterTypes (Id),
        Name NVARCHAR(100) NOT NULL,
        Code NVARCHAR(20) NOT NULL,
        IsActive BIT NOT NULL,
        HasPractical BIT NOT NULL,
        Brief NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.CoursePreRequisites', N'U') IS NULL
    CREATE TABLE dbo.CoursePreRequisites
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        CourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Courses (Id),
        PreRequisiteCourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Courses (Id),
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.CourseTAs', N'U') IS NULL
    CREATE TABLE dbo.CourseTAs
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        CourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Courses (Id),
        TeachingAssistantId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.TeachingAssistants (Id),
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.Semesters', N'U') IS NULL
    CREATE TABLE dbo.Semesters
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SemesterTypeId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.SemesterTypes (Id),
        Name NVARCHAR(100) NOT NULL,
        Year INT NOT NULL,
        IsActive BIT NOT NULL,
        Notes NVARCHAR(500)
    );
GO

IF OBJECT_ID(N'dbo.SemesterCourses', N'U') IS NULL
    CREATE TABLE dbo.SemesterCourses
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        CourseId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.Courses (Id),
        SemesterId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Semesters (Id),
        HeadProfessorId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        SecondaryProfessorId UNIQUEIDENTIFIER NULL
            FOREIGN KEY REFERENCES dbo.Professors (Id),
        LevelId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Levels (Id),
        RosterId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Rosters (Id),
        Name NVARCHAR(100) NOT NULL,
        Code NVARCHAR(20) NOT NULL,
        GradesSubmitted BIT NOT NULL,
        HasPractical BIT NOT NULL,
        Brief NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.SemesterCourseTAs', N'U') IS NULL
    CREATE TABLE dbo.SemesterCourseTAs
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SemesterCourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.SemesterCourses (Id),
        TeachingAssistantId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.TeachingAssistants (Id),
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.SemesterCourseGrades', N'U') IS NULL
    CREATE TABLE dbo.SemesterCourseGrades
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SemesterCourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.SemesterCourses (Id),
        RosterId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.Rosters (Id),
        GradeACount INT NULL,
        GradeBCount INT NULL,
        GradeCCount INT NULL,
        GradeDCount INT NULL,
        GradeFCount INT NULL,
        Notes NVARCHAR(500) NULL
    );
GO

IF OBJECT_ID(N'dbo.SemesterCourseFiles', N'U') IS NULL
    CREATE TABLE dbo.SemesterCourseFiles
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SemesterCourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.SemesterCourses (Id),
        UploadedOn DATE NOT NULL,
        Name NVARCHAR(100) NULL,
        Document VARBINARY(MAX) NULL,
        DocumentName NVARCHAR(100) NULL,
        IsGradesFile BIT NOT NULL
    );
GO

IF OBJECT_ID(N'dbo.Questionnaires', N'U') IS NULL
    CREATE TABLE dbo.Questionnaires
    (
        Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
        SemesterCourseId UNIQUEIDENTIFIER NOT NULL
            FOREIGN KEY REFERENCES dbo.SemesterCourses (Id),
        Year INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        Notes NVARCHAR(500) NULL,
        Document VARBINARY(MAX) NULL,
        DocumentName NVARCHAR(100) NULL
    );
GO