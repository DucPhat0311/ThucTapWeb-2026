package dao.user;

import dao.core.BaseDao;
import model.Contact;

public class ContactDao extends BaseDao {
    public void addContact(Contact contact) {
        getJdbi().withHandle(handle -> handle.createUpdate("""
                INSERT INTO contacts(user_id, name, email, phone, address, message, status, created_at)
                VALUES (:userId, :name, :email, :phone, :address, :message, 'New', NOW())
                """
                ).bind("userId", contact.getUserId())
                .bind("name", contact.getName())
                .bind("email", contact.getEmail())
                .bind("phone", contact.getPhone())
                .bind("address", contact.getAddress())
                .bind("message", contact.getMessage())
                .execute());
    }
}
