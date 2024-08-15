/*
Question #1:
Write a solution to find the employee_id of managers with at least 2 direct reports.


Expected column names: employee_id

*/

-- q1 solution:

SELECT
    e.employee_id
FROM
    employee e
JOIN
    (
    SELECT
        reports_to,
        COUNT(*) AS num_reports
    FROM
        employee
    GROUP BY
        reports_to
    HAVING
        COUNT(*) >= 2
    ) AS m ON e.employee_id = m.reports_to;


/*

Question #2: 
Calculate total revenue for MPEG-4 video files purchased in 2024.

Expected column names: total_revenue

*/

-- q2 solution:

SELECT
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM
    invoice_line il
JOIN
    invoice i ON il.invoice_id = i.invoice_id
JOIN
    track t ON il.track_id = t.track_id
JOIN
    media_type mt ON t.media_type_id = mt.media_type_id
WHERE
    mt.media_type_id = 3
    AND EXTRACT(YEAR FROM i.invoice_date) = 2024;

/*
Question #3: 
For composers appearing in classical playlists, count the number of distinct playlists they appear on and 
create a comma separated list of the corresponding (distinct) playlist names.

Expected column names: composer, distinct_playlists, list_of_playlists

*/

-- q3 solution:

SELECT
    t.composer AS composer,
    COUNT(DISTINCT pl.name) AS distinct_playlists,
    COALESCE(STRING_AGG(subquery.playlist_names, ', '), '') AS list_of_playlists
FROM
    track t
JOIN
    album a ON a.album_id = t.album_id
JOIN
    playlist_track plt ON t.track_id = plt.track_id
JOIN
    playlist pl ON pl.playlist_id = plt.playlist_id
JOIN (
    SELECT
        plt2.track_id,
        STRING_AGG(pl2.name, ', ') AS playlist_names
    FROM
        playlist_track plt2
    JOIN
        playlist pl2 ON plt2.playlist_id = pl2.playlist_id
    WHERE
        pl2.name LIKE 'Classical%'
    GROUP BY
        plt2.track_id
) AS subquery ON t.track_id = subquery.track_id
WHERE
    pl.name LIKE 'Classical%'
    AND t.composer IS NOT NULL
GROUP BY
    t.composer;

/*
Question #4: 
Find customers whose yearly total spending is strictly increasing*.


*read the hints!


Expected column names: customer_id
*/

-- q4 solution:

WITH yearly_spending AS (
    SELECT
        i.customer_id,
        EXTRACT(YEAR FROM i.invoice_date) AS year,
        SUM(i.total) AS total_spending
    FROM
        invoice i
    LEFT JOIN customer c ON i.customer_id = c.customer_id
    WHERE
        EXTRACT(YEAR FROM invoice_date) < 2025 -- Exclude transactions in 2025
    GROUP BY
        i.customer_id,
        EXTRACT(YEAR FROM invoice_date)
),
inc_rev AS (
    SELECT 
        cy.customer_id,
        cy.year,
        CASE 
            WHEN cy.total_spending > COALESCE(MAX(ny.total_spending), 0) THEN 1 
            ELSE 0 
        END AS inc_rev_f1
    FROM yearly_spending cy
    LEFT JOIN yearly_spending ny ON cy.customer_id = ny.customer_id AND cy.year > ny.year
    GROUP BY 
        cy.customer_id, 
        cy.year, 
        cy.total_spending
)
SELECT 
    customer_id
FROM 
    inc_rev
GROUP BY 
    customer_id
HAVING 
    COUNT(*) >= 2 -- Customers with at least two transaction years
    AND SUM(inc_rev_f1) = COUNT(*); -- Ensure all years show increase

