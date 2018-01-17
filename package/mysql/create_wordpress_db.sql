CREATE DATABASE wordpress;
CREATE USER wpuser@localhost;
SET PASSWORD FOR wpuser@localhost=PASSWORD('wppassword');
GRANT ALL PRIVILEGES ON wordpress.* TO wpuser@localhost IDENTIFIED BY 'wppassword';
FLUSH PRIVILEGES;