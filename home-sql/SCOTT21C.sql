

SELECT *
FROM (
SELECT
s.survey_no AS 번호,
s.question AS 질문,
e.grade AS 작성자,
s.start_date AS 시작일,
s.end_date AS 종료일,

(SELECT
COUNT(*) AS item_cnt
FROM survey_sub i
where s.survey_no = i.survey_no) AS 항목수,

(SELECT
COUNT(DISTINCT user_no) AS participant_cnt
FROM survey_answer a
where s.survey_no = a.survey_no)  AS 참여자수,

CASE
WHEN TRUNC(SYSDATE) < s.start_date THEN '예정'
WHEN TRUNC(SYSDATE) <= s.end_date  THEN '진행중'
ELSE '종료'
END AS 상태

FROM survey s

LEFT JOIN survey_emp e
ON s.emp_no = e.emp_no


ORDER BY s.survey_no DESC

)
-- 페이지 추가
OFFSET (:currentPage - 1) * :pageSize ROWS
FETCH NEXT :pageSize ROWS ONLY;

SELECT
    SYSDATE,
    start_date,
    end_date
FROM survey;

SELECT
    TO_CHAR(start_date, 'YYYY-MM-DD HH24:MI:SS') start_date,
    TO_CHAR(end_date, 'YYYY-MM-DD HH24:MI:SS') end_date
FROM SURVEY;

DESC SURVEY;