-- ============================================================
-- Insert questions for OOP Concepts (category = 'oop')
-- ============================================================
INSERT INTO questions (category, question, option1, option2, option3, option4, correct_answer) VALUES
('oop', 'Which OOP principle allows a class to have multiple methods with the same name but different parameters?', 'Encapsulation', 'Polymorphism', 'Inheritance', 'Abstraction', 'Polymorphism'),
('oop', 'Which keyword is used to inherit a class in Java?', 'implements', 'extends', 'inherits', 'super', 'extends'),
('oop', 'What is encapsulation in Java?', 'Hiding the implementation details and exposing only the interface', 'Creating multiple objects from one class', 'Inheriting properties from parent class', 'Overriding methods in subclasses', 'Hiding the implementation details and exposing only the interface'),
('oop', 'What does the "super" keyword refer to in Java?', 'The current class instance', 'The parent class', 'A static method', 'An interface', 'The parent class'),
('oop', 'Which of the following best describes abstraction?', 'Wrapping data and methods together', 'Hiding internal details and showing only functionality', 'One class acquiring properties of another', 'Same method name with different signatures', 'Hiding internal details and showing only functionality'),
('oop', 'What type of inheritance is NOT directly supported in Java (without interfaces)?', 'Single inheritance', 'Multilevel inheritance', 'Multiple inheritance', 'Hierarchical inheritance', 'Multiple inheritance'),
('oop', 'Which concept allows a subclass to provide a specific implementation of a method already defined in the parent class?', 'Overloading', 'Encapsulation', 'Overriding', 'Abstraction', 'Overriding'),
('oop', 'In Java, which access modifier makes a member accessible only within its own class?', 'protected', 'public', 'default', 'private', 'private'),
('oop', 'What is a constructor in Java?', 'A method that returns an object', 'A special method called when an object is instantiated', 'A static block of code', 'A method used to destroy objects', 'A special method called when an object is instantiated'),
('oop', 'Which of the following is true about an abstract class?', 'It can be instantiated directly', 'It cannot have any methods', 'It can have both abstract and concrete methods', 'It must implement all abstract methods', 'It can have both abstract and concrete methods');

-- ============================================================
-- Insert questions for Advanced Java (category = 'advanced')
-- ============================================================
INSERT INTO questions (category, question, option1, option2, option3, option4, correct_answer) VALUES
('advanced', 'Which package contains the JDBC API?', 'java.sql', 'java.net', 'java.io', 'javax.sql', 'java.sql'),
('advanced', 'What is a thread in Java?', 'A class that handles exceptions', 'A lightweight subprocess for concurrent execution', 'A static method block', 'A type of collection', 'A lightweight subprocess for concurrent execution'),
('advanced', 'Which interface must be implemented to create a thread in Java?', 'Runnable', 'Serializable', 'Cloneable', 'Comparable', 'Runnable'),
('advanced', 'What does the "synchronized" keyword do in Java?', 'Makes a variable constant', 'Allows only one thread to access a block at a time', 'Starts a new thread', 'Connects to a database', 'Allows only one thread to access a block at a time'),
('advanced', 'What is the purpose of the Java Collections Framework?', 'To handle file I/O', 'To manage database connections', 'To provide reusable data structures and algorithms', 'To define networking protocols', 'To provide reusable data structures and algorithms'),
('advanced', 'Which of the following is NOT a valid HTTP method in a Java Servlet?', 'doGet', 'doPost', 'doPut', 'doFetch', 'doFetch'),
('advanced', 'What does JVM stand for?', 'Java Virtual Memory', 'Java Virtual Machine', 'Java Variant Method', 'Java Visual Model', 'Java Virtual Machine'),
('advanced', 'Which annotation is used to declare a Java Servlet?', '@Servlet', '@WebServlet', '@HttpServlet', '@Controller', '@WebServlet'),
('advanced', 'What is the default port for Apache Tomcat?', '80', '443', '8080', '3306', '8080'),
('advanced', 'What is the role of PreparedStatement over Statement in JDBC?', 'It is slower but simpler', 'It prevents SQL injection and is precompiled', 'It only supports SELECT queries', 'It does not support parameters', 'It prevents SQL injection and is precompiled');

-- ============================================================
-- Insert questions for Miscellaneous (category = 'misc')
-- ============================================================
INSERT INTO questions (category, question, option1, option2, option3, option4, correct_answer) VALUES
('misc', 'Which data structure follows LIFO (Last In, First Out) order?', 'Queue', 'LinkedList', 'Stack', 'Tree', 'Stack'),
('misc', 'What is the time complexity of binary search?', 'O(n)', 'O(n log n)', 'O(log n)', 'O(1)', 'O(log n)'),
('misc', 'Which design pattern ensures a class has only one instance?', 'Factory', 'Observer', 'Singleton', 'Strategy', 'Singleton'),
('misc', 'What does SQL stand for?', 'Structured Query Language', 'Simple Query Logic', 'Standard Query List', 'Sequential Query Language', 'Structured Query Language'),
('misc', 'Which HTTP status code indicates "Not Found"?', '200', '301', '403', '404', '404'),
('misc', 'What is a foreign key in a relational database?', 'A key that identifies unique rows in the same table', 'A key in one table that references the primary key of another table', 'An encrypted key for security', 'A composite key made of multiple columns', 'A key in one table that references the primary key of another table'),
('misc', 'What does HTML stand for?', 'HyperText Markup Language', 'HighText Machine Language', 'Hyperlink and Text Markup Language', 'Hyper Transfer Markup Language', 'HyperText Markup Language'),
('misc', 'Which Java class is used to read user input from the console?', 'BufferedWriter', 'FileReader', 'Scanner', 'PrintStream', 'Scanner'),
('misc', 'What is the purpose of a version control system like Git?', 'To compile Java code', 'To manage and track changes in source code', 'To deploy web applications', 'To connect to databases', 'To manage and track changes in source code'),
('misc', 'Which keyword in Java is used to handle exceptions?', 'handle', 'catch', 'error', 'rescue', 'catch');
