create table employee (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(50) NOT NULL,
	email VARCHAR(150),
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL
);

create table report (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	report_title VARCHAR(50) NOT NULL,
    report_content VARCHAR(50) NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES employee (id)
);