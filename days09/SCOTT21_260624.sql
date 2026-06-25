--DB 모델링
-- 비디오 샵 DB 모델링
-- 팀 세미 프로젝트 실습

INSERT 

-- 직원
INSERT INTO 직원 (직원번호, 등급)
VALUES (1001  , '관리자');

-- 회원
INSERT INTO 회원 (회원번호, 이름)
VALUES (1, '홍길동');

INSERT INTO 회원 (회원번호, 이름)
VALUES (2, '김철수');


-- 설문주제
INSERT INTO 설문주제
(설문번호, 질문, 시작일, 종료일, 등록일, 등록자)
VALUES
(1, '좋아하는 색은?', '2025-06-01', '2025-06-30', '2025-06-01', 1001);

-- 설문항목
INSERT INTO 설문항목
(설문번호, 항목번호, 항목내용)
VALUES
(1, 1, '노란색');

INSERT INTO 설문항목
(설문번호, 항목번호, 항목내용)
VALUES
(1, 2, '빨간색');

INSERT INTO 설문항목
(설문번호, 항목번호, 항목내용)
VALUES
(1, 3, '핑크색');

-- 답변(투표)
INSERT INTO 답변
(회원번호, 설문번호, 답변번호)
VALUES
(1, 1, 2);

INSERT INTO 답변
(회원번호, 설문번호, 답변번호)
VALUES
(2, 1, 1);


SELECT * FROM SURVEY;

SELECT * FROM survey;
SELECT * FROM survey_answer;
SELECT * FROM survey_emp;
SELECT * FROM survey_sub;
SELECT * FROM survey_user;

ALTER TABLE survey_answer
ADD 
	CONSTRAINT PK_survey_answer PRIMARY 
	KEY (
		user_no, survey_no
	);		


-- 설문 등록 (1건)
INSERT INTO survey (survey_no, question, start_date, end_date, emp_no)
VALUES (1, '좋아하는 색은 무슨색인가요?', SYSDATE, SYSDATE + 7, 1);

-- 설문항목 등록 (5건)
INSERT INTO survey_sub VALUES (1, 1, '빨간색');
INSERT INTO survey_sub VALUES (2, 1, '파란색');
INSERT INTO survey_sub VALUES (3, 1, '노란색');
INSERT INTO survey_sub VALUES (4, 1, '흰색');
INSERT INTO survey_sub VALUES (5, 1, '검은색');

INSERT INTO survey_answer VALUES (1001, 1, 1); -- 빨간색
INSERT INTO survey_answer VALUES (1002, 3, 1); -- 노란색
INSERT INTO survey_answer VALUES (1003, 2, 1); -- 파란색
INSERT INTO survey_answer VALUES (1004, 5, 1); -- 검은색
INSERT INTO survey_answer VALUES (1005, 1, 1); -- 빨간색
INSERT INTO survey_answer VALUES (1006, 4, 1); -- 흰색
INSERT INTO survey_answer VALUES (1007, 2, 1); -- 파란색
INSERT INTO survey_answer VALUES (1008, 3, 1); -- 노란색
INSERT INTO survey_answer VALUES (1009, 5, 1); -- 검은색
INSERT INTO survey_answer VALUES (1010, 1, 1); -- 빨간색
-- 설문 등록 (1건)
INSERT INTO survey (survey_no, question, start_date, end_date, emp_no)
VALUES (2, '가장 좋아하는 여자 연예인은?', SYSDATE, SYSDATE + 3, 1);

-- 설문항목 등록 (6건)
INSERT INTO survey_sub VALUES (1, 2, '배슬기');
INSERT INTO survey_sub VALUES (2, 2, '김옥빈');
INSERT INTO survey_sub VALUES (3, 2, '아이비 꺄~~ 사.랑.해.요 아.이.비.');
INSERT INTO survey_sub VALUES (4, 2, '한효주');
INSERT INTO survey_sub VALUES (5, 2, '김선아');
INSERT INTO survey_sub VALUES (6, 2, '아이유');



----설문 목록 출력

CREATE SEQUENCE seq_survey_no START WITH 3;

-- 설문 등록 3 
INSERT INTO survey (
    survey_no,
    question,
    start_date,
    end_date,
    emp_no
)
VALUES (
    seq_survey_no.NEXTVAL,
    '가장 좋아하는 한식은 무엇인가요?',
    SYSDATE,
    SYSDATE + 7,
    1
);

INSERT INTO survey_sub VALUES (1, seq_survey_no.CURRVAL, '비빔밥');
INSERT INTO survey_sub VALUES (2, seq_survey_no.CURRVAL, '불고기');
INSERT INTO survey_sub VALUES (3, seq_survey_no.CURRVAL, '김치찌개');



-- 설문 등록 4

INSERT INTO survey (
    survey_no,
    question,
    start_date,
    end_date,
    emp_no
)
VALUES (
    seq_survey_no.NEXTVAL,
    '가장 좋아하는 날씨는 무엇인가요?',
    SYSDATE,
    SYSDATE + 7,
    1
);

INSERT INTO survey_sub VALUES (1, seq_survey_no.CURRVAL, '맑음');
INSERT INTO survey_sub VALUES (2, seq_survey_no.CURRVAL, '흐림');
INSERT INTO survey_sub VALUES (3, seq_survey_no.CURRVAL, '눈');



-- 설문 등록 5

INSERT INTO survey (
    survey_no,
    question,
    start_date,
    end_date,
    emp_no
)
VALUES (
    seq_survey_no.NEXTVAL,
    '가장 가지고 싶은 초능력은 무엇인가요?',
    SYSDATE,
    SYSDATE + 7,
    1
);

INSERT INTO survey_sub VALUES (1, seq_survey_no.CURRVAL, '순간이동');
INSERT INTO survey_sub VALUES (2, seq_survey_no.CURRVAL, '투명인간');
INSERT INTO survey_sub VALUES (3, seq_survey_no.CURRVAL, '시간조작');

--설문 목록보기

SELECT
    s.survey_no AS 번호,
    s.question AS 질문,
    e.grade AS 작성자,
    s.start_date AS 시작일,
    s.end_date AS 종료일,

    NVL(i.item_cnt, 0) AS 항목수,
    NVL(a.participant_cnt, 0) AS 참여자수,

    CASE
        WHEN SYSDATE < s.start_date THEN '예정'
        WHEN SYSDATE BETWEEN s.start_date AND s.end_date THEN '진행중'
        ELSE '종료'
    END AS 상태

FROM survey s

LEFT JOIN survey_emp e
    ON s.emp_no = e.emp_no

LEFT JOIN (
    SELECT
        survey_no,
        COUNT(*) AS item_cnt
    FROM survey_sub
    GROUP BY survey_no
) i
    ON s.survey_no = i.survey_no

LEFT JOIN (
    SELECT
        survey_no,
        COUNT(DISTINCT user_no) AS participant_cnt
    FROM survey_answer
    GROUP BY survey_no
) a
    ON s.survey_no = a.survey_no

ORDER BY s.survey_no DESC;

--- 페이지 추가

SELECT *
FROM (
    SELECT
        s.survey_no AS 번호,
        s.question AS 질문,
        e.grade AS 작성자,
        s.start_date AS 시작일,
        s.end_date AS 종료일,

        NVL(i.item_cnt, 0) AS 항목수,
        NVL(a.participant_cnt, 0) AS 참여자수,

        CASE
            WHEN SYSDATE < s.start_date THEN '예정'
            WHEN SYSDATE BETWEEN s.start_date AND s.end_date THEN '진행중'
            ELSE '종료'
        END AS 상태

    FROM survey s

    LEFT JOIN survey_emp e
        ON s.emp_no = e.emp_no

    LEFT JOIN (
        SELECT survey_no, COUNT(*) AS item_cnt
        FROM survey_sub
        GROUP BY survey_no
    ) i
        ON s.survey_no = i.survey_no

    LEFT JOIN (
        SELECT survey_no, COUNT(DISTINCT user_no) AS participant_cnt
        FROM survey_answer
        GROUP BY survey_no
    ) a
        ON s.survey_no = a.survey_no

    ORDER BY s.survey_no DESC
)
OFFSET (:currentPage - 1) * :pageSize ROWS
FETCH NEXT :pageSize ROWS ONLY;
