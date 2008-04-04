CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `parent_id` int(11) default NULL,
  `vat_type` varchar(255) default NULL,
  `vat_percent` decimal(10,0) default NULL,
  `account_number` varchar(255) default NULL,
  `fiscal_year_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `accounts_fiscal_year_id_fk` (`fiscal_year_id`),
  KEY `index_accounts_on_parent_id_and_account_number` (`parent_id`,`account_number`),
  CONSTRAINT `accounts_fiscal_year_id_fk` FOREIGN KEY (`fiscal_year_id`) REFERENCES `fiscal_years` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `event_lines` (
  `id` int(11) NOT NULL auto_increment,
  `event_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `amount` decimal(10,0) default NULL,
  PRIMARY KEY  (`id`),
  KEY `event_lines_event_id_fk` (`event_id`),
  KEY `event_lines_account_id_fk` (`account_id`),
  CONSTRAINT `event_lines_event_id_fk` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `event_lines_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `fiscal_year_id` int(11) default NULL,
  `receipt_number` int(11) default NULL,
  `event_date` date default NULL,
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `events_fiscal_year_id_fk` (`fiscal_year_id`),
  KEY `index_events_on_event_date` (`event_date`),
  KEY `index_events_on_receipt_number` (`receipt_number`),
  CONSTRAINT `events_fiscal_year_id_fk` FOREIGN KEY (`fiscal_year_id`) REFERENCES `fiscal_years` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `fiscal_years` (
  `id` int(11) NOT NULL auto_increment,
  `description` text,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `company_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_fiscal_years_on_start_date` (`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_info (version) VALUES (5)