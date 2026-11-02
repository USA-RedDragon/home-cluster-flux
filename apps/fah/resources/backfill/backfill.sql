BEGIN IMMEDIATE;
UPDATE donors SET baseline_score = 185605268, baseline_wus = 626, baseline_error = 0 WHERE id = 281625181 AND baseline_score = 0;
COMMIT;
SELECT id, name, baseline_score, baseline_wus, baseline_error FROM donors WHERE id = 281625181;
