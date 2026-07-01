-- 관리자 인서트 문

    INSERT INTO ADMIN (
    admin_no,
    admin_id,
    admin_pw,
    admin_name,
    email,
    tel
) VALUES (
    1,
    'admin',
    'admin1234',
    '이창익',
    'admin@coupang.com',
    '010-3434-5998'
);

COMMIT;

--확인

SELECT *
FROM ADMIN;

-- <상품 대분류>

INSERT INTO MAIN_CATEGORY
(main_category_no, main_category_name, created_date, admin_no)
VALUES
(10, '패션의류/잡화', SYSDATE, 1);


INSERT INTO MAIN_CATEGORY
(main_category_no, main_category_name, created_date, admin_no)
VALUES
(11, '식품', SYSDATE, 1);

--확인

SELECT *
FROM MAIN_CATEGORY;


--<상품 중분류>

-- 패션의류/잡화 (10)

INSERT INTO MID_CATEGORY
(mid_category_no, mid_category_name, created_date, main_category_no)
VALUES
(1001, '여성패션', SYSDATE, 10);

INSERT INTO MID_CATEGORY
(mid_category_no, mid_category_name, created_date, main_category_no)
VALUES
(1002, '남성패션', SYSDATE, 10);

INSERT INTO MID_CATEGORY
(mid_category_no, mid_category_name, created_date, main_category_no)
VALUES
(1003, '남녀 공용 의류', SYSDATE, 10);

-- 식품 (11)

INSERT INTO MID_CATEGORY
(mid_category_no, mid_category_name, created_date, main_category_no)
VALUES
(1101, '건강식품', SYSDATE, 11);

INSERT INTO MID_CATEGORY
(mid_category_no, mid_category_name, created_date, main_category_no)
VALUES
(1102, '과일', SYSDATE, 11);

-- <상품 소분류>

-- 여성패션 (1001)

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100101, '의류', SYSDATE, 1001);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100102, '신발', SYSDATE, 1001);


-- 남성패션 (1002)

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100201, '의류', SYSDATE, 1002);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100202, '신발', SYSDATE, 1002);


-- 남녀공용 (1003)

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100301, '티셔츠', SYSDATE, 1003);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100302, '셔츠', SYSDATE, 1003);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(100303, '바지', SYSDATE, 1003);


-- 건강식품 (1101)

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(110101, '영양식/선식', SYSDATE, 1101);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(110102, '어린이 건강식품', SYSDATE, 1101);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(110103, '꿀/프로폴리스', SYSDATE, 1101);


-- 과일 (1102)

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(110201, '사과/배', SYSDATE, 1102);

INSERT INTO SUB_CATEGORY
(sub_category_no, sub_category_name, created_date, mid_category_no)
VALUES
(110202, '과일선물세트', SYSDATE, 1102);


SELECT *
FROM MID_CATEGORY

--

SELECT *
FROM SUB_CATEGORY

COMMIT;

SELECT *
FROM ADMIN;

SELECT *
FROM PRODUCT_IN;

SELECT *
FROM SELLER;

-- PRODUCT 테이블


INSERT INTO PRODUCT
(
    product_no,
    product_name,
    product_desc,
    product_price,
    quantity,
    seller_no,
    sub_category_no
)
VALUES
(
    6,
    '여성 티셔츠',
    '부드럽고 쫀쫀한 기본 면 티셔츠',
    15000,
    100,
    1,
    100101
);

INSERT INTO PRODUCT
(
    product_no,
    product_name,
    product_desc,
    product_price,
    quantity,
    seller_no,
    sub_category_no
)
VALUES
(
    7,
    '과일선물세트',
    '프리미엄 혼합과일 선물용으로 아주 적합',
    55000,
    30,
    5,
    110202
);

INSERT INTO PRODUCT
(
    product_no,
    product_name,
    product_desc,
    product_price,
    quantity,
    seller_no,
    sub_category_no
)
VALUES
(
    8,
    '남성 운동화',
    '일상 생활 데일리 필수품 스니커즈',
    50000,
    50,
    3,
    100202
);

