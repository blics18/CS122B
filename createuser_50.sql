CREATE USER 'mytestuser'@'localhost' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON * . * TO 'mytestuser'@'localhost';
FLUSH PRIVILEGES;