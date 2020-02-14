USE misspellings;
 -- SELECT id FROM word WHERE 
 -- SOUNDEX(misspelled_word) LIKE SOUNDEX(@word) AND needle_ratio(misspelled_word, @word) > 60;

/*
WITH temp as(
SELECT * FROM  word WHERE misspelled_word LIKE concat(substring(@word, 1,1),'%'))
SELECT id FROM temp WHERE DamerauLevenschtein_ratio(misspelled_word, @word) > 67;
  */ 
WITH sound AS (
        WITH dm AS (
            SELECT dm(@word) AS d_metaphone
        )
      SELECT substring(d_metaphone, 1, 1) AS first_sound,
             substring(dm(d_metaphone), -1, 1) AS last_sound
        FROM dm
  )
SELECT DISTINCT id
  FROM word JOIN sound
 WHERE dm(misspelled_word) LIKE concat(first_sound, '%', last_sound) AND
       jaro_winkler_similarity(misspelled_word, @word) > 0.9;                                                  
                                                 
                                                     
/*
WITH temp AS (
      SELECT *,
             DamerauLevenschtein_ratio(misspelled_word, @word) AS ratio
        FROM word
       WHERE DamerauLevenschtein_ratio(misspelled_word, @word) > 67
),
       sound_like AS (
           SELECT id, concat('mis', misspelled_word) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
            UNION
           SELECT id, concat('un', misspelled_word) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
            UNION
           SELECT id, concat('in', misspelled_word) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
            UNION
           SELECT id, concat('im', misspelled_word) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
            UNION
           SELECT id, concat('anti', misspelled_word) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
            UNION
           SELECT id, substring(misspelled_word, 3) AS pre_fix
             FROM word
            WHERE SOUNDEX(@word) LIKE SOUNDEX(misspelled_word)
       )
SELECT id 
  FROM temp
 WHERE misspelled_word NOT IN (SELECT pre_fix FROM sound_like);
*/

-- SELECT id, misspelled_word FROM word WHERE jaro_winkler_similarity(misspelled_word,  @word) > 0.89;
