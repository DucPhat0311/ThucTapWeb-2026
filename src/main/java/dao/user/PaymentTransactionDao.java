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
}
