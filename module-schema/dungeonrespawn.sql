CREATE TABLE IF NOT EXISTS `dungeonrespawn_playerinfo` (
  `guid` bigint(20) unsigned DEFAULT NULL,
  `map` int(11) DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `o` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET @has_primary_key := (
  SELECT COUNT(*)
  FROM information_schema.table_constraints
  WHERE table_schema = DATABASE()
    AND table_name = 'dungeonrespawn_playerinfo'
    AND constraint_type = 'PRIMARY KEY'
);
SET @migration := IF(
  @has_primary_key = 0,
  'ALTER TABLE `dungeonrespawn_playerinfo` MODIFY `guid` BIGINT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY',
  'SELECT 1'
);
PREPARE migration_statement FROM @migration;
EXECUTE migration_statement;
DEALLOCATE PREPARE migration_statement;
