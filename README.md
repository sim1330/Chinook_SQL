SQL Solutions for Employee and Revenue Analysis
This repository contains SQL scripts designed to solve various business-related questions, focusing on employee management, revenue calculations, playlist compositions, and customer spending patterns. Each query is tailored to extract specific insights from the database.

Queries Overview
Managers with at least 2 Direct Reports

Identify managers who have at least two direct reports.
Output: employee_id of the managers.
Total Revenue for MPEG-4 Video Files in 2024

Calculate the total revenue generated from MPEG-4 video file purchases in the year 2024.
Output: total_revenue.
Composers in Classical Playlists

Count the number of distinct playlists that each composer appears in and create a comma-separated list of the playlist names.
Output: composer, distinct_playlists, list_of_playlists.
Customers with Strictly Increasing Yearly Spending

Find customers whose total yearly spending is strictly increasing over the years (excluding transactions in 2025).
Output: customer_id.
Detailed SQL Scripts
The SQL scripts are written to work with a relational database containing tables such as employee, invoice, invoice_line, track, media_type, album, playlist, playlist_track, and customer. The queries utilize JOIN operations and CTEs (Common Table Expressions) to combine data from multiple tables and perform calculations to derive the desired insights.
