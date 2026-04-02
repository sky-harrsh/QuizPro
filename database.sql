CREATE DATABASE IF NOT EXISTS quizdb;
USE quizdb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    question TEXT NOT NULL,
    option1 VARCHAR(255) NOT NULL,
    option2 VARCHAR(255) NOT NULL,
    option3 VARCHAR(255) NOT NULL,
    option4 VARCHAR(255) NOT NULL,
    correct_answer VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    score INT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert dummy questions
INSERT INTO questions (category, question, option1, option2, option3, option4, correct_answer) VALUES
('core', 'What is the default value of a local variable in Java?', 'null', '0', 'Depends on data type', 'No default value', 'No default value'),
('core', 'Which of the following is not a Java features?', 'Dynamic', 'Architecture Neutral', 'Use of pointers', 'Object-oriented', 'Use of pointers'),
('core', 'What is the size of int variable?', '8 bit', '16 bit', '32 bit', '64 bit', '32 bit'),
('core', 'Which keyword is used for accessing the features of a package?', 'package', 'import', 'extends', 'export', 'import'),
('core', 'In java, jar stands for?', 'Java Archive Runner', 'Java Application Resource', 'Java Application Runner', 'Java Archive', 'Java Archive'),
('core', 'Which component is used to compile, debug and execute the java programs?', 'JRE', 'JIT', 'JDK', 'JVM', 'JDK'),
('core', 'What is the extension of java code files?', '.js', '.txt', '.class', '.java', '.java'),
('core', 'Who invented Java Programming?', 'Guido van Rossum', 'James Gosling', 'Dennis Ritchie', 'Bjarne Stroustrup', 'James Gosling'),

('oop', 'Which feature of OOP indicates code reusability?', 'Abstraction', 'Polymorphism', 'Encapsulation', 'Inheritance', 'Inheritance'),
('oop', 'What is the process of defining more than one method with the same name but different parameters?', 'Method Overriding', 'Method Overloading', 'Method Overlapping', 'Method Hiding', 'Method Overloading'),
('oop', 'Which of these cannot be used for a variable name in Java?', 'identifier & keyword', 'identifier', 'keyword', 'none of the mentioned', 'keyword'),
('oop', 'What is Encapsulation?', 'Binding code and data together', 'Hiding implementation details', 'Creating multiple forms', 'Deriving a class', 'Binding code and data together'),
('oop', 'Which class is the superclass of all classes in Java?', 'Main', 'System', 'Object', 'Class', 'Object'),
('oop', 'Which of these is not an OOP principle?', 'Encapsulation', 'Polymorphism', 'Compilation', 'Inheritance', 'Compilation'),
('oop', 'What does the "super" keyword refer to?', 'Current class object', 'Parent class object', 'Child class object', 'None of the above', 'Parent class object'),
('oop', 'Can we instantiate an abstract class?', 'Yes', 'No', 'Sometimes', 'Depends on JVM', 'No'),

('advanced', 'Which of the following is a thread-safe implementation of Map?', 'HashMap', 'TreeMap', 'ConcurrentHashMap', 'LinkedHashMap', 'ConcurrentHashMap'),
('advanced', 'What is the purpose of the Garbage Collector in Java?', 'Recompile code', 'Free up memory automatically', 'Execute threads', 'Handle exceptions', 'Free up memory automatically'),
('advanced', 'Which functional interface accepts one argument and returns no result?', 'Function', 'Supplier', 'Consumer', 'Predicate', 'Consumer'),
('advanced', 'What is a lambda expression in Java?', 'A unique class', 'An anonymous method', 'A thread', 'A collection framework', 'An anonymous method'),
('advanced', 'Which API introduced Stream in Java?', 'Java 7', 'Java 8', 'Java 9', 'Java 10', 'Java 8'),
('advanced', 'In JDBC, which interface is used to execute parameterized SQL queries?', 'Statement', 'PreparedStatement', 'CallableStatement', 'ResultSet', 'PreparedStatement'),
('advanced', 'What pattern does the Singleton class implement?', 'Factory', 'Creational', 'Structural', 'Behavioral', 'Creational'),
('advanced', 'What does synchronized block ensure?', 'Multiple threads execute', 'Method is public', 'Thread safety', 'Memory leak prevention', 'Thread safety'),

('misc', 'What is a Maven?', 'A build tool', 'A web framework', 'A database', 'An IDE', 'A build tool'),
('misc', 'Which company currently owns Java?', 'Sun Microsystems', 'Oracle', 'Microsoft', 'Google', 'Oracle'),
('misc', 'What is the port number for Tomcat by default?', '80', '8080', '3306', '5432', '8080'),
('misc', 'How many primitive data types are there in Java?', '6', '7', '8', '9', '8'),
('misc', 'What does JVM stand for?', 'Java Variables Memory', 'Java Virtual Machine', 'Java Verification Method', 'Java Visual Map', 'Java Virtual Machine'),
('misc', 'Which wrapper class is used for char?', 'String', 'Character', 'Char', 'CharSequence', 'Character'),
('misc', 'Is Java pass-by-value or pass-by-reference?', 'Pass by value', 'Pass by reference', 'Both', 'Neither', 'Pass by value'),
('misc', 'What does API stand for?', 'Automated Programming Interface', 'Application Programming Interface', 'Advanced Programming Integration', 'Application Process Integration', 'Application Programming Interface');
