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
('core', 'What is the size of boolean variable?', '8 bit', '16 bit', '32 bit', 'not precisely defined', 'not precisely defined'),
('core', 'Which array declaration is valid?', 'int arr[] = new int[];', 'int[] arr = new int[5];', 'int arr[] = int[5];', 'int arr == new int[5];', 'int[] arr = new int[5];'),
('core', 'What is the default value of String variable?', '\"\"', '\"null\"', 'null', 'not defined', 'null'),
('core', 'Which is not a Java keyword?', 'transient', 'volatile', 'synchronized', 'main', 'main'),
('core', 'What does the break statement do?', 'Skips the current iteration', 'Exits the loop immediately', 'Continues to next label', 'Throws an exception', 'Exits the loop immediately'),
('core', 'Which string class is mutable?', 'String', 'StringBuilder', 'StringCharacter', 'CharBuffer', 'StringBuilder'),
('core', 'What is the base class for all exceptions?', 'Error', 'Exception', 'RuntimeException', 'Throwable', 'Throwable'),

('oop', 'Which feature of OOP indicates code reusability?', 'Abstraction', 'Polymorphism', 'Encapsulation', 'Inheritance', 'Inheritance'),
('oop', 'What is the process of defining more than one method with the same name but different parameters?', 'Method Overriding', 'Method Overloading', 'Method Overlapping', 'Method Hiding', 'Method Overloading'),
('oop', 'Which of these cannot be used for a variable name in Java?', 'identifier & keyword', 'identifier', 'keyword', 'none of the mentioned', 'keyword'),
('oop', 'What is Encapsulation?', 'Binding code and data together', 'Hiding implementation details', 'Creating multiple forms', 'Deriving a class', 'Binding code and data together'),
('oop', 'Which class is the superclass of all classes in Java?', 'Main', 'System', 'Object', 'Class', 'Object'),
('oop', 'Which of these is not an OOP principle?', 'Encapsulation', 'Polymorphism', 'Compilation', 'Inheritance', 'Compilation'),
('oop', 'What does the \"super\" keyword refer to?', 'Current class object', 'Parent class object', 'Child class object', 'None of the above', 'Parent class object'),
('oop', 'Can we instantiate an abstract class?', 'Yes', 'No', 'Sometimes', 'Depends on JVM', 'No'),
('oop', 'Which keyword is used to establish IS-A relationship?', 'implements', 'extends', 'instanceof', 'super', 'extends'),
('oop', 'Which method is used to perform shallow copy?', 'clone()', 'copy()', 'duplicate()', 'shallow()', 'clone()'),
('oop', 'Can a class extend multiple classes in Java?', 'Yes', 'No', 'Only if they are abstract', 'Only at runtime', 'No'),
('oop', 'Which keyword prevents a method from being overridden?', 'static', 'const', 'final', 'sealed', 'final'),
('oop', 'What is dynamic method dispatch?', 'Method overloading', 'Runtime polymorphism', 'Compile time polymorphism', 'Garbage collection', 'Runtime polymorphism'),
('oop', 'Which of these is a marker interface?', 'Cloneable', 'Runnable', 'Callable', 'Comparator', 'Cloneable'),
('oop', 'What is downcasting?', 'Casting child to parent', 'Casting parent to child', 'Casting to String', 'Casting primitive types', 'Casting parent to child'),

('advanced', 'Which of the following is a thread-safe implementation of Map?', 'HashMap', 'TreeMap', 'ConcurrentHashMap', 'LinkedHashMap', 'ConcurrentHashMap'),
('advanced', 'What is the purpose of the Garbage Collector in Java?', 'Recompile code', 'Free up memory automatically', 'Execute threads', 'Handle exceptions', 'Free up memory automatically'),
('advanced', 'Which functional interface accepts one argument and returns no result?', 'Function', 'Supplier', 'Consumer', 'Predicate', 'Consumer'),
('advanced', 'What is a lambda expression in Java?', 'A unique class', 'An anonymous method', 'A thread', 'A collection framework', 'An anonymous method'),
('advanced', 'Which API introduced Stream in Java?', 'Java 7', 'Java 8', 'Java 9', 'Java 10', 'Java 8'),
('advanced', 'In JDBC, which interface is used to execute parameterized SQL queries?', 'Statement', 'PreparedStatement', 'CallableStatement', 'ResultSet', 'PreparedStatement'),
('advanced', 'What pattern does the Singleton class implement?', 'Factory', 'Creational', 'Structural', 'Behavioral', 'Creational'),
('advanced', 'What does synchronized block ensure?', 'Multiple threads execute', 'Method is public', 'Thread safety', 'Memory leak prevention', 'Thread safety'),
('advanced', 'What is the root interface of the Java collection framework?', 'Collection', 'List', 'Iterable', 'Map', 'Iterable'),
('advanced', 'Which method must be implemented by a class implementing Runnable?', 'start()', 'run()', 'execute()', 'yield()', 'run()'),
('advanced', 'What does the wait() method do?', 'Pauses the thread for a specified time', 'Terminates the thread', 'Releases the lock and waits', 'Throws an InterruptedException', 'Releases the lock and waits'),
('advanced', 'Which of these is used to read data from a file in Java?', 'FileWriter', 'FileInputStream', 'StringReader', 'OutputStream', 'FileInputStream'),
('advanced', 'What is the default port for MySQL?', '8080', '3306', '1521', '5432', '3306'),
('advanced', 'Which Collection allows duplicate elements?', 'Set', 'HashSet', 'TreeSet', 'List', 'List'),
('advanced', 'What is JDBC?', 'Java Database Connectivity', 'Java Data Core', 'Java Development Cloud', 'Java Direct Connection', 'Java Database Connectivity'),

('misc', 'What is a Maven?', 'A build tool', 'A web framework', 'A database', 'An IDE', 'A build tool'),
('misc', 'Which company currently owns Java?', 'Sun Microsystems', 'Oracle', 'Microsoft', 'Google', 'Oracle'),
('misc', 'What is the port number for Tomcat by default?', '80', '8080', '3306', '5432', '8080'),
('misc', 'How many primitive data types are there in Java?', '6', '7', '8', '9', '8'),
('misc', 'What does JVM stand for?', 'Java Variables Memory', 'Java Virtual Machine', 'Java Verification Method', 'Java Visual Map', 'Java Virtual Machine'),
('misc', 'Which wrapper class is used for char?', 'String', 'Character', 'Char', 'CharSequence', 'Character'),
('misc', 'Is Java pass-by-value or pass-by-reference?', 'Pass by value', 'Pass by reference', 'Both', 'Neither', 'Pass by value'),
('misc', 'What does API stand for?', 'Automated Programming Interface', 'Application Programming Interface', 'Advanced Programming Integration', 'Application Process Integration', 'Application Programming Interface'),
('misc', 'What does HTTP stand for?', 'Hyper Text Transfer Protocol', 'High Technical Text Protocol', 'Hyper Transfer Text Protocol', 'Hyper Text Technical Protocol', 'Hyper Text Transfer Protocol'),
('misc', 'Which framework is widely used for building Java Web Applications?', 'Spring', 'Django', 'Flask', 'Laravel', 'Spring'),
('misc', 'What is JSON?', 'Java Standard Object Notation', 'JavaScript Object Notation', 'Java Secure Object Network', 'JavaScript Oriented Network', 'JavaScript Object Notation'),
('misc', 'Which tool is used for version control?', 'Docker', 'Jenkins', 'Git', 'Maven', 'Git'),
('misc', 'What does IDE stand for?', 'Internal Design Engine', 'Integrated Development Environment', 'Interactive Data Element', 'Isolated Development Environment', 'Integrated Development Environment'),
('misc', 'What is an annotation in Java?', 'A comment', 'Runtime metadata', 'A core class', 'A compiler error', 'Runtime metadata'),
('misc', 'What is the purpose of JUnit?', 'Unit Testing', 'Database connection', 'Web server configuration', 'GUI development', 'Unit Testing');
