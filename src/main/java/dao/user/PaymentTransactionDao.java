package dao.user;

import dao.core.BaseDao;

public class PaymentTransactionDao extends BaseDao {
    public void createInitiatedTransaction(int orderId,
                                           String provider,
                                           String txnRef,
                                           double amount,
                                           String transactionStatus) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            INSERT INTO payment_transactions (
                order_id,
                provider,
                txn_ref,
                amount,
                transaction_status
            )
            VALUES (
                :orderId,
                :provider,
                :txnRef,
                :amount,
                :transactionStatus
            )
        """)
                        .bind("orderId", orderId)
                        .bind("provider", provider)
                        .bind("txnRef", txnRef)
                        .bind("amount", amount)
                        .bind("transactionStatus", transactionStatus)
                        .execute()
        );
    }

    public Integer findOrderIdByTxnRef(String txnRef) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
            SELECT order_id
            FROM payment_transactions
            WHERE txn_ref = :txnRef
        """)
                        .bind("txnRef", txnRef)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void updatePaymentResult(String txnRef,
                                    String transactionNo,
                                    String bankCode,
                                    String responseCode,
                                    String transactionStatus) {
        getJdbi().useHandle(h ->
                h.createUpdate("""
            UPDATE payment_transactions
            SET transaction_no = :transactionNo,
                bank_code = :bankCode,
                response_code = :responseCode,
                transaction_status = :transactionStatus
            WHERE txn_ref = :txnRef
        """)
                        .bind("transactionNo", transactionNo)
                        .bind("bankCode", bankCode)
                        .bind("responseCode", responseCode)
                        .bind("transactionStatus", transactionStatus)
                        .bind("txnRef", txnRef)
                        .execute()
        );
    }
}
