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

SELECT *
FROM SUB_CATEGORY

--
ALTER TABLE PRODUCT
DROP COLUMN CATEGORY_CODE;


--------------

--✅ ① 입고 트리거 (PRODUCT_IN → 재고 증가 + 로그)
CREATE OR REPLACE TRIGGER TRG_PRODUCT_IN
AFTER INSERT ON PRODUCT_IN
FOR EACH ROW
DECLARE
    v_seller_no SELLER.seller_no%TYPE;
BEGIN

    -- SELLER 찾기 (옵션 기준 연결이 있다고 가정)
    SELECT seller_no
    INTO v_seller_no
    FROM PRODUCT_OPTION
    WHERE option_id = :NEW.option_id;

    -- 재고 증가 (PRODUCT_OPTION 기준이라고 가정)
    UPDATE PRODUCT_OPTION
    SET quantity = quantity + :NEW.quantity
    WHERE option_id = :NEW.option_id;

    -- 히스토리 기록
    INSERT INTO STOCK_HISTORY (
        history_id,
        seller_no,
        option_id,
        change_type,
        quantity,
        reason,
        reg_date
    )
    VALUES (
        SEQ_STOCK_HISTORY.NEXTVAL,
        v_seller_no,
        :NEW.option_id,
        'IN',
        :NEW.quantity,
        '입고',
        SYSDATE
    );

END;

--✅ ② 반품 트리거 (PRODUCT_RETURN → 재고 증가)
CREATE OR REPLACE TRIGGER TRG_PRODUCT_RETURN
AFTER INSERT ON PRODUCT_RETURN
FOR EACH ROW
DECLARE
    v_option_id PRODUCT_OPTION.option_id%TYPE;
    v_seller_no SELLER.seller_no%TYPE;
BEGIN

    -- 주문상세에서 옵션 찾기 (구조 기준)
    SELECT po.option_id, po.seller_no
    INTO v_option_id, v_seller_no
    FROM ORDER_DETAIL od
    JOIN PRODUCT_OPTION po
      ON od.option_id = po.option_id
    WHERE od.order_detail_no = :NEW.order_detail_no;

    -- 재고 복구
    UPDATE PRODUCT_OPTION
    SET quantity = quantity + :NEW.return_qty
    WHERE option_id = v_option_id;

    -- 로그 기록
    INSERT INTO STOCK_HISTORY (
        history_id,
        seller_no,
        option_id,
        change_type,
        quantity,
        reason,
        reg_date
    )
    VALUES (
        SEQ_STOCK_HISTORY.NEXTVAL,
        v_seller_no,
        v_option_id,
        'RETURN',
        :NEW.return_qty,
        :NEW.return_reason,
        SYSDATE
    );

END;

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
    1,
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
    2,
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
    3,
    '남성 운동화',
    '일상 생활 데일리 필수품 스니커즈',
    50000,
    50,
    3,
    100202
);

--------------------------------------------------------------------------------
-- 판매자--

--시퀀스 삭제(뭔가 잘못해서 다시 만드는 경우)
DROP SEQUENCE SEQ_SELLER;

-- 시퀀스 생성--
CREATE SEQUENCE SEQ_SELLER
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- 기존 데이터 있으면 삭제 -- 
DELETE FROM SELLER;
COMMIT; 
--

-- 판매자 정보 20건 INSERT -- 
INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '서울시 강남구 테헤란로 123', '110-234-567890', '110-22-33331', '청담클로짓', '국민은행', 'seller01', 'pw1234', '김민준', '010-1111-2222', 'seller01@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '경기도 성남시 분당구 판교로 45', '302-567890-123', '220-33-44442', '미니멀무드', '농협은행', 'seller02', 'dskdjk', '이서연', '010-2222-3333', 'seller02@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '서울시 송파구 올림픽로 300', '112-345678-90', '330-44-55553', '데일리핏', '신한은행', 'seller03', 'sfjier', '박지훈', '010-3333-4444', 'seller03@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '인천시 연수구 송도동 12', '556-01-234567', '440-55-66664', '송도뷰티', '우리은행', 'seller04', 'tueoriw12', '최유진', '010-4444-5555', 'seller04@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '대구시 수성구 범어동 88', '765-432-109876', '550-66-77775', '수성패션', '하나은행', 'seller05', 'weriopjo145', '정하늘', '010-5555-6666', 'seller05@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '경기도 수원시 영통구 광교로 5', '901-234-567890', '770-88-99997', '어반라인', '카카오뱅크', 'seller06', 'vmk4589', '오지우', '010-7777-8888', 'seller06@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '부산시 해운대구 센텀로 99', '123-456-789012', '660-77-88886', '센텀키친', '기업은행', 'seller07', 'etjk9090', '한도윤', '010-6666-7777', 'seller07@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '서울시 마포구 홍대입구역 22', '234-567-890123', '880-99-10008', '우리농산', '토스뱅크', 'seller08', 'erk3590s', '윤서준', '010-8888-9999', 'seller08@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '광주시 서구 상무대로 77', '345-678-901234', '990-10-11119', '로컬푸드팜', '광주은행', 'seller09', 'njk687', '장하윤', '010-9999-0000', 'seller09@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '대전시 유성구 대학로 33', '456-789-012345', '111-22-12220', '엄마밥상', '대전은행', 'seller10', 'lko090', '임채원', '010-1010-2020', 'seller10@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '울산시 남구 삼산로 15', '567-890-123456', '222-33-13331', '삼산푸드', '농협은행', 'seller11', '3490wrdf', '강은우', '010-1111-3333', 'seller11@test.com');

INSERT INTO SELLER (seller_no, business_address, settlement_account, business_no, store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email)
VALUES (SEQ_SELLER.NEXTVAL, '경남 창원시 성산구 중앙대로 20', '901-234-567891', '666-77-17775', '창원식품', '경남은행', 'seller12', 'po189989', '문지안', '010-1515-7777', 'seller12@test.com');

COMMIT;

--------------------------------------------------------------------------------
SELECT * FROM seller;
--------------------------------------------------------------------------------
