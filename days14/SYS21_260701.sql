ORDER_DETAIL 
order_detail_no(PK)	N/A	NUMBER(10)
order_no(FK)	N/A	NUMBER(10)
product_no(FK)	N/A	NUMBER(10)
order_qty	N/A	NUMBER(5)
price	N/A	NUMBER(10)
OPTION_ID(FK)	N/A	NUMBER(10)


INSERT INTO ORDER_DETAIL
VALUES (
    SEQ_ORDER_DETAIL.NEXTVAL,
    V_ORDER_NO,
    P_PRODUCT_NO,
    P_QTY,
    P_PRICE,
    P_OPTION_ID
);

INSERT INTO ORDER_DETAIL
(
    order_detail_no,
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