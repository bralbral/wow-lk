-- Persistent service NPCs in the faction capitals and Dalaran.
-- The former manually placed Orgrimmar Warpweaver is moved into this managed set.

START TRANSACTION;

DELETE FROM `creature`
WHERE `guid` IN (5300511, 5300760, 5300761, 5300762, 5300763, 5300764, 5300765, 5300766,
                 5300767, 5300768, 5300769, 5300770, 5300771, 5300772, 5300773, 5300774,
                 5300775, 5300776)
   OR `Comment` LIKE 'wow-lk: capital %';

INSERT INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `equipment_id`,
    `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`,
    `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`,
    `dynamicflags`, `ScriptName`, `VerifiedBuild`, `CreateObject`, `Comment`
) VALUES
    -- Warpweaver (Transmogrification)
    (5300760, 190010, 0, 0, 0, 1, 1, 0, -4965.16, -921.12, 505.17, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Ironforge'),
    (5300761, 190010, 0, 0, 0, 1, 1, 0, -8818.43, 656.79, 97.46, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Stormwind'),
    (5300762, 190010, 1, 0, 0, 1, 1, 0, 9859.97, 2340.12, 1321.67, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Darnassus'),
    (5300763, 190010, 530, 0, 0, 1, 1, 0, -4024.52, -11735.50, -151.82, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Exodar'),
    -- Orgrimmar: visible central plaza beside the bank and mailbox.
    (5300764, 190010, 1, 0, 0, 1, 1, 0, 1618.50, -4395.60, 10.80, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Orgrimmar'),
    (5300765, 190010, 0, 0, 0, 1, 1, 0, 1645.07, 221.17, -56.79, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Undercity'),
    (5300766, 190010, 1, 0, 0, 1, 1, 0, -1196.16, 107.59, 134.75, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Thunder Bluff'),
    (5300767, 190010, 0, 0, 0, 1, 1, 0, -14443.40, 451.51, 4.13, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital transmog: Silvermoon'),
    -- Arena Battlemaster 1v1
    (5300768, 999991, 0, 0, 0, 1, 1, 0, -4970.96, -921.22, 505.17, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Ironforge'),
    (5300769, 999991, 0, 0, 0, 1, 1, 0, -8824.83, 656.39, 97.46, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Stormwind'),
    (5300770, 999991, 1, 0, 0, 1, 1, 0, 9853.57, 2340.42, 1321.67, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Darnassus'),
    (5300771, 999991, 530, 0, 0, 1, 1, 0, -4030.82, -11735.20, -151.82, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Exodar'),
    -- Orgrimmar: Hall of Legends PvP plaza, away from the auction house.
    (5300772, 999991, 1, 0, 0, 1, 1, 0, 1649.50, -4222.60, 56.47, 0.68, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Orgrimmar'),
    -- Dalaran Underbelly, beside the existing arena battlemaster and organizer.
    (5300776, 999991, 571, 0, 0, 1, 1, 0, 5795.50, 594.50, 610.67, 3.14, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: Dalaran 1v1 arena'),
    (5300773, 999991, 0, 0, 0, 1, 1, 0, 1651.37, 220.87, -56.79, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Undercity'),
    (5300774, 999991, 1, 0, 0, 1, 1, 0, -1202.42, 107.49, 134.75, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Thunder Bluff'),
    (5300775, 999991, 0, 0, 0, 1, 1, 0, -14449.80, 451.41, 4.13, 0.00, 300, 0, 0, 1, 0, 0, 0, 0, 0, '', NULL, 0, 'wow-lk: capital 1v1 arena: Silvermoon');

COMMIT;
