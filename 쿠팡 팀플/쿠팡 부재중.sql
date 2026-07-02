
DROP TABLE STOCK_HISTORY          CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT_INQUIRY_ANSWER CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT_INQUIRY        CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT_OPTION         CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT_RETURN         CASCADE CONSTRAINTS PURGE;
DROP TABLE CART                   CASCADE CONSTRAINTS PURGE;
DROP TABLE WISHLIST               CASCADE CONSTRAINTS PURGE;
DROP TABLE REVIEW                 CASCADE CONSTRAINTS PURGE;
DROP TABLE ORDER_DETAIL           CASCADE CONSTRAINTS PURGE;
DROP TABLE PAYMENT                CASCADE CONSTRAINTS PURGE;
DROP TABLE DELIVERY               CASCADE CONSTRAINTS PURGE;
DROP TABLE ORDERS                 CASCADE CONSTRAINTS PURGE;
DROP TABLE DELIVERY_ADDRESS       CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT                CASCADE CONSTRAINTS PURGE;
DROP TABLE SUB_CATEGORY           CASCADE CONSTRAINTS PURGE;
DROP TABLE MID_CATEGORY           CASCADE CONSTRAINTS PURGE;
DROP TABLE MAIN_CATEGORY          CASCADE CONSTRAINTS PURGE;
DROP TABLE SELLER                 CASCADE CONSTRAINTS PURGE;
DROP TABLE MEMBER                 CASCADE CONSTRAINTS PURGE;
DROP TABLE ADMIN                  CASCADE CONSTRAINTS PURGE;
DROP TABLE PRODUCT_IN             CASCADE CONSTRAINTS PURGE;

/* ============================================================
   테이블 생성
   ============================================================ */

/* 상품 */
CREATE TABLE PRODUCT (
	product_no NUMBER(10) NOT NULL, /* 상품번호 */
	product_name VARCHAR2(100) NOT NULL, /* 상품명 */
	product_desc VARCHAR2(3000) NOT NULL, /* 상품설명 */
	product_price NUMBER(10) NOT NULL, /* 상품금액 */
	quantity NUMBER(10) NOT NULL, /* 수량 */
	seller_no NUMBER(10) NOT NULL, /* 판매자번호 */
	sub_category_no NUMBER(10) NOT NULL /* 소분류 번호 */
);

CREATE UNIQUE INDEX PK_PRODUCT
	ON PRODUCT (
		product_no ASC
	);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT PK_PRODUCT
		PRIMARY KEY (
			product_no
		);

/* 배송 */
CREATE TABLE DELIVERY (
	delivery_no NUMBER(10) NOT NULL, /* 배송번호 */
	order_no NUMBER(10) NOT NULL, /* 주문번호 */
	delivery_service_code VARCHAR2(20) NOT NULL, /* 택배사코드 */
	invoice_no VARCHAR2(30) NOT NULL, /* 송장번호 */
	delivery_status VARCHAR2(20) NOT NULL, /* 배송상태 */
	delivery_start_date DATE NOT NULL, /* 배송시작일시 */
	delivery_end_date DATE NOT NULL /* 배송완료일시 */
);

CREATE UNIQUE INDEX PK_DELIVERY
	ON DELIVERY (
		delivery_no ASC
	);

ALTER TABLE DELIVERY
	ADD
		CONSTRAINT PK_DELIVERY
		PRIMARY KEY (
			delivery_no
		);

/* 주문 */
CREATE TABLE ORDERS (
	order_no NUMBER(10) NOT NULL, /* 주문번호 */
	member_no NUMBER(10) NOT NULL, /* 회원번호 */
	address_no NUMBER(10) NOT NULL, /* 배송지번호 */
	order_date DATE NOT NULL, /* 구매일 */
	payment_method VARCHAR2(20) NOT NULL, /* 결제방법 */
	delivery_fee NUMBER(10) NOT NULL, /* 배송비 */
	total_price NUMBER(10) NOT NULL, /* 최종결제금액 */
	order_status VARCHAR2(20) NOT NULL /* 주문상태 */
);

CREATE UNIQUE INDEX PK_ORDERS
	ON ORDERS (
		order_no ASC
	);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT PK_ORDERS
		PRIMARY KEY (
			order_no
		);

/* 배송지 */
CREATE TABLE DELIVERY_ADDRESS (
	address_no NUMBER(10) NOT NULL, /* 배송지번호 */
	member_no NUMBER(10) NOT NULL, /* 회원번호 */
	receiver_name VARCHAR2(30) NOT NULL, /* 수령인 */
	tel VARCHAR2(20) NOT NULL, /* 연락처 */
	zipcode VARCHAR2(10) NOT NULL, /* 우편번호 */
	address VARCHAR2(200) NOT NULL, /* 기본주소 */
	detail_address VARCHAR2(200) NOT NULL, /* 상세주소 */
	request_msg VARCHAR2(200) NOT NULL, /* 배송요청사항 */
	address_default CHAR(1) NOT NULL /* 기본 배송지여부 */
);

CREATE UNIQUE INDEX PK_DELIVERY_ADDRESS
	ON DELIVERY_ADDRESS (
		address_no ASC
	);

ALTER TABLE DELIVERY_ADDRESS
	ADD
		CONSTRAINT PK_DELIVERY_ADDRESS
		PRIMARY KEY (
			address_no
		);

/* 주문상세 */
CREATE TABLE ORDER_DETAIL  (
	order_detail_no NUMBER(10) NOT NULL, /* 주문상세번호 */
	order_no NUMBER(10) NOT NULL, /* 주문번호 */
	product_no NUMBER(10) NOT NULL, /* 상품번호 */
	order_qty NUMBER(5) NOT NULL, /* 주문수량 */
	price NUMBER(10) NOT NULL, /* 가격 */
	OPTION_ID NUMBER(10) /* 재고번호 */
);

CREATE UNIQUE INDEX PK_ORDER_DETAIL
	ON ORDER_DETAIL  (
		order_detail_no ASC
	);

ALTER TABLE ORDER_DETAIL
	ADD
		CONSTRAINT PK_ORDER_DETAIL
		PRIMARY KEY (
			order_detail_no
		);

/* 회원 */
CREATE TABLE MEMBER (
	member_no NUMBER(10) NOT NULL, /* 회원번호 */
	member_id VARCHAR2(50) NOT NULL, /* 회원아이디 */
	member_pw VARCHAR2(100) NOT NULL, /* 비밀번호 */
	member_name VARCHAR2(30) NOT NULL, /* 이름 */
	phone VARCHAR2(20) NOT NULL, /* 전화번호 */
	email VARCHAR2(100) NOT NULL, /* 이메일 */
	rank VARCHAR2(20) NOT NULL /* 등급 */
);

CREATE UNIQUE INDEX PK_MEMBER
	ON MEMBER (
		member_no ASC
	);

ALTER TABLE MEMBER
	ADD
		CONSTRAINT PK_MEMBER
		PRIMARY KEY (
			member_no
		);

/* 장바구니 */
CREATE TABLE CART (
	member_no NUMBER(10), /* 회원번호 */
	OPTION_ID NUMBER(10) /* 재고번호 */
);

/* 찜하기 */
CREATE TABLE WISHLIST (
	member_no NUMBER(10), /* 회원번호 */
	OPTION_ID NUMBER(10) /* 재고번호 */
);

/* 판매자 */
CREATE TABLE SELLER (
	seller_no NUMBER(10) NOT NULL, /* 판매자번호 */
	business_address VARCHAR2(100) NOT NULL, /* 사업장주소 */
	settlement_account VARCHAR2(50) NOT NULL, /* 정산계좌 */
	business_no VARCHAR2(20) NOT NULL, /* 사업자등록번호 */
	store_name VARCHAR2(100) NOT NULL, /* 상호명 */
	bank_name VARCHAR2(30) NOT NULL, /* 은행명 */
	seller_id VARCHAR2(50) NOT NULL, /* 아이디 */
	seller_pw VARCHAR2(100) NOT NULL, /* 비밀번호 */
	ceo_name VARCHAR2(30) NOT NULL, /* 대표자명 */
	tel VARCHAR2(20) NOT NULL, /* 전화번호 */
	email VARCHAR2(100) NOT NULL /* 이메일 */
);

CREATE UNIQUE INDEX PK_SELLER
	ON SELLER (
		seller_no ASC
	);

ALTER TABLE SELLER
	ADD
		CONSTRAINT PK_SELLER
		PRIMARY KEY (
			seller_no
		);

/* 결제-회원 */
CREATE TABLE PAYMENT (
	payment_no NUMBER(10) NOT NULL, /* 결제번호 */
	payment_date DATE NOT NULL, /* 결제일시 */
	payment_amount NUMBER(10) NOT NULL, /* 결제금액 */
	order_no NUMBER(10) NOT NULL, /* 주문번호 */
	member_no NUMBER(10) NOT NULL /* 회원번호 */
);

CREATE UNIQUE INDEX PK_PAYMENT
	ON PAYMENT (
		payment_no ASC
	);

ALTER TABLE PAYMENT
	ADD
		CONSTRAINT PK_PAYMENT
		PRIMARY KEY (
			payment_no
		);

/* 리뷰 */
CREATE TABLE REVIEW (
	review_no NUMBER(10) NOT NULL, /* 리뷰번호 */
	rating NUMBER(2) NOT NULL, /* 별점 */
	review_content VARCHAR2(1000) NOT NULL, /* 리뷰내용 */
	review_date DATE NOT NULL, /* 작성일 */
	product_no NUMBER(10) NOT NULL, /* 상품번호 */
	member_no NUMBER(10) NOT NULL /* 회원번호 */
);

CREATE UNIQUE INDEX PK_REVIEW
	ON REVIEW (
		review_no ASC
	);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT PK_REVIEW
		PRIMARY KEY (
			review_no
		);

/* 관리자 */
CREATE TABLE ADMIN  (
	admin_no NUMBER(10) NOT NULL, /* 관리자 번호 */
	admin_id VARCHAR2(50) NOT NULL, /* 아이디 */
	admin_pw VARCHAR2(100) NOT NULL, /* 비밀번호 */
	admin_name VARCHAR2(30) NOT NULL, /* 이름 */
	email VARCHAR2(100) NOT NULL, /* 이메일 */
	tel VARCHAR2(20) NOT NULL /* 연락처 */
);

CREATE UNIQUE INDEX PK_ADMIN 
	ON ADMIN  (
		admin_no ASC
	);

ALTER TABLE ADMIN 
	ADD
		CONSTRAINT PK_ADMIN 
		PRIMARY KEY (
			admin_no
		);

/* 상품 대분류 */
CREATE TABLE MAIN_CATEGORY (
	main_category_no NUMBER(10) NOT NULL, /* 대분류 번호 */
	main_category_name VARCHAR2(50) NOT NULL, /* 대분류명 */
	created_date DATE NOT NULL, /* 등록일 */
	admin_no NUMBER(10) NOT NULL /* 관리자 번호 */
);

CREATE UNIQUE INDEX PK_MAIN_CATEGORY
	ON MAIN_CATEGORY (
		main_category_no ASC
	);

ALTER TABLE MAIN_CATEGORY
	ADD
		CONSTRAINT PK_MAIN_CATEGORY
		PRIMARY KEY (
			main_category_no
		);

/* 상품 소분류 */
CREATE TABLE SUB_CATEGORY (
	sub_category_no NUMBER(10) NOT NULL, /* 소분류 번호 */
	sub_category_name VARCHAR2(50) NOT NULL, /* 소분류명 */
	created_date DATE NOT NULL, /* 등록일 */
	mid_category_no NUMBER(10) NOT NULL /* 중분류 번호 */
);

CREATE UNIQUE INDEX PK_SUB_CATEGORY
	ON SUB_CATEGORY (
		sub_category_no ASC
	);

ALTER TABLE SUB_CATEGORY
	ADD
		CONSTRAINT PK_SUB_CATEGORY
		PRIMARY KEY (
			sub_category_no
		);

/* 상품 중분류 */
CREATE TABLE MID_CATEGORY (
	mid_category_no NUMBER(10) NOT NULL, /* 중분류 번호 */
	mid_category_name VARCHAR2(50) NOT NULL, /* 중분류명 */
	created_date DATE NOT NULL, /* 등록일 */
	main_category_no NUMBER(10) NOT NULL /* 대분류 번호 */
);

CREATE UNIQUE INDEX PK_MID_CATEGORY
	ON MID_CATEGORY (
		mid_category_no ASC
	);

ALTER TABLE MID_CATEGORY
	ADD
		CONSTRAINT PK_MID_CATEGORY
		PRIMARY KEY (
			mid_category_no
		);

/* 반품 */
CREATE TABLE PRODUCT_RETURN (
	return_no NUMBER(10) NOT NULL, /* 반품번호 */
	request_date DATE NOT NULL, /* 반품 신청 날짜 */
	return_qty NUMBER(5) NOT NULL, /* 반품 수량 */
	return_reason VARCHAR2(200) NOT NULL, /* 반품 사유 */
	return_status VARCHAR2(20) NOT NULL, /* 반품 상태 */
	refund_amount NUMBER(10) NOT NULL, /* 환불금액 */
	order_detail_no NUMBER(10) NOT NULL /* 주문상세번호 */
);

CREATE UNIQUE INDEX PK_PRODUCT_RETURN
	ON PRODUCT_RETURN (
		return_no ASC
	);

ALTER TABLE PRODUCT_RETURN
	ADD
		CONSTRAINT PK_PRODUCT_RETURN
		PRIMARY KEY (
			return_no
		);

/* 상품 문의 */
CREATE TABLE PRODUCT_INQUIRY  (
	inquiry_no NUMBER(10) NOT NULL, /* 문의번호 */
	inquiry_content VARCHAR2(500) NOT NULL, /* 문의내용 */
	inquiry_date DATE NOT NULL, /* 문의등록일 */
	member_no NUMBER(10) NOT NULL, /* 회원번호 */
	OPTION_ID NUMBER(10) NOT NULL /* 재고번호 */
);

CREATE UNIQUE INDEX PK_PRODUCT_INQUIRY 
	ON PRODUCT_INQUIRY  (
		inquiry_no ASC
	);

ALTER TABLE PRODUCT_INQUIRY 
	ADD
		CONSTRAINT PK_PRODUCT_INQUIRY 
		PRIMARY KEY (
			inquiry_no
		);

/* 문의 답변 */
CREATE TABLE PRODUCT_INQUIRY_ANSWER (
	answer_no NUMBER(10) NOT NULL, /* 답변번호 */
	answer_content VARCHAR2(1000) NOT NULL, /* 답변내용 */
	answer_date DATE NOT NULL, /* 답변일 */
	inquiry_no NUMBER(10) NOT NULL, /* 문의번호 */
	seller_no NUMBER(10) NOT NULL /* 판매자번호 */
);

CREATE UNIQUE INDEX PK_PRODUCT_INQUIRY_ANSWER
	ON PRODUCT_INQUIRY_ANSWER (
		answer_no ASC
	);

ALTER TABLE PRODUCT_INQUIRY_ANSWER
	ADD
		CONSTRAINT PK_PRODUCT_INQUIRY_ANSWER
		PRIMARY KEY (
			answer_no
		);

/* 상품재고상태 */
CREATE TABLE PRODUCT_OPTION (
	OPTION_ID NUMBER(10) NOT NULL, /* 재고번호 */
	product_no NUMBER(10), /* 상품번호 */
	OPTION1_TYPE VARCHAR2(50), /* 옵션타입1 */
	OPTION1_VALUE VARCHAR2(100), /* 옵션이름1 */
	OPTION2_TYPE VARCHAR2(50), /* 옵션타입2 */
	OPTION2_VALUE VARCHAR2(100), /* 옵션이름2 */
	OPTION3_TYPE VARCHAR2(50), /* 옵션타입3 */
	OPTION3_VALUE VARCHAR2(100), /* 옵션이름3 */
	PRICE NUMBER, /* 금액 */
	quantity NUMBER, /* 보유수량 */
	STATUS CHAR(1) /* 상태 */
);

CREATE UNIQUE INDEX PK_PRODUCT_OPTION
	ON PRODUCT_OPTION (
		OPTION_ID ASC
	);

ALTER TABLE PRODUCT_OPTION
	ADD
		CONSTRAINT PK_PRODUCT_OPTION
		PRIMARY KEY (
			OPTION_ID
		);

/* STOCK_HISTORY */
CREATE TABLE STOCK_HISTORY (
	HISTORY_ID NUMBER NOT NULL, /* 히스토리번호 */
	SELLER_NO NUMBER(10), /* 판매자번호 */
	OPTION_ID NUMBER(10) NOT NULL, /* 재고번호 */
	CHANGE_TYPE VARCHAR2(10) NOT NULL, /* 변동유형 */
	QUANTITY NUMBER NOT NULL, /* 수량 */
	REASON VARCHAR2(200), /* 사유 */
	REG_DATE DATE /* 등록일 */
);

CREATE UNIQUE INDEX PK_STOCK_HISTORY
	ON STOCK_HISTORY (
		HISTORY_ID ASC
	);

ALTER TABLE STOCK_HISTORY
	ADD
		CONSTRAINT PK_STOCK_HISTORY
		PRIMARY KEY (
			HISTORY_ID
		);

ALTER TABLE STOCK_HISTORY
	ADD
		CONSTRAINT CK_CHANGE_TYPE
		CHECK (CHANGE_TYPE IN ('입고', '판매', '반품', '조정'));

ALTER TABLE STOCK_HISTORY
	ADD
		CONSTRAINT CK_QUANTITY
		CHECK (QUANTITY > 0);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_SELLER_TO_PRODUCT
		FOREIGN KEY (
			seller_no
		)
		REFERENCES SELLER (
			seller_no
		);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_SUB_CATEGORY_TO_PRODUCT
		FOREIGN KEY (
			sub_category_no
		)
		REFERENCES SUB_CATEGORY (
			sub_category_no
		);

ALTER TABLE DELIVERY
	ADD
		CONSTRAINT FK_ORDERS_TO_DELIVERY
		FOREIGN KEY (
			order_no
		)
		REFERENCES ORDERS (
			order_no
		);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT FK_DELIVERY_ADDRESS_TO_ORDERS
		FOREIGN KEY (
			address_no
		)
		REFERENCES DELIVERY_ADDRESS (
			address_no
		);

ALTER TABLE ORDERS
	ADD
		CONSTRAINT FK_MEMBER_TO_ORDERS
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE DELIVERY_ADDRESS
	ADD
		CONSTRAINT FK_MEMBER_TO_DELIVERY_ADDRESS
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE ORDER_DETAIL 
	ADD
		CONSTRAINT FK_ORDERS_TO_ORDER_DETAIL 
		FOREIGN KEY (
			order_no
		)
		REFERENCES ORDERS (
			order_no
		);

ALTER TABLE ORDER_DETAIL 
	ADD
		CONSTRAINT FK_PRODUCT_TO_ORDER_DETAIL 
		FOREIGN KEY (
			product_no
		)
		REFERENCES PRODUCT (
			product_no
		);

ALTER TABLE ORDER_DETAIL 
	ADD
		CONSTRAINT FK_PRODUCT_OPTION_TO_ORDER_DETAIL 
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);

ALTER TABLE CART
	ADD
		CONSTRAINT FK_MEMBER_TO_CART
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE CART
	ADD
		CONSTRAINT FK_PRODUCT_OPTION_TO_CART
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);

ALTER TABLE WISHLIST
	ADD
		CONSTRAINT FK_MEMBER_TO_WISHLIST
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE WISHLIST
	ADD
		CONSTRAINT FK_PRODUCT_OPTION_TO_WISHLIST
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);

ALTER TABLE PAYMENT
	ADD
		CONSTRAINT FK_ORDERS_TO_PAYMENT
		FOREIGN KEY (
			order_no
		)
		REFERENCES ORDERS (
			order_no
		);

ALTER TABLE PAYMENT
	ADD
		CONSTRAINT FK_MEMBER_TO_PAYMENT
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT FK_PRODUCT_TO_REVIEW
		FOREIGN KEY (
			product_no
		)
		REFERENCES PRODUCT (
			product_no
		);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT FK_MEMBER_TO_REVIEW
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE MAIN_CATEGORY
	ADD
		CONSTRAINT FK_ADMIN_TO_MAIN_CATEGORY
		FOREIGN KEY (
			admin_no
		)
		REFERENCES ADMIN  (
			admin_no
		);

ALTER TABLE SUB_CATEGORY
	ADD
		CONSTRAINT FK_MID_CATEGORY_TO_SUB_CATEGORY
		FOREIGN KEY (
			mid_category_no
		)
		REFERENCES MID_CATEGORY (
			mid_category_no
		);

ALTER TABLE MID_CATEGORY
	ADD
		CONSTRAINT FK_MAIN_CATEGORY_TO_MID_CATEGORY
		FOREIGN KEY (
			main_category_no
		)
		REFERENCES MAIN_CATEGORY (
			main_category_no
		);

ALTER TABLE PRODUCT_RETURN
	ADD
		CONSTRAINT FK_ORDER_DETAIL_TO_RETURN
		FOREIGN KEY (
			order_detail_no
		)
		REFERENCES ORDER_DETAIL  (
			order_detail_no
		);

ALTER TABLE PRODUCT_INQUIRY 
	ADD
		CONSTRAINT FK_MEMBER_TO_PRODUCT_INQUIRY 
		FOREIGN KEY (
			member_no
		)
		REFERENCES MEMBER (
			member_no
		);

ALTER TABLE PRODUCT_INQUIRY 
	ADD
		CONSTRAINT FK_PRODUCT_OPTION_TO_PRODUCT_INQUIRY 
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);

ALTER TABLE PRODUCT_INQUIRY_ANSWER
	ADD
		CONSTRAINT FK_PRODUCT_INQUIRY_TO_PRODUCT_INQUIRY_ANSWER
		FOREIGN KEY (
			inquiry_no
		)
		REFERENCES PRODUCT_INQUIRY  (
			inquiry_no
		);

ALTER TABLE PRODUCT_INQUIRY_ANSWER
	ADD
		CONSTRAINT FK_SELLER_TO_PRODUCT_INQUIRY_ANSWER
		FOREIGN KEY (
			seller_no
		)
		REFERENCES SELLER (
			seller_no
		);

ALTER TABLE PRODUCT_OPTION
	ADD
		CONSTRAINT FK_PRODUCT_TO_PRODUCT_OPTION
		FOREIGN KEY (
			product_no
		)
		REFERENCES PRODUCT (
			product_no
		);

ALTER TABLE STOCK_HISTORY
	ADD
		CONSTRAINT FK_STOCK_OPTION
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);

ALTER TABLE STOCK_HISTORY
	ADD
		CONSTRAINT FK_SELLER_TO_STOCK_HISTORY
		FOREIGN KEY (
			SELLER_NO
		)
		REFERENCES SELLER (
			seller_no
		);
		

-- 재고 테이블 추가
CREATE TABLE PRODUCT_IN (
	IN_NO NUMBER(10) NOT NULL, /* I */
	QUANTITY NUMBER(10) NOT NULL, /* 입고수량 */
	CREATED DATE NOT NULL, /* 입고일자 */
	OPTION_ID NUMBER(10) NOT NULL /* 재고번호 */
);

CREATE UNIQUE INDEX PK_PRODUCT_IN
	ON PRODUCT_IN (
		IN_NO ASC
	);

ALTER TABLE PRODUCT_IN
	ADD
		CONSTRAINT PK_PRODUCT_IN
		PRIMARY KEY (
			IN_NO
		);

ALTER TABLE PRODUCT_IN
	ADD
		CONSTRAINT FK_PRODUCT_OPTION_TO_PRODUCT_IN
		FOREIGN KEY (
			OPTION_ID
		)
		REFERENCES PRODUCT_OPTION (
			OPTION_ID
		);				
		
-- 상품입고트리거 추가		
CREATE OR REPLACE TRIGGER TRG_PRODUCT_IN_STOCK
AFTER INSERT ON PRODUCT_IN FOR EACH ROW
BEGIN
    UPDATE PRODUCT_OPTION
    SET QUANTITY = QUANTITY + :NEW.QUANTITY, STATUS = 'Y'
    WHERE OPTION_ID = :NEW.OPTION_ID;
END;			


-- 회원 ( MEMBER )

CREATE SEQUENCE SEQ_MEMBER_NO
START WITH 1
INCREMENT BY 1;

ALTER TABLE MEMBER
MODIFY MEMBER_NO
DEFAULT SEQ_MEMBER_NO.NEXTVAL;

INSERT INTO MEMBER (member_id, member_pw, member_name, phone, email, rank)
    VALUES ('member1', 'AGeklJKKLJAGKLAklegjKL', '홍길동', '010-3222-1780', 'hong@gmail.com', '일반회원');
INSERT INTO MEMBER (member_id, member_pw, member_name, phone, email, rank)
    VALUES ('member2', 'FAwAGeklJKKLJAGKLAklegjKL', '이상섭', '010-5272-3320', 'sangsub@gmail.com', '일반회원');
INSERT INTO MEMBER (member_id, member_pw, member_name, phone, email, rank)
    VALUES ('member3', 'Ss1AGeklJKKLJAGKLAklegjKL', '박지호', '010-3155-5580', 'jiho123@gmail.com', '와우회원');

CREATE SEQUENCE SEQ_DELIVERY_ADDRESS_NO
START WITH 1
INCREMENT BY 1;

ALTER TABLE DELIVERY_ADDRESS
MODIFY ADDRESS_NO
DEFAULT SEQ_DELIVERY_ADDRESS_NO.NEXTVAL;


INSERT INTO DELIVERY_ADDRESS (member_no, receiver_name, tel, zipcode, address, detail_address, request_msg, address_default)
VALUES (1, '홍길동', '010-3222-1780', 06678, '서울특별시 서초구 청두곶10길 15-13', '101호', '배송요청사항', 'Y');
INSERT INTO DELIVERY_ADDRESS (member_no, receiver_name, tel, zipcode, address, detail_address, request_msg, address_default)
VALUES (2, '이상섭', '010-5272-3320', 135010, '서울특별시 강남구 논현동 106-7', '501호', '배송요청사항', 'Y');
INSERT INTO DELIVERY_ADDRESS (member_no, receiver_name, tel, zipcode, address, detail_address, request_msg, address_default)
VALUES (3, '박지호', '010-3155-5580', 06136, '서울특별시 강남구 논현로106길 26-4', '702호', '배송요청사항', 'Y');
--

-- 상품등록

CREATE OR REPLACE TRIGGER TRG_PRODUCT_IN_STOCK
AFTER INSERT ON PRODUCT_IN FOR EACH ROW
BEGIN
    UPDATE PRODUCT_OPTION
    SET QUANTITY = QUANTITY + :NEW.QUANTITY, STATUS = 'Y'
    WHERE OPTION_ID = :NEW.OPTION_ID;
END;			


DROP SEQUENCE SEQ_SELLER;
DROP SEQUENCE SEQ_PRODUCT;
DROP SEQUENCE SEQ_OPTION;
DROP SEQUENCE SEQ_PRODUCT_IN;
DROP SEQUENCE SEQ_STOCK_HISTORY;

CREATE SEQUENCE SEQ_SELLER        START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_PRODUCT       START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_OPTION        START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_PRODUCT_IN    START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_STOCK_HISTORY START WITH 1 INCREMENT BY 1 NOCACHE;

SELECT * FROM PRODUCT;
-- 상품등록
INSERT INTO PRODUCT VALUES (SEQ_PRODUCT.NEXTVAL, '남성 반팔 티셔츠', '기본 코튼 소재의 남성 반팔 티셔츠',  29000,  0, 5, 100301);

-- 상품옵션등록
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL,1, '사이즈','S',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, 1, '사이즈','M',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, 1, '사이즈','L',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, 1, '사이즈','XL', NULL,NULL, NULL,NULL, 29000, 0, 'N');

SELECT * FROM PRODUCT_OPTION;

EXEC UP_PRODUCT_IN(5, 10);


-- 상품입고 프로시저
CREATE OR REPLACE PROCEDURE UP_PRODUCT_IN (
-- 신창만
-- 입고 프로시저. 옵션번호와 수량을 입력하면 해당 상품이 입고된다.
-- 사용법 :  EXEC UP_PRODUCT_IN(옵션번호, 수량);
    P_OPTION_NO IN PRODUCT_IN.OPTION_ID%TYPE,
    P_QUANTITY  IN PRODUCT_IN.QUANTITY%TYPE
) IS
BEGIN
    INSERT INTO PRODUCT_IN
    VALUES (SEQ_PRODUCT_IN.NEXTVAL, P_QUANTITY, SYSDATE, P_OPTION_NO);

    COMMIT;
END ;

-- 회원가입 프로시저
CREATE OR REPLACE PROCEDURE MEMBER_INSERT (
-- 회원 가입
-- EXEC member_insert(회원id, 비밀번호, 이름, 전화번호, 이메일);
-- 신창만
    P_MEMBER_ID   IN MEMBER.MEMBER_ID%TYPE,
    P_MEMBER_PW   IN MEMBER.MEMBER_PW%TYPE,
    P_MEMBER_NAME IN MEMBER.MEMBER_NAME%TYPE,
    P_PHONE       IN MEMBER.PHONE%TYPE,
    P_EMAIL       IN MEMBER.EMAIL%TYPE
) IS
BEGIN
    INSERT INTO MEMBER ( member_id, member_pw, member_name, phone, email, rank)
    VALUES (P_MEMBER_ID, P_MEMBER_PW, P_MEMBER_NAME, P_PHONE, P_EMAIL, '일반회원');

    COMMIT;
END ;

-- 판매자 가입 프로시저
CREATE OR REPLACE PROCEDURE SELLER_INSERT (
-- 판매자 가입
-- 사용법 : EXEC SELLER_INSERT(
-- 신창만
    P_BUSINESS_ADDRESS   IN SELLER.BUSINESS_ADDRESS%TYPE,
    P_SETTLEMENT_ACCOUNT IN SELLER.SETTLEMENT_ACCOUNT%TYPE,
    P_BUSINESS_NO        IN SELLER.BUSINESS_NO%TYPE,
    P_STORE_NAME         IN SELLER.STORE_NAME%TYPE,
    P_BANK_NAME          IN SELLER.BANK_NAME%TYPE,
    P_SELLER_ID          IN SELLER.SELLER_ID%TYPE,
    P_SELLER_PW          IN SELLER.SELLER_PW%TYPE,
    P_CEO_NAME           IN SELLER.CEO_NAME%TYPE,
    P_TEL                IN SELLER.TEL%TYPE,
    P_EMAIL              IN SELLER.EMAIL%TYPE
) IS
BEGIN
    INSERT INTO SELLER (
        seller_no, business_address, settlement_account, business_no,
        store_name, bank_name, seller_id, seller_pw, ceo_name, tel, email
    )
    VALUES (
        SEQ_SELLER.NEXTVAL, P_BUSINESS_ADDRESS, P_SETTLEMENT_ACCOUNT, P_BUSINESS_NO,
        P_STORE_NAME, P_BANK_NAME, P_SELLER_ID, P_SELLER_PW, P_CEO_NAME, P_TEL, P_EMAIL
    );

    COMMIT;
END ;

-- 상품등록
INSERT INTO PRODUCT VALUES (SEQ_PRODUCT.NEXTVAL, '남성 반팔 티셔츠', '기본 코튼 소재의 남성 반팔 티셔츠',  29000,  0, 5, 100301);

-- 상품옵션등록
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, SEQ_PRODUCT.CURRVAL, '사이즈','S',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, SEQ_PRODUCT.CURRVAL, '사이즈','M',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, SEQ_PRODUCT.CURRVAL, '사이즈','L',  NULL,NULL, NULL,NULL, 29000, 0, 'N');
INSERT INTO PRODUCT_OPTION VALUES (SEQ_OPTION.NEXTVAL, SEQ_PRODUCT.CURRVAL, '사이즈','XL', NULL,NULL, NULL,NULL, 29000, 0, 'N');

-- 상품입고
EXEC UP_PRODUCT_IN(옵션번호, 수량);
EXEC UP_PRODUCT_IN(28, 5);

-- 1번 판매자가 등록한 상품조회
SELECT p.*,
       mc.main_category_name,
       md.mid_category_name,
       sc.sub_category_name
FROM   PRODUCT p
       JOIN SUB_CATEGORY  sc ON p.sub_category_no  = sc.sub_category_no
       JOIN MID_CATEGORY  md ON sc.mid_category_no = md.mid_category_no
       JOIN MAIN_CATEGORY mc ON md.main_category_no = mc.main_category_no
WHERE  p.seller_no = 1;

SELECT mc.main_category_no,
       mc.main_category_name,
       md.mid_category_no,
       md.mid_category_name,
       sc.sub_category_no,
       sc.sub_category_name
FROM   MAIN_CATEGORY mc
       LEFT JOIN MID_CATEGORY md ON mc.main_category_no = md.main_category_no
       LEFT JOIN SUB_CATEGORY sc ON md.mid_category_no  = sc.mid_category_no
ORDER  BY mc.main_category_no, md.mid_category_no, sc.sub_category_no;



-- QA를 위한 카테고리별 상품갯수
SELECT mc.main_category_no,
       mc.main_category_name,
       md.mid_category_no,
       md.mid_category_name,
       sc.sub_category_no,
       sc.sub_category_name,
       COUNT(p.product_no) AS product_count
FROM   MAIN_CATEGORY mc
       LEFT JOIN MID_CATEGORY md ON mc.main_category_no = md.main_category_no
       LEFT JOIN SUB_CATEGORY sc ON md.mid_category_no  = sc.mid_category_no
       LEFT JOIN PRODUCT p       ON sc.sub_category_no  = p.sub_category_no
GROUP  BY mc.main_category_no, mc.main_category_name,
          md.mid_category_no, md.mid_category_name,
          sc.sub_category_no, sc.sub_category_name
ORDER  BY mc.main_category_no, md.mid_category_no, sc.sub_category_no;


SELECT p.product_no,
       p.product_name,
       p.product_price,
       p.quantity,
       p.seller_no,
       sc.sub_category_name
FROM   PRODUCT p
       JOIN SUB_CATEGORY sc ON p.sub_category_no = sc.sub_category_no
WHERE  p.sub_category_no = 100202; -- 소분류번호 


-- EXEC member_insert(회원id, 비밀번호, 이름, 전화번호, 이메일);
EXEC member_insert('member5', '1234', '홍길동3', '010-3222-1780', 'hong@gmail.com');


-- EXEC seller_insert(사업장주소,계좌번호,사업자번호,상호명,은행명, 아이디, 비밀번호, 대표자명, 전화번호, 이메일) 

EXEC seller_insert('서울시 강남구 테헤란로','110-234-567890','110-22-33331','청담베스트의류','국민은행', 'bestone', 'pw1234', '이상민', '010-1111-2222', 'bestone@gmail.com') ;





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

-------------------------------------------------------------

--주문

--시퀀스 삭제

DROP SEQUENCE SEQ_ORDERS;
DROP SEQUENCE SEQ_ORDER_DETAIL;


--- 시퀀스 생성
CREATE SEQUENCE SEQ_ORDERS
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE SEQ_ORDER_DETAIL
START WITH 1
INCREMENT BY 1
NOCACHE;
--

CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER
(
    P_MEMBER_NO       IN ORDERS.MEMBER_NO%TYPE,
    P_ADDRESS_NO      IN ORDERS.ADDRESS_NO%TYPE,
    P_PAYMENT_METHOD  IN ORDERS.PAYMENT_METHOD%TYPE,
    P_TOTAL_PRICE     IN ORDERS.TOTAL_PRICE%TYPE,
    --PRODUCT_OPTION 
    P_OPTION_ID IN PRODUCT_OPTION.OPTION_ID%TYPE,
    P_QTY IN NUMBER
 
)
IS
    V_DELIVERY_FEE NUMBER;
    V_STOCK NUMBER;
    V_ORDER_NO ORDERS.ORDER_NO%TYPE;
BEGIN
--상품 재고 < 주문 수량 일시 재고 부족. 

  UPDATE PRODUCT_OPTION
  SET quantity = quantity - P_QTY
  WHERE OPTION_ID = P_OPTION_ID
  AND quantity >= P_QTY;

  IF SQL%ROWCOUNT = 0 THEN
  RAISE_APPLICATION_ERROR(-20001, '재고 부족');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('재고 차감 완료');
  DBMS_OUTPUT.PUT_LINE('옵션번호 : ' || P_OPTION_ID);
  DBMS_OUTPUT.PUT_LINE('주문수량 : ' || P_QTY);


-- 총 금액이 20,000원 이상이면 배송비 무료

    IF P_TOTAL_PRICE >= 20000 THEN
        V_DELIVERY_FEE := 0;
    ELSE
        V_DELIVERY_FEE := 3000;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('배송비 계산 완료');
    DBMS_OUTPUT.PUT_LINE('배송비 : ' || V_DELIVERY_FEE);

    INSERT INTO ORDERS
    (
        ORDER_NO,
        MEMBER_NO,
        ADDRESS_NO,
        ORDER_DATE,
        PAYMENT_METHOD,
        DELIVERY_FEE,
        TOTAL_PRICE,
        ORDER_STATUS
    )
    VALUES
    (
        SEQ_ORDERS.NEXTVAL,
        P_MEMBER_NO,
        P_ADDRESS_NO,
        SYSDATE,
        P_PAYMENT_METHOD,
        V_DELIVERY_FEE,
        P_TOTAL_PRICE,
        '결제완료'
)
    RETURNING ORDER_NO INTO V_ORDER_NO;
    
    DBMS_OUTPUT.PUT_LINE('주문 생성 완료');
    DBMS_OUTPUT.PUT_LINE('주문번호 : ' || V_ORDER_NO);

--주문 상세 TABLE 연결

INSERT INTO ORDER_DETAIL
( order_detail_no,
    order_no,
    product_no,
    order_qty,
    price,
    option_id
)
VALUES
(
    SEQ_ORDER_DETAIL.NEXTVAL,
    V_ORDER_NO,
    (SELECT product_no FROM product_option WHERE option_id = P_OPTION_ID),
    P_QTY,
    (SELECT price FROM product_option WHERE option_id = P_OPTION_ID),
    P_OPTION_ID
);

DBMS_OUTPUT.PUT_LINE('주문상세 등록 완료');
DBMS_OUTPUT.PUT_LINE('상품 옵션 : ' || P_OPTION_ID);
DBMS_OUTPUT.PUT_LINE('주문 수량 : ' || P_QTY);

    DBMS_OUTPUT.PUT_LINE('========================');
    DBMS_OUTPUT.PUT_LINE('최종 결제 정보');
    DBMS_OUTPUT.PUT_LINE('상품금액 : ' || P_TOTAL_PRICE);
    DBMS_OUTPUT.PUT_LINE('배송비 : ' || V_DELIVERY_FEE);
    DBMS_OUTPUT.PUT_LINE('총 결제금액 : ' || (P_TOTAL_PRICE + V_DELIVERY_FEE));
    DBMS_OUTPUT.PUT_LINE('========================');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
         DBMS_OUTPUT.PUT_LINE('주문 처리 실패');
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' : ' || SQLERRM);
        
        RAISE;
END;
/

--


COMMIT;


-- 확인 작업

BEGIN
    PROC_INSERT_ORDER(
        P_MEMBER_NO => 1,
        P_ADDRESS_NO => 2,
        P_PAYMENT_METHOD => '카드',
        P_TOTAL_PRICE => 25000,
        P_OPTION_ID => 10,
        P_QTY => 2
    );
END;
/

EXEC

BEGIN
    PROC_INSERT_ORDER(
       1,
       2,
       '카드',
        15000,
        5,
        3
    );
END;
/

SELECT * FROM PRODUCT_OPTION;
UPDATE PRODUCT_OPTION SET QUANTITY = 50;
COMMIT;


WHERE OPTION_ID = 10;
SELECT * FROM PRODUCT;

SELECT
    S.STORE_NAME,
    P.PRODUCT_NO,
    P.PRODUCT_NAME,
    O.OPTION_ID,
    O.OPTION1_TYPE,
    O.OPTION1_VALUE,
    O.OPTION2_TYPE,
    O.OPTION2_VALUE,
    O.OPTION3_TYPE,
    O.OPTION3_VALUE,
    NVL(O.PRICE, P.PRODUCT_PRICE)    AS 판매가,
    O.QUANTITY                        AS 재고,
    O.STATUS                          AS 판매여부
FROM PRODUCT_OPTION O
JOIN PRODUCT P ON O.PRODUCT_NO  = P.PRODUCT_NO
JOIN SELLER  S ON P.SELLER_NO   = S.SELLER_NO
WHERE P.PRODUCT_NO = 1 
ORDER BY O.PRODUCT_NO, O.OPTION_ID;




SELECT * FROM PRODUCT_OPTION;

UPDATE PRODUCT_OPTION SET QUANTITY = 50 

WHERE OPTION_ID = 5;




SELECT MAX(order_no) FROM orders;

DROP SEQUENCE SEQ_ORDERS;

CREATE SEQUENCE SEQ_ORDERS
START WITH (MAX(order_no)+1)
INCREMENT BY 1;

ALTER SEQUENCE SEQ_ORDERS INCREMENT BY 100;

SELECT SEQ_ORDERS.NEXTVAL FROM dual;
ALTER SEQUENCE SEQ_ORDERS INCREMENT BY 1;


DESC PRODUCT_OPTION;


DESC ORDER_DETAIL;



SELECT *
FROM PRODUCT_OPTION;












