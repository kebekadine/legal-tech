CREATE TYPE permission AS ENUM(
    'SUPREME', 'WRITE_ALL_POSTS',
    'WRITE_BLOG_POST', 'WRITE_REVUE',
    'WRITE_PAGE', 'WRITE_DOMAIN',
    'WRITE_PRESS', 'WRITE_FOREIGN_POSTS',
    'WRITE_NEWS', 'DELETE_ALL_POSTS',
    'DELETE_BLOG_POST', 'DELETE_REVUE',
    'DELETE_PAGE', 'DELETE_DOMAIN', 'DELETE_PRESS', 'DELETE_FOREIGN_POSTS', 'DELETE_NEWS',
    'UPDATE_ALL_POSTS', 'UPDATE_BLOG_POST',
    'UPDATE_REVUE', 'UPDATE_PAGE', 'UPDATE_DOMAIN', 'UPDATE_PRESS', 'UPDATE_FOREIGN_POSTS', 'UPDATE_NEWS',
    'APPROVE_MEMBER', 'BLOCK_MEMBER_TEMPORARILY', 'BLOCK_MEMBER_FOREVER', 'DELETE_MEMBER'
    );

CREATE TYPE user_type AS ENUM ('SUPERUSER', 'ADMIN', 'LAWYER', 'INTERN', 'DEV');

CREATE TYPE credential_status AS ENUM (
    'PENDING',
    'APPROVED',
    'VALIDATED',
    'BLOCKED_TEMPORARILY',
    'BLOCKED_FOREVER',
    'DELETED');

create table t_credentials_cre
(
	cre_id serial
		constraint t_credentials_cre_pk
			primary key,
	cre_email varchar(50) not null,
	cre_password text not null,
	cre_status credential_status,
	cre_inserted_at timestamp default now() not null,
	cre_updated_at timestamp default now() not null
);

create unique index t_credentials_cre_cre_email_uindex
	on t_credentials_cre (cre_email);

create table t_member_mem
(
	mem_id serial
		constraint t_member_mem_pk
			primary key,
	mem_first_name varchar(30) not null,
	mem_last_name varchar(30) not null,
	mem_avatar text not null,
	mem_type user_type default 'LAWYER' not null,
	mem_description text default 'aucune description' not null,
	cre_id int not null
		constraint t_member_mem_t_credentials_cre_cre_id_fk
			references t_credentials_cre
				on delete restrict
);

create table tj_credentials_permission
(
	cre_id int not null
		constraint tj_credentials_permission_t_credentials_cre_cre_id_fk
			references t_credentials_cre
				on delete restrict,
	permission permission default 'WRITE_BLOG_POST' not null,
	constraint tj_credentials_permission_pk
		primary key (cre_id, permission)
);

create table t_lawyer_info_lin
(
	cre_id int not null
		constraint t_lawyer_info_lin_t_credentials_cre_cre_id_fk
			references t_credentials_cre
				on delete restrict,
	lin_prefecture varchar(40) not null,
	lin_sermon_date timestamp default now() not null
);

create table t_domain_dom
(
	dom_id serial
		constraint t_domain_dom_pk
			primary key,
	dom_name varchar(50) not null,
	dom_description varchar(250),
	dom_inserted_at timestamp default now() not null,
	dom_updated_at timestamp default now() not null,
	art_id int default 1 not null
);

create unique index t_domain_dom_dom_name_uindex
	on t_domain_dom (dom_name);

create table tj_domain_lawyer
(
	dom_id int not null
		constraint tj_domain_lawyer_t_domain_dom_dom_id_fk
			references t_domain_dom
				on delete restrict,
	cre_id int not null
		constraint tj_domain_lawyer_t_credentials_cre_cre_id_fk
			references t_credentials_cre,
	constraint tj_domain_lawyer_pk
		unique (dom_id, cre_id)
);

create type lawyer_domain_type as enum ('MAIN', 'SKILL');
alter table tj_domain_lawyer
	add type lawyer_domain_type default 'SKILL' not null;

create type education_type as enum ('CEPE', 'BEPC', 'BACCALAUREAT', 'LICENCE', 'MASTER_1', 'MASTER_2', 'DOCTORAT', 'FORMATION');
create table t_education_edu
(
	edu_id serial
		constraint t_education_edu_pk
			primary key,
	edu_name varchar(50) not null,
	edu_type education_type default 'LICENCE' not null,
	edu_year int default 2020 not null,
	edu_inserted_at timestamp default now() not null,
	edu_updated_at timestamp default now() not null,
	cre_id int not null
		constraint t_education_edu_t_credentials_cre_cre_id_fk
			references t_credentials_cre
				on delete restrict
);

create table t_contact_con
(
	con_id serial
		constraint t_contact_con_pk
			primary key,
	con_email varchar(100) not null,
	con_telephone char(9) not null,
	con_address varchar(250),
	con_facebook varchar(250),
	con_twitter varchar(250),
	con_instagram varchar(250),
	con_webiste varchar(250),
	cre_id int
		constraint t_contact_con_t_credentials_cre_cre_id_fk
			references t_credentials_cre,
	company_id int
);

create unique index t_contact_con_con_email_uindex
	on t_contact_con (con_email);

