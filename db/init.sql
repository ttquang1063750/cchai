CREATE TABLE IF NOT EXISTS `%{schema}`.`tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `%{schema}`.`columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `content_type` int(11) DEFAULT '0',
  `condition` varchar(255) DEFAULT NULL,
  `table_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `required` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_columns_on_table_id` (`table_id`),
  CONSTRAINT `fk_rails_8dd6d1aa4d` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `%{schema}`.`rows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(255) DEFAULT NULL,
  `table_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rows_on_table_id` (`table_id`),
  CONSTRAINT `fk_rails_6cea4e1fe7` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `%{schema}`.`cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `column_id` int(11) DEFAULT NULL,
  `row_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cells_on_column_id` (`column_id`),
  KEY `index_cells_on_row_id` (`row_id`),
  CONSTRAINT `fk_rails_138a7af979` FOREIGN KEY (`row_id`) REFERENCES `rows` (`id`),
  CONSTRAINT `fk_rails_1e801ec82d` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `%{schema}`.`raws` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_id` int(11) DEFAULT NULL,
  `row_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `index_raws_on_table_id` (`table_id`),
  KEY `index_raws_on_row_id` (`row_id`),
  CONSTRAINT `fk_rails_640ba36fb8` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`),
  CONSTRAINT `fk_rails_eb8eda28e0` FOREIGN KEY (`row_id`) REFERENCES `rows` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `%{schema}`.`log_changements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_email` varchar(255) DEFAULT NULL,
  `role_type` varchar(255) DEFAULT NULL,
  `page_name` varchar(255) DEFAULT NULL,
  `column_name` varchar(255) DEFAULT NULL,
  `bf_item` varchar(255) DEFAULT NULL,
  `af_item` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
