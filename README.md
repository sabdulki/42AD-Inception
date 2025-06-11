# Inception

> Running web-page via docker compose and dockerized WordPress, MariaDB, and Nginx in Virtual Machine. 

---

## Overview

This project builds a WordPress environment using **Docker Compose**. The setup includes:

- **MariaDB**: Database backend
- **WordPress**: PHP-based CMS
- **PHP-FPM 7.4**: PHP FastCGI process manager
- **Nginx**: Web server with SSL support
- **Custom scripts**: Automate initialization, user creation, theme activation, etc.
- **Self-signed SSL sertificate**: enabling secure conection to web-site via https
- **Security**: Secrets handled via external files

## How to Run

1. **Clone the repo into your VM or regular machine via terminal or any other CLI:**

   ```
    git clone https://github.com/sabdulki/42AD-Inception.git
   ```
2. Go to 42AD-Inception folder

    ```
    cd 42AD-Inception
    ```

3. Create .env file in srcs folder
    ```
    cd srcs && touch .etc
    ```
4. Fill the .env following this pattern

    ```
    IMPORTANT_VARIABLE=sabdulki
    DOMAIN_NAME=sabdulki.42.fr

    DB_NAME=<your_db_name>
    DB_ROOT_PASS=<your_pass>
    DB_USER=<your_db_user_name>
    DB_USER_PASS=<ypur_db_user_pass>
    
    BRAND=<your_blog_name>
    
    WORDPRESS_ADMIN=<admin_name>
    WORDPRESS_ADMIN_PASS=<your_admin_pass>
    WORDPRESS_ADMIN_EMAIL=<admin_email>
    
    WORDPRESS_USER=<regular_user_name>
    WORDPRESS_USER_PASS=<regular_user_pass>
    WORDPRESS_USER_EMAIL=<regular_user_email>

    ```
5. Run Makefile from the root of project to build
    ```
    cd .. && make 
    ```
6. Wait until the end of building

**❗Attention❗**
This project is designed to be run inside a Virtual Machine because of its reliance on a specific domain name. To access the website from your browser (either inside the VM or from your host machine), you will likely need to edit your /etc/hosts file and map the domain name to the VM's IP address. This allows your system to resolve the custom domain correctly during development or testing.

```
    nano /etc/hosts
```
Paste inside
```
    127.0.0.1 <your_domain_name>
```
7. Visit your site in browser
    ```
    https://<your_domain_name>.42.fr
    ```
## Services ⚙️ 

| Service    | Port | Description                 |
|------------|------|-----------------------------|
| Nginx      | 443  | HTTPS frontend              |
| WordPress  | 9000  | Served through PHP-FPM     |
| MariaDB    | 3306 | Database backend            |

## Features
Automatically installs and configures all 3 services: WordPress, MariaDB and Nginx.

**Note**: these Docker Images are not downloaded from DockerHub. They are created manually during the bulding of the project. 

Automatically creates:

- Admin and author users

- Database and users

- Secure theme activation

- SSL-enabled (self-signed)

- FastCGI for optimized PHP performance

## Author

👨‍💻 Sofya Abdulkina — https://github.com/sabdulki

Developed as part of 42 Abu Dhabi curriculum.