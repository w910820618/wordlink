-- Ensure word data tables are in LPT_english schema.
-- 20260213120500_move_auth_tables_to_lpt_english only moved the user tables, so on a fresh
-- database the word tables stayed in public and add_word_relation failed on "LPT_english"."words".
-- This is safe to run multiple times; it is a no-op where the tables were already moved.

CREATE SCHEMA IF NOT EXISTS "LPT_english";

DO $$
DECLARE
    current_table TEXT;
    tables_to_move TEXT[] := ARRAY[
        'words',
        'word_markdown',
        'word_chinese',
        'word_ecdict',
        'word_fission'
    ];
BEGIN
    FOREACH current_table IN ARRAY tables_to_move
    LOOP
        IF EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public'
              AND table_name = current_table
        )
        AND NOT EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'LPT_english'
              AND table_name = current_table
        ) THEN
            EXECUTE format('ALTER TABLE "public".%I SET SCHEMA "LPT_english"', current_table);
        END IF;
    END LOOP;
END $$;
