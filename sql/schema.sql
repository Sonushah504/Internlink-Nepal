CREATE DATABASE IF NOT EXISTS internlink_nepal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE internlink_nepal;


CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('STUDENT','COMPANY','ADMIN') NOT NULL DEFAULT 'STUDENT',
    is_active     TINYINT(1) NOT NULL DEFAULT 1,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS student_profiles (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT NOT NULL UNIQUE,
    full_name         VARCHAR(255) NOT NULL,
    phone             VARCHAR(20),
    address           VARCHAR(255),
    university        VARCHAR(255),
    program           VARCHAR(255),
    semester          INT,
    cgpa              DECIMAL(4,2),
    skills            TEXT,
    github_url        VARCHAR(500),
    linkedin_url      VARCHAR(500),
    cv_path           VARCHAR(500),
    profile_photo     VARCHAR(500),
    experience_type   ENUM('FRESHER','INTERN','EXPERIENCED') NOT NULL DEFAULT 'FRESHER',
    profile_score     INT DEFAULT 0,
    bio               TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS companies (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL UNIQUE,
    company_name    VARCHAR(255) NOT NULL,
    industry        VARCHAR(255),
    description     TEXT,
    website         VARCHAR(500),
    phone           VARCHAR(20),
    address         VARCHAR(500),
    city            VARCHAR(100),
    latitude        DECIMAL(10,8),
    longitude       DECIMAL(11,8),
    logo_path       VARCHAR(500),
    is_verified     TINYINT(1) NOT NULL DEFAULT 0,
    employee_count  VARCHAR(50),
    founded_year    INT,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS job_postings (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    company_id          INT NOT NULL,
    title               VARCHAR(255) NOT NULL,
    description         TEXT,
    requirements        TEXT,
    skills_required     TEXT,
    job_type            ENUM('INTERNSHIP','PART_TIME','FULL_TIME','REMOTE') NOT NULL,
    experience_required ENUM('FRESHER','INTERN','EXPERIENCED','ANY') NOT NULL DEFAULT 'ANY',
    min_cgpa            DECIMAL(4,2) DEFAULT 0.0,
    location            VARCHAR(255),
    salary_range        VARCHAR(100),
    deadline            DATE,
    is_active           TINYINT(1) NOT NULL DEFAULT 1,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS applications (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    student_id      INT NOT NULL,
    job_id          INT NOT NULL,
    cover_letter    TEXT,
    status          ENUM('PENDING','REVIEWING','SHORTLISTED','SELECTED','REJECTED') NOT NULL DEFAULT 'PENDING',
    applied_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    company_notes   TEXT,
    FOREIGN KEY (student_id) REFERENCES student_profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id)     REFERENCES job_postings(id)     ON DELETE CASCADE,
    UNIQUE KEY uq_student_job (student_id, job_id)
);


CREATE TABLE IF NOT EXISTS portfolios (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    tech_stack  VARCHAR(500),
    github_url  VARCHAR(500),
    live_url    VARCHAR(500),
    image_path  VARCHAR(500),
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student_profiles(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS notifications (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    title       VARCHAR(255) NOT NULL,
    message     TEXT,
    target_path VARCHAR(500),
    is_read     TINYINT(1) DEFAULT 0,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- Admin user (password: Admin@123)
INSERT INTO users (email, password_hash, role) VALUES
('admin@internlink.com.np', '$2a$12$pf.a8IlLphysTmqw1n85lu5hv5ogwUAJD8spMDqsAhsl6wSiC2j7m', 'ADMIN');

-- Sample companies
INSERT INTO users (email, password_hash, role) VALUES
('leapfrog@demo.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'COMPANY'),
('cloudFactory@demo.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'COMPANY'),
('yomari@demo.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'COMPANY');

INSERT INTO companies (user_id, company_name, industry, description, website, phone, address, city, latitude, longitude, is_verified, employee_count, founded_year) VALUES
(2, 'Leapfrog Technology', 'Software Development', 'Leading software company in Nepal focused on quality and innovation.', 'https://lftechnology.com', '01-4433000', 'Hattiban, Lalitpur', 'Lalitpur', 27.6602, 85.3220, 1, '200-500', 2010),
(3, 'CloudFactory Nepal', 'Data & AI Services', 'Global platform connecting skilled workers with AI and data tasks.', 'https://cloudfactory.com', '01-5900000', 'Jawalakhel, Lalitpur', 'Lalitpur', 27.6710, 85.3143, 1, '500-1000', 2010),
(4, 'Yomari Info Solutions', 'IT Services', 'Innovative IT solutions and software development firm.', 'https://yomari.com', '01-4423000', 'New Baneshwor, Kathmandu', 'Kathmandu', 27.6938, 85.3413, 1, '50-100', 2008);

-- Sample students
INSERT INTO users (email, password_hash, role) VALUES
('ram@demo.com',   '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'STUDENT'),
('sita@demo.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'STUDENT'),
('hari@demo.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'STUDENT'),
('gita@demo.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'STUDENT'),
('bishal@demo.com','$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMqJqhN5/LewdBPj/RK.s5uoRi', 'STUDENT');

INSERT INTO student_profiles (user_id, full_name, phone, university, program, semester, cgpa, skills, github_url, experience_type, profile_score, bio) VALUES
(5,  'Ram Sharma',    '9841001001', 'Tribhuvan University', 'BIT',   7, 3.50, 'Java,MySQL,JSP,HTML,CSS',        'github.com/ramsharma',    'FRESHER',    85, 'Passionate Java developer looking for first internship.'),
(6,  'Sita Karki',    '9841002002', 'Pokhara University',   'BCA',   6, 3.75, 'React,JavaScript,Figma,CSS',     'github.com/sitakarki',    'INTERN',     90, 'Frontend enthusiast with 3 months internship experience.'),
(7,  'Hari Thapa',    '9841003003', 'Tribhuvan University', 'BSCIT', 8, 3.20, 'Python,Django,SQL,Machine Learning','github.com/harithapa',  'EXPERIENCED',78, 'Full stack developer with 1 year experience.'),
(8,  'Gita Poudel',   '9841004004', 'Kathmandu University', 'BE CS', 5, 3.60, 'C++,Java,Android,Firebase',     'github.com/gitapoudel',   'FRESHER',    72, 'Android developer passionate about mobile apps.'),
(9,  'Bishal Rai',    '9841005005', 'Tribhuvan University', 'BIT',   7, 3.45, 'Node.js,MongoDB,Express,React',  'github.com/bishalrai',    'INTERN',     88, 'MERN stack developer with project experience.');

-- Sample job postings
INSERT INTO job_postings (company_id, title, description, requirements, skills_required, job_type, experience_required, min_cgpa, location, salary_range, deadline, is_active) VALUES
(1, 'Frontend Developer Intern', 'Work on React-based projects with our UI team.', 'Basic React knowledge, Good communication', 'React,JavaScript,CSS,HTML', 'INTERNSHIP', 'FRESHER', 2.50, 'Lalitpur', 'NPR 8,000-12,000/month', '2025-06-30', 1),
(1, 'Java Backend Developer', 'Develop and maintain Spring Boot microservices.', 'Java, Spring Boot experience', 'Java,Spring Boot,MySQL,REST API', 'FULL_TIME', 'EXPERIENCED', 3.00, 'Lalitpur', 'NPR 35,000-55,000/month', '2025-07-15', 1),
(2, 'Data Annotation Specialist', 'Annotate datasets for AI training pipelines.', 'Attention to detail, basic computer skills', 'Excel,Data Entry,English', 'PART_TIME', 'ANY', 2.00, 'Lalitpur', 'NPR 15,000-20,000/month', '2025-06-20', 1),
(3, 'UI/UX Design Intern', 'Design beautiful interfaces using Figma.', 'Portfolio required, Figma basics', 'Figma,Prototyping,User Research', 'INTERNSHIP', 'FRESHER', 2.50, 'Kathmandu', 'NPR 5,000-8,000/month', '2025-06-25', 1),
(3, 'Full Stack Developer', 'Build web applications end-to-end.', 'Min 1 year experience', 'Node.js,React,MongoDB,Express', 'FULL_TIME', 'EXPERIENCED', 3.00, 'Kathmandu', 'NPR 45,000-70,000/month', '2025-07-30', 1);

-- Sample applications
INSERT INTO applications (student_id, job_id, cover_letter, status) VALUES
(1, 1, 'I am a passionate Java developer eager to learn React.', 'SHORTLISTED'),
(2, 1, 'Frontend is my passion. I have built 5 React projects.', 'REVIEWING'),
(3, 2, 'I have solid Java experience and am ready for full time.', 'PENDING'),
(4, 4, 'I love designing and have a strong portfolio to share.', 'SHORTLISTED'),
(5, 5, 'Full stack is my strength. Ready to contribute from day one.', 'SELECTED'),
(1, 4, 'Excited about UI/UX as well. I can learn Figma quickly.', 'PENDING'),
(2, 3, 'Happy to annotate data and grow with CloudFactory.', 'REVIEWING');

-- Sample portfolios
INSERT INTO portfolios (student_id, title, description, tech_stack, github_url) VALUES
(1, 'Library Management System', 'Full CRUD Java Servlet app for managing library books.', 'Java,JSP,MySQL,Bootstrap', 'github.com/ramsharma/library'),
(2, 'E-commerce Frontend', 'Fully responsive e-commerce UI built with React.', 'React,CSS,Bootstrap,JavaScript', 'github.com/sitakarki/ecommerce'),
(3, 'Student Grade Predictor', 'ML model to predict student grades based on habits.', 'Python,Scikit-learn,Flask,Pandas', 'github.com/harithapa/predictor'),
(4, 'Fitness Tracker App', 'Android app to log daily workouts and calories.', 'Android,Java,Firebase,Room DB', 'github.com/gitapoudel/fitness'),
(5, 'Real-time Chat App', 'Socket.io chat app with rooms and DMs.', 'Node.js,Socket.io,React,MongoDB', 'github.com/bishalrai/chatapp');
