show databases;

create database tryout;

use tryout;

show tables;

CREATE TABLE users (
  id CHAR(36) PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  text TEXT NOT NULL,
  explanation TEXT,
  video_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE options (
  id INT AUTO_INCREMENT PRIMARY KEY,
  question_id INT NOT NULL,
  text TEXT NOT NULL,
  is_correct BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (question_id)
    REFERENCES questions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE attempts (
  id CHAR(36) PRIMARY KEY,
  user_id CHAR(36) NOT NULL,
  score INT,
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  submitted_at TIMESTAMP,
  FOREIGN KEY (user_id)
    REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE answers (
  attempt_id CHAR(36) NOT NULL,
  question_id INT NOT NULL,
  option_id INT NOT NULL,
  PRIMARY KEY (attempt_id, question_id),
  FOREIGN KEY (attempt_id)
    REFERENCES attempts(id)
    ON DELETE CASCADE,
  FOREIGN KEY (question_id)
    REFERENCES questions(id),
  FOREIGN KEY (option_id)
    REFERENCES options(id)
) ENGINE=InnoDB;

CREATE TABLE tryouts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  duration_minutes INT
);

CREATE INDEX idx_attempts_user ON attempts(user_id);
CREATE INDEX idx_options_question ON options(question_id);
CREATE INDEX idx_answers_attempt ON answers(attempt_id);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE materials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  content TEXT,
  video_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_material_course
    FOREIGN KEY (course_id)
    REFERENCES courses(id)
    ON DELETE CASCADE
);

ALTER TABLE tryouts
ADD COLUMN course_id INT NOT NULL AFTER id;

ALTER TABLE tryouts
ADD COLUMN description TEXT AFTER title;

ALTER TABLE tryouts
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE tryouts
ADD CONSTRAINT fk_tryout_course
FOREIGN KEY (course_id)
REFERENCES courses(id)
ON DELETE CASCADE;

ALTER TABLE tryouts
MODIFY title VARCHAR(255) NOT NULL;

ALTER TABLE questions
ADD COLUMN tryout_id INT NOT NULL;

ALTER TABLE questions
ADD CONSTRAINT fk_question_tryout
FOREIGN KEY (tryout_id)
REFERENCES tryouts(id)
ON DELETE CASCADE;

ALTER TABLE attempts
ADD COLUMN tryout_id INT NOT NULL;

ALTER TABLE attempts
ADD CONSTRAINT fk_attempt_tryout
FOREIGN KEY (tryout_id)
REFERENCES tryouts(id)
ON DELETE CASCADE;
